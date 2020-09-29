#include "rs485.hpp"

RS485::RS485()
{
    m_rs485=new QSerialPort(this);
    connect(m_rs485, &QSerialPort::errorOccurred, this, &RS485::handleError);
    connect(m_rs485, &QSerialPort::readyRead, this, &RS485::readData);
    connect(this,&RS485::receiveCompleted,this,&RS485::OnReceiveCompleted);
    m_receiveText="";
    //
    //density_smoke = 0.0;
}
bool RS485::getState()
{
    return connection_state;
}

void RS485::setState(bool value)
{
    connection_state = value;
}
void RS485::OnReceiveCompleted()
{
    qDebug()<< "RS485-ICP"<< m_receiveText << "Length: " <<m_receiveText.count();

    //receive complete "\r>+00.586+00.520+00.461+00.408+00.362+05.681+00.709+00.656"
    //receive complete "\r>+00.576+00.511+00.452+00.401+00.355+05.682+00.709+00.655"
    //receive complete ">+00.582+00.515+00.456+00.404+00.358+05.682+00.709+00.655\r"
    //receive complete ">+00.710+00.ÿL\u0098\u0097555+00.492+00.429+06.895+00.861+00.797\r" error
    //>+00.265+00.236+00.210+00.187+00.167+02.561+00.317+00.291\r
    //
    //
    if ((m_receiveText.count() == 58) && (m_receiveText[0] == '>')) //OK-PASSED
    {
        int index = 1;
        //
        for (int i = 0; i < 8; i++) {
            dataFloat[i] = m_receiveText.mid(index, 7).toFloat(); //OK-PASSED
            //qDebug()<<"i = " << i << "Float: " <<dataFloat[i] << "str:" << m_receiveText.mid(index, 7); //OK-PASSED
            index = index + 7;
        }
        //
        //volt_supply_sensor = dataFloat[5]*3;
        //volt_sensor_respone = dataFloat[6];
    }

    //QStringList splitted ;
    //splitted = m_receiveText.split("+");
    //qDebug()<< "length = " << splitted.length(); //9
    //
//    if (splitted.length() == 9) //9=ok
//    {
//        try {
//            volt_supply_sensor = splitted[6].toFloat()*3;
//            volt_sensor_respone = splitted[7].toFloat();
//        } catch (error_t) { }
//    }

    //    qDebug()<< "splitted[0]" <<splitted[0]; //">"
    //qDebug()<< "volt_supply_sensor" <<volt_supply_sensor;
    //qDebug()<< "volt_sensor_respone" <<volt_sensor_respone;

    m_receiveText = ""; //clear

    emit readVoltICPCompleted();

}
void RS485::handleError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::ResourceError) {
        qDebug()<< m_rs485->errorString();
        closeSerialPort();
    }
}
void RS485::readData()
{
    const QByteArray data = m_rs485->readAll();
    for (int i=0;i<data.length();i++) {
        m_receiveText +=data[i];
        if (data[i]==13) emit receiveCompleted();
    }
}
void RS485::writeData(const QByteArray &data)
{
    if (connection_state == true)
        m_rs485->write(data);
}
void RS485::openSerialPort()
{
    if (m_rs485->isOpen()) return;
    m_rs485->setPortName("/dev/" + settings->rs485ICPParam.getPortName());
    m_rs485->setBaudRate(settings->rs485ICPParam.getBaudrate());
    m_rs485->setDataBits((QSerialPort::DataBits)settings->rs485ICPParam.getDataBits());

    if (settings->rs485ICPParam.getParity() == "None") m_rs485->setParity(QSerialPort::NoParity);
    else if (settings->rs485ICPParam.getParity() == "Even") m_rs485->setParity(QSerialPort::EvenParity);
    else if (settings->rs485ICPParam.getParity() == "Odd") m_rs485->setParity(QSerialPort::OddParity);
    m_rs485->setStopBits(( QSerialPort::StopBits)settings->rs485ICPParam.getStopBits());

    if (m_rs485->open(QIODevice::ReadWrite)) {
        //        sendRequest();
        qDebug() << "RS485ICP-connect ";
        connection_state = true;
        emit varChanged();
    } else {
        qDebug()<< m_rs485->errorString();
        connection_state = false;
        emit varChanged();
    }
}
void RS485::closeSerialPort()
{
    if (m_rs485->isOpen())
        m_rs485->close();
    connection_state = false;
    qDebug() << "RS485ICP-Ngat ket noi!";
    emit varChanged();
}
RS485::~RS485() {
    m_rs485->close();
    delete m_rs485;
    m_rs485 = nullptr;
}
