#include "modbus.hpp"
#include <QObject>
#include <QModbusRtuSerialMaster>
#include <QThread>
Modbus::Modbus()  {
    modbusDevice = new QModbusRtuSerialMaster();
    holding_register_store = new int (10);
    holding_register_store_PVSP = new int (10); //nNumAddress
    nBytes= 0;
}

bool Modbus::startConnection() {
    // CAI DAT THONG SO CHO MODBUS
    if (modbusDevice->state()==QModbusDevice::ConnectedState)
    {
        modbusDevice->disconnectDevice();
    }
    // PORT NAME
    modbusDevice->setConnectionParameter(QModbusDevice::SerialPortNameParameter, "/dev/"+ settings->modbusParam.getPortName());
    // BAUDRATE
    modbusDevice->setConnectionParameter(QModbusDevice::SerialBaudRateParameter,settings->modbusParam.getBaudrate());

    // PARITY
    if (settings->modbusParam.getParity() == "None") modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter,QSerialPort::NoParity);
    else if (settings->modbusParam.getParity() == "Even") modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter,QSerialPort::EvenParity);
    else if (settings->modbusParam.getParity() == "Odd") modbusDevice->setConnectionParameter(QModbusDevice::SerialParityParameter,QSerialPort::OddParity);
    // DATA BITS
    modbusDevice->setConnectionParameter(QModbusDevice::SerialDataBitsParameter, settings->modbusParam.getDataBits());
    // STOP BITS
    modbusDevice->setConnectionParameter(QModbusDevice::SerialStopBitsParameter, settings->modbusParam.getStopBits());
    if (!modbusDevice->connectDevice())
    {
      qDebug() << "ModbusRTU-cannot connect ";
      connection_state = false;
      emit varChanged();
    }
    else
    {
      qDebug() << "ModbusRTU-connect ";
      connection_state = true;
      emit varChanged();
    }

    //qDebug() << "error: " << modbusDevice->errorString();
    //qDebug() << "state: " << modbusDevice->state();
    return true;
}

//FC06
void Modbus::writeSingleHoldingRegister(int add, int value,int server)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    QModbusDataUnit reg(QModbusDataUnit::HoldingRegisters,add,1);
    reg.setValue(0,value);
    QModbusReply *reply;
    reply = modbusDevice->sendWriteRequest(reg,server);
    if (reply) {
        if (!reply->isFinished())
          connect(reply, &QModbusReply::finished, this, &Modbus::writeSingleHoldingRegisterCompleted);
      } else
        qDebug() << "Write Single Holding Resister Error!";
}
void Modbus::writeSingleHoldingRegisterCompleted()
{
//    qDebug() << "Write Single Holding Resister Completed!";  
    emit writeSingleHoldingRegisterCompletedOK();
    isBusy = false;
}

//
void Modbus::readSingleHoldingRegister (int add, int ID,int *data)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    //startConnection();
    QModbusDataUnit readUnit(QModbusDataUnit::HoldingRegisters, add,1);
    if (auto *reply = modbusDevice->sendReadRequest(readUnit, ID)) {
       //qDebug()<<"Reading single holding register ...";
      if (!reply->isFinished())
        connect(reply, &QModbusReply::finished, this, &Modbus::readSingleHoldingRegisterRecieved);
    } else
      qDebug() << "request error";
    holding_register_result= data;
}
void Modbus::readSingleHoldingRegisterRecieved()
{
    QModbusReply *reply = qobject_cast<QModbusReply *>(sender());
    const QModbusDataUnit result = reply->result();
    qDebug() << "read ";
    qDebug() << "";
    qDebug() << QString("The value is %1").arg(result.value(0));
    *holding_register_result = result.value(0);
    emit readSingleHoldingRegisterCompleted();

    isBusy = false;
}

void Modbus::writeSingleCoil (int add, bool value, int server)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    //startConnection();
    QModbusDataUnit reg(QModbusDataUnit::Coils,add,1);
    reg.setValue(0,value);
    QModbusReply *reply;
    reply = modbusDevice->sendWriteRequest(reg,server);
    if (reply) {
        if (!reply->isFinished())
          connect(reply, &QModbusReply::finished, this, &Modbus::writeSingleCoilComleted);
      } else
        qDebug() << "Write Single Coil Error!";
}

