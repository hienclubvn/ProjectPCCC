#ifndef RS485_HPP
#define RS485_HPP
#include "baseobject.h"
#include <QDebug>
#include <QObject>
#include <QtSerialPort/QSerialPort>

class RS485: public QObject, BaseObject
{
    Q_OBJECT
    //portname|baudrate|databit|parity|stopbit
    Q_PROPERTY(QString portname READ getPortName WRITE setPortName NOTIFY varChanged)
    Q_PROPERTY(int baudrate READ getBaudrate WRITE setBaudrate NOTIFY varChanged)
    Q_PROPERTY(QString flow READ getFlow WRITE setFlow NOTIFY varChanged)
    Q_PROPERTY(QString parity READ getParity WRITE setParity NOTIFY varChanged)
    Q_PROPERTY(int stopbits READ getStopBits WRITE setStopBits NOTIFY varChanged)
    Q_PROPERTY(int databits READ getDataBits WRITE setDatabits NOTIFY varChanged)
    //status
    Q_PROPERTY(bool q_connectionState READ getState WRITE setState NOTIFY varChanged)

public:
    RS485();
    ~RS485();
    //
    Q_INVOKABLE void openSerialPort();
    Q_INVOKABLE void closeSerialPort();
    Q_INVOKABLE void writeData(const QByteArray &data);

    void handleError(QSerialPort::SerialPortError error);
    void readData();
    bool getState();
    void setState(bool value);
    // Binding - NOTIFY - SET
    void setPortName(QString value){ settings->rs485ICPParam.setPortName(value);}
    void setBaudrate(int value){ settings->rs485ICPParam.setBaudrate(value);}
    void setFlow(QString value){ settings->rs485ICPParam.setFlow(value);}
    void setParity(QString value){ settings->rs485ICPParam.setParity(value);}
    void setStopBits(int value){ settings->rs485ICPParam.setStopBits(value);}
    void setDatabits(int value){ settings->rs485ICPParam.setDataBits(value);}
    // Binding - NOTIFY - GET
    QString getPortName(){return settings->rs485ICPParam.getPortName();}
    QString getFlow(){return settings->rs485ICPParam.getFlow();}
    QString getParity(){return settings->rs485ICPParam.getParity();}
    int getBaudrate(){return settings->rs485ICPParam.getBaudrate();}
    int getStopBits(){return settings->rs485ICPParam.getStopBits();}
    int getDataBits(){return settings->rs485ICPParam.getDataBits();}

signals:
    void varChanged ();
    void receiveCompleted();
    //for ICP-DCON
    void readVoltICPCompleted();
public slots:
    void OnReceiveCompleted();
private:
    QSerialPort *m_rs485;
    bool connection_state= false;
    QString m_receiveText;

//varible public
public:
    float dataFloat[8] = {0};
    //volt_supply_sensor = dataFloat[5]*3;
    //volt_sensor_respone = dataFloat[6];
};
#endif // RS485_HPP
