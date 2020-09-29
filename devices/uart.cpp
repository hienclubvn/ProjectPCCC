#include "uart.hpp"

Uart::Uart()
{
    m_serial=new QSerialPort(this);
    connect(m_serial, &QSerialPort::errorOccurred, this, &Uart::handleError);
    connect(m_serial, &QSerialPort::readyRead, this, &Uart::readData);
    connect(this,&Uart::receiveCompleted,this,&Uart::OnReceiveCompleted);
    m_receiveText="";
    //
    density_smoke = 0.0;
}
bool Uart::getState()
{
    return connection_state;
}

void Uart::setState(bool value)
{
    connection_state = value;
}
void Uart::OnReceiveCompleted()
{
    qDebug()<< "receive complete"<< m_receiveText;
    //receive complete "\u001B000.0 00.00 ----- 036 ---\r"
    QString data_subString = m_receiveText.mid(1,5); //OK-Pass(1,5)
    //qDebug()<<"density_smoke = " << data_subString;
    try {
        density_smoke = data_subString.toFloat();
    } catch (error_t) {}

    //qDebug()<<"density_smoke = "<<density_smoke;
    m_receiveText = ""; //clear
    emit readSmokeCompleted();

}
void Uart::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        qDebug()<< m_serial->errorString();
        closeSerialPort();
    }
}
void Uart::readData()
{
    const QByteArray data = m_serial->readAll();
    for (int i=0;i<data.length();i++) {
        m_receiveText +=data[i];
        if (data[i]==13) emit receiveCompleted();
    }
}
void Uart::writeData(const QByteArray &data)
{
    if (connection_state == true)
        m_serial->write(data);
}
void Uart::openSerialPort()
{
    if (m_serial->isOpen()) return;
    m_serial->setPortName("/dev/" + settings->uartParam.getPortName());
    m_serial->setBaudRate(settings->uartParam.getBaudrate());
    m_serial->setDataBits((QSerialPort::DataBits)settings->uartParam.getDataBits());

    if (settings->uartParam.getParity() == "None") m_serial->setParity(QSerialPort::NoParity);
    else if (settings->uartParam.getParity() == "Even") m_serial->setParity(QSerialPort::EvenParity);
    else if (settings->uartParam.getParity() == "Odd") m_serial->setParity(QSerialPort::OddParity);
    m_serial->setStopBits(( QSerialPort::StopBits)settings->uartParam.getStopBits());

    if (m_serial->open(QIODevice::ReadWrite)) {
//        sendRequest();
        qDebug() << "Uart-connect ";
        connection_state = true;
        emit varChanged();
    } else {
        qDebug()<< m_serial->errorString();
        connection_state = false;
        emit varChanged();
    }
}
void Uart::closeSerialPort()
{
    if (m_serial->isOpen())
        m_serial->close();
    connection_state = false;
    qDebug() << "Uart-Ngat ket noi!";
    emit varChanged();
}
Uart::~Uart() {
  m_serial->close();
  delete m_serial;
  m_serial = nullptr;
}