void Modbus::writeSingleCoilComleted()
{
    //    qDebug() << "Write Single Coil Completed!";
    isBusy = false;
}
//FC03 - 4x
void Modbus::readHoldingRegister(int server,int start_add, int number_register)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    nBytes = number_register;
    start_address = start_add;
    ID = server;
    nNumAddress = ID;

    QModbusDataUnit readUnit(QModbusDataUnit::HoldingRegisters, start_address,
                             static_cast<unsigned short>(nBytes));

    if (auto *reply = modbusDevice->sendReadRequest(readUnit, ID)) {
      if (!reply->isFinished())
        connect(reply, &QModbusReply::finished, this, &Modbus::readHoldingRegisterCompleted);
    } else
      qDebug() << "request error";
}

void Modbus::readHoldingRegisterCompleted() {
  QModbusReply *reply = qobject_cast<QModbusReply *>(sender());
  const QModbusDataUnit result = reply->result();
//  qDebug() << "read ";
//  qDebug() << "";

  if (nNumAddress == 0x07){
      for (int j = 0; j < nBytes; j++) {
         holding_register_store_PVSP[j] = result.value(j);
         //qDebug() <<"start_address:"<<nNumAddress<< QString("The value of %1 is %2").arg(j).arg(result.value(j));
         qDebug() <<"ModbusRTU, ID: "<<nNumAddress<<QString("The value of %1 is %2").arg(j).arg(result.value(j));
      }
      //emit readHoldingRegister0x47CompletedOK();
  }
  else  {
      for (int j = 0; j < nBytes; j++) {
          holding_register_store[j] = result.value(j);
          //qDebug() <<"start_address:"<<nNumAddressRespone<< QString("The value of %1 is %2").arg(j).arg(result.value(j));
          qDebug() <<"ModbusRTU, ID: "<<nNumAddress<<QString("The value of %1 is %2").arg(j).arg(result.value(j));
      }
      //emit readHoldingRegisterCompletedOK();
  }
  //
  emit readHoldingRegisterCompletedOK();
  isBusy = false;
}

void Modbus::readMultiCoils(int server,int start_add, int number_coils, bool *data)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    nBytes = number_coils;
    start_address = start_add;


    QModbusDataUnit readUnit(QModbusDataUnit::Coils, start_address,
                             static_cast<unsigned short>(nBytes));

    if (auto *reply = modbusDevice->sendReadRequest(readUnit, server)) {
      if (!reply->isFinished())
        //      connect the finished signal of the request to your read slot
        connect(reply, &QModbusReply::finished, this, &Modbus::readCoilsCompleted);
      //    else
      //      delete reply; // broadcast replies return immediately
    } else
      qDebug() << "request error";

    coil_result = data;
}

void Modbus::readCoilsCompleted()  {
  QModbusReply *reply = qobject_cast<QModbusReply *>(sender());
  const QModbusDataUnit result = reply->result();
//  qDebug() << "read ";
//  qDebug() << "";

  for (int j = 0; j < nBytes; j++)
  {
    coil_result[j] = result.value(j);
//    qDebug() << QString("The coil value of %1 is %2").arg(j).arg(result.value(j));
  }
  emit readCoilsCompletedSignal ();
  //
  isBusy = false;
}

void Modbus::readMultiDiscrete(int server,int start_add, int number_coils, bool *data)
{
    if (connection_state == false) return;
    //
    isBusy = true;
    //
    nDiscrete = number_coils;
    QModbusDataUnit readUnit(QModbusDataUnit::DiscreteInputs, start_add,
                             static_cast<unsigned short>(number_coils));

    if (auto *reply = modbusDevice->sendReadRequest(readUnit, server)) {
      if (!reply->isFinished())
        //      connect the finished signal of the request to your read slot
        connect(reply, &QModbusReply::finished, this, &Modbus::readDiscreteCompleted);
      //    else
      //      delete reply; // broadcast replies return immediately
    } else
      qDebug() << "request error";

     discrete_result= data;
}
void Modbus::readDiscreteCompleted()  {
  QModbusReply *reply = qobject_cast<QModbusReply *>(sender());
  const QModbusDataUnit result = reply->result();

  for (int j = 0; j < nDiscrete; j++)
  {
    discrete_result[j] = result.value(j);
//    qDebug() << QString("The Discrete Input value of %1 is %2").arg(j).arg(result.value(j));
  }
  emit readDiscreteCompletedSignal ();
  isBusy = false;
}
void Modbus::stopConnection()
{
    modbusDevice->disconnectDevice();
    connection_state = false;
    qDebug() << "ModbusRTU-Ngat ket noi!";
    emit varChanged();
}
Modbus::~Modbus() {
  modbusDevice->disconnectDevice();
  delete modbusDevice;
  modbusDevice = nullptr;
}

