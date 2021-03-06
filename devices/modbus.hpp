#ifndef MODBUS_HPP
#define MODBUS_HPP
#include "baseobject.h"

#include <QString>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlProperty>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QDebug>
#include <QModbusClient>
#include <QModbusDataUnit>
#include <QModbusReply>
#include <QModbusRtuSerialMaster>
#include <QObject>
#include <QTimer>
#include <QtSerialPort/QSerialPort>

class Modbus: public QObject, BaseObject {
    Q_OBJECT
    Q_PROPERTY(bool q_connectionState READ getState WRITE setState NOTIFY varChanged)
    Q_PROPERTY(QString portname READ getPortName WRITE setPortName NOTIFY varChanged)
    Q_PROPERTY(int baudrate READ getBaudrate WRITE setBaudrate NOTIFY varChanged)
    Q_PROPERTY(QString flow READ getFlow WRITE setFlow NOTIFY varChanged)
    Q_PROPERTY(QString parity READ getParity WRITE setParity NOTIFY varChanged)
    Q_PROPERTY(int stopbits READ getStopBits WRITE setStopBits NOTIFY varChanged)
    Q_PROPERTY(int databits READ getDataBits WRITE setDatabits NOTIFY varChanged)
    //
    Q_PROPERTY(bool q_isBusy READ getIsBusy NOTIFY varChanged)

signals:
    void varChanged ();
public:
  Modbus();
  ~Modbus();
public:
   void setState(bool state){ connection_state = state;}
   bool getState(){return connection_state;}
   bool getIsBusy(){return isBusy;}

   void setPortName(QString value){ settings->modbusParam.setPortName(value);}
   QString getPortName(){return settings->modbusParam.getPortName();}

   void setBaudrate(int value){ settings->modbusParam.setBaudrate(value);}
   int getBaudrate(){return settings->modbusParam.getBaudrate();}

   void setFlow(QString value){ settings->modbusParam.setFlow(value);}
   QString getFlow(){return settings->modbusParam.getFlow();}

   void setParity(QString value){ settings->modbusParam.setParity(value);}
   QString getParity(){return settings->modbusParam.getParity();}

   void setStopBits(int value){ settings->modbusParam.setStopBits(value);}
   int getStopBits(){return settings->modbusParam.getStopBits();}

   void setDatabits(int value){ settings->modbusParam.setDataBits(value);}
   int getDataBits(){return settings->modbusParam.getDataBits();}

   Q_INVOKABLE bool startConnection();   // khoi tao
   Q_INVOKABLE void stopConnection();
   Q_INVOKABLE void writeSingleHoldingRegister(int add, int value,int server);
   void writeSingleHoldingRegisterCompleted();

   Q_INVOKABLE void writeSingleCoil (int add, bool value, int server);
   void writeSingleCoilComleted();

   Q_INVOKABLE void readSingleHoldingRegister (int add, int ID,int *data);
   void readSingleHoldingRegisterRecieved();

   Q_INVOKABLE void readHoldingRegister(int ID,int start_add, int number_register);
   void readHoldingRegisterCompleted();
   void readCoilsCompleted() ;
   void readMultiCoils(int server,int start_add, int number_coils, bool *data);
   void readMultiDiscrete(int server,int start_add, int number_coils, bool *data);
   void readDiscreteCompleted();

   //
   int *holding_register_store;
   int *holding_register_store_PVSP;
   int nNumAddress = 0;
   //
signals:
   //void readSingleHoldingRegisterCompleted(int value);
   void readSingleHoldingRegisterCompleted();
   void readCoilsCompletedSignal();
   void readDiscreteCompletedSignal();
   void readHoldingRegisterCompletedOK() const;
   void readHoldingRegister0x47CompletedOK() const;

    void writeSingleHoldingRegisterCompletedOK();
private:
   QModbusRtuSerialMaster *modbusDevice;
   QTimer *serialTimer;
   void saveSettings();
   int nBytes;
   int ID;
   int start_address;
   bool connection_state= false;
   bool *discrete_result;
   bool *coil_result;
   int *holding_register_result;
   int nDiscrete;
   //
   bool isBusy;
};

#endif // MODBUS_HPP
