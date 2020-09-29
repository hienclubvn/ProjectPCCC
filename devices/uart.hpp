#ifndef UART_HPP
#define UART_HPP

#include "baseobject.h"
#include <QDebug>
#include <QObject>
#include <QtSerialPort/QSerialPort>

class Uart: public QObject, BaseObject
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
    Uart();
    ~Uart();
    //
    Q_INVOKABLE void openSerialPort();
    Q_INVOKABLE void closeSerialPort();
    Q_INVOKABLE void writeData(const QByteArray &data);

    void handleError(QSerialPort::SerialPortError error);
    void readData();
    bool getState();
    void setState(bool value);
    // Binding - NOTIFY - SET
    void setPortName(QString value){ settings->uartParam.setPortName(value);}
    void setBaudrate(int value){ settings->uartParam.setBaudrate(value);}
    void setFlow(QString value){ settings->uartParam.setFlow(value);}
    void setParity(QString value){ settings->uartParam.setParity(value);}
    void setStopBits(int value){ settings->uartParam.setStopBits(value);}
    void setDatabits(int value){ settings->uartParam.setDataBits(value);}
    // Binding - NOTIFY - GET
    QString getPortName(){return settings->uartParam.getPortName();}
    QString getFlow(){return settings->uartParam.getFlow();}
    QString getParity(){return settings->uartParam.getParity();}
    int getBaudrate(){return settings->uartParam.getBaudrate();}
    int getStopBits(){return settings->uartParam.getStopBits();}
    int getDataBits(){return settings->uartParam.getDataBits();}

signals:
    void varChanged ();
    void receiveCompleted();
    void readSmokeCompleted();

public slots:
    void OnReceiveCompleted();
private:
    QSerialPort *m_serial;
    bool connection_state= false;
    QString m_receiveText;

//varible public
public:
    float density_smoke = 0.0;
};
#endif // UART_HPP
