#ifndef CONFIG_H
#define CONFIG_H

#include <QSettings>
#include <constant.h>
#include <QString>

class SerialParameter: public QSettings {
public:
    SerialParameter(const QString savedPath, const QString group);

    QString getPortName();
    void setPortName(const QString &value);

    int getBaudrate();
    void setBaudrate(int value);

    QString getFlow();
    void setFlow(const QString &value);

    QString getParity();
    void setParity(const QString &value);

    int getStopBits();
    void setStopBits(int value);

    int getDataBits();
    void setDataBits(int value);

private:
    QString group;
};

class DefaultConfig: public QSettings {

public:
    DefaultConfig(const QString savedPath);

    QString getServerUrl();
    void setServerUrl(const QString &value);

    QString getUserName();
    void setUserName(const QString &value);

    QString getPassword();
    void setPassword(const QString &value);

    QString getToken();
    void setToken(const QString &value);
};

class AppSetting {
public:
    AppSetting(const QString savedPath);
    DefaultConfig defautConfig;
    SerialParameter modbusParam;
    SerialParameter cambienParam;
};

#endif // CONFIG_H
