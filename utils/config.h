#ifndef CONFIG_H
#define CONFIG_H

#include <QSettings>
#include "constant.h"
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

    QString getDeviceCode();
    void setDeviceCode(const QString &value);

    QString getDeviceModelName();
    void setDeviceModelName(const QString &value);
};
//
class ThresholdCabinSmoke: public QSettings {
public:
    ThresholdCabinSmoke(const QString savedPath, const QString group);

    float getThreshold_baokhoi();
    void  setThreshold_baokhoi(float value);
    //
    float getThreshold_matdokhoi();
    void  setThreshold_matdokhoi(float value);
    //
    float getThreshold_chapmach();
    void  setThreshold_chapmach(float value);
    //
    int getThreshold_timeout();
    void  setThreshold_timeout(int value);
    //
    //

private:
    QString group;
};
//

class ThresholdCabinTemp: public QSettings {
public:
    ThresholdCabinTemp(const QString savedPath, const QString group);
    //1
    float getThreshold_baoChay01();
    void  setThreshold_baoChay01(float value);
    float getThreshold_baoChay02();
    void  setThreshold_baoChay02(float value);
    //5
    float getThreshold_nganMach01();
    void  setThreshold_nganMach01(float value);
    float getThreshold_nganMach02();
    void  setThreshold_nganMach02(float value);
    //9
    float getThreshold_Temp01();
    void  setThreshold_Temp01(float value);
    float getThreshold_Temp02();
    void  setThreshold_Temp02(float value);
    //13
    int   getThreshold_TimeOut01();
    void  setThreshold_TimeOut01(int value);
    int   getThreshold_TimeOut02();
    void  setThreshold_TimeOut02(int value);
    //17
    //

private:
    QString group;
};
//
class AppSetting {
public:
    AppSetting(const QString savedPath);
    DefaultConfig defautConfig;
    SerialParameter modbusParam;
    SerialParameter rs485ICPParam;  //new
    SerialParameter uartParam;  //new
    ThresholdCabinSmoke thresholdCabinSmoke;
    ThresholdCabinTemp thresholdCabinTemp;
};
//
#endif // CONFIG_H
