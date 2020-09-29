#include "config.h"

AppSetting::AppSetting(const QString savedPath):
    defautConfig(savedPath),
    modbusParam(savedPath, "Modbus"),
    rs485ICPParam(savedPath, "rs485ICPParam"),
    uartParam(savedPath, "uartParam"),
    thresholdCabinSmoke(savedPath, "thresholdCabinSmoke"),
    thresholdCabinTemp(savedPath, "thresholdCabinTemp")
    //calibParam(savedPath, "CalibParam")
{}

SerialParameter::SerialParameter(const QString savedPath, const QString group)
    : QSettings(savedPath, QSettings::Format::IniFormat, nullptr), group(group)
{}

QString SerialParameter::getPortName()  //settings->modbusParam.getPortName()
{
    this->beginGroup(group);
    QString value = this->value("portname").toString();
    this->endGroup();
    return value != "" ? value : "ttyUSB0";
}

void SerialParameter::setPortName(const QString &value)
{
    this->beginGroup(group);
    this->setValue("portname", value);
    this->endGroup();
}

int SerialParameter::getBaudrate()
{
    this->beginGroup(group);
    int value = this->value("baudrate").toInt();
    this->endGroup();
    return value != 0 ? value : 9600;
}

void SerialParameter::setBaudrate(int value)
{
    this->beginGroup(group);
    this->setValue("baudrate", value);
    this->endGroup();
}

QString SerialParameter::getFlow()
{
    this->beginGroup(group);
    QString value = this->value("flow").toString();
    this->endGroup();
    return value;
}

void SerialParameter::setFlow(const QString &value)
{
    this->beginGroup(group);
    this->setValue("flow", value);
    this->endGroup();
}

QString SerialParameter::getParity()
{
    this->beginGroup(group);
    QString value = this->value("parity").toString();
    this->endGroup();
    return value != "" ? value : "None";
}

void SerialParameter::setParity(const QString &value)
{
    this->beginGroup(group);
    this->setValue("parity", value);
    this->endGroup();
}

int SerialParameter::getStopBits()
{
    this->beginGroup(group);
    int value = this->value("stopbits").toInt();
    this->endGroup();
    return value != 0 ? value : 1;
}

void SerialParameter::setStopBits(int value)
{
    this->beginGroup(group);
    this->setValue("stopbits", value);
    this->endGroup();
}

int SerialParameter::getDataBits()
{
    this->beginGroup(group);
    int value = this->value("databits").toInt();
    this->endGroup();
    return value != 0 ? value : 8;
}

void SerialParameter::setDataBits(int value)
{
    this->beginGroup(group);
    this->setValue("databits", value);
    this->endGroup();
}

DefaultConfig::DefaultConfig(const QString savedPath)
    : QSettings(savedPath, QSettings::Format::IniFormat, nullptr)
{}

QString DefaultConfig::getServerUrl()
{
    this->beginGroup("default");
    QString value = this->value("serverUrl").toString();
    this->endGroup();
    return value != "" ? value: DEFAULT_SERVER_URL;
}

void DefaultConfig::setServerUrl(const QString &value)
{
    this->beginGroup("default");
    this->setValue("serverUrl", value);
    this->endGroup();
}

QString DefaultConfig::getUserName()
{
    this->beginGroup("default");
    QString value = this->value("userName").toString();
    this->endGroup();
    return value;
}

void DefaultConfig::setUserName(const QString &value)
{
    this->beginGroup("default");
    this->setValue("userName", value);
    this->endGroup();
}

QString DefaultConfig::getPassword()
{
    this->beginGroup("default");
    QString value = this->value("password").toString();
    this->endGroup();
    return value;
}

void DefaultConfig::setPassword(const QString &value)
{
    this->beginGroup("default");
    this->setValue("password", value);
    this->endGroup();
}

QString DefaultConfig::getToken()
{
    this->beginGroup("default");
    QString value = this->value("token").toString();
    this->endGroup();
    return value;
}

void DefaultConfig::setToken(const QString &value)
{
    this->beginGroup("default");
    this->setValue("token", value);
    this->endGroup();
}

QString DefaultConfig::getDeviceCode()
{
    this->beginGroup("default");
    QString value = this->value("deviceCode").toString();
    this->endGroup();
    return value;
}

void DefaultConfig::setDeviceCode(const QString &value)
{
    this->beginGroup("default");
    this->setValue("deviceCode", value);
    this->endGroup();
}

QString DefaultConfig::getDeviceModelName()
{
    this->beginGroup("default");
    QString value = this->value("deviceModelName").toString();
    this->endGroup();
    return value;
}

void DefaultConfig::setDeviceModelName(const QString &value)
{
    this->beginGroup("default");
    this->setValue("deviceModelName", value);
    this->endGroup();
}

//--------------(begin)ThresholdCabinSmoke------
ThresholdCabinSmoke::ThresholdCabinSmoke(const QString savedPath, const QString group)
    : QSettings(savedPath, QSettings::Format::IniFormat, nullptr), group(group)
{}
//
float ThresholdCabinSmoke::getThreshold_baokhoi()
{
    this->beginGroup(group);
    float value = this->value("threshold_baokhoi").toFloat();
    this->endGroup();
    return value != 0.0f ? value : 10.0;
}

void ThresholdCabinSmoke::setThreshold_baokhoi(float value)
{
    this->beginGroup(group);
    this->setValue("threshold_baokhoi", value);
    this->endGroup();
}
//
float ThresholdCabinSmoke::getThreshold_chapmach()
{
    this->beginGroup(group);
    float value = this->value("threshold_chapmach").toFloat();
    this->endGroup();
    return value != 0.0f ? value : 20.0;
}

void ThresholdCabinSmoke::setThreshold_chapmach(float value)
{
    this->beginGroup(group);
    this->setValue("threshold_chapmach", value);
    this->endGroup();
}
//
float ThresholdCabinSmoke::getThreshold_matdokhoi()
{
    this->beginGroup(group);
    float value = this->value("threshold_matdokhoi").toFloat();
    this->endGroup();
    return value != 0.0f ? value : 30.0;
}

void ThresholdCabinSmoke::setThreshold_matdokhoi(float value)
{
    this->beginGroup(group);
    this->setValue("threshold_matdokhoi", value);
    this->endGroup();
}
//
int ThresholdCabinSmoke::getThreshold_timeout()
{
    this->beginGroup(group);
    int value = this->value("threshold_timeout").toInt();
    this->endGroup();
    return value != 0 ? value : 20.0;
}

void ThresholdCabinSmoke::setThreshold_timeout(int value)
{
    this->beginGroup(group);
    this->setValue("threshold_timeout", value);
    this->endGroup();
}
//
//--------------(end)ThresholdCabinSmoke------
//--------------(begin)ThresholdCabinTemp------
ThresholdCabinTemp::ThresholdCabinTemp(const QString savedPath, const QString group)
    : QSettings(savedPath, QSettings::Format::IniFormat, nullptr), group(group)
{}
//
int ThresholdCabinTemp::getThreshold_TimeOut01() {
    this->beginGroup(group); int value = this->value("threshold_TimeOut01").toInt(); this->endGroup();
    return value != 0 ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_TimeOut01(int value) {
    this->beginGroup(group); this->setValue("threshold_TimeOut01", value); this->endGroup();
}
int ThresholdCabinTemp::getThreshold_TimeOut02() {
    this->beginGroup(group); int value = this->value("threshold_TimeOut02").toInt(); this->endGroup();
    return value != 0 ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_TimeOut02(int value) {
    this->beginGroup(group); this->setValue("threshold_TimeOut02", value); this->endGroup();
}
//
float ThresholdCabinTemp::getThreshold_baoChay01() {
    this->beginGroup(group); float value = this->value("threshold_baoChay01").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_baoChay01(float value) {
    this->beginGroup(group); this->setValue("threshold_baoChay01", value); this->endGroup();
}
float ThresholdCabinTemp::getThreshold_baoChay02() {
    this->beginGroup(group); float value = this->value("threshold_baoChay02").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_baoChay02(float value) {
    this->beginGroup(group); this->setValue("threshold_baoChay02", value); this->endGroup();
}
//
float ThresholdCabinTemp::getThreshold_nganMach01() {
    this->beginGroup(group); float value = this->value("threshold_nganMach01").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_nganMach01(float value) {
    this->beginGroup(group); this->setValue("threshold_nganMach01", value); this->endGroup();
}
float ThresholdCabinTemp::getThreshold_nganMach02() {
    this->beginGroup(group); float value = this->value("threshold_nganMach02").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_nganMach02(float value) {
    this->beginGroup(group); this->setValue("threshold_nganMach02", value); this->endGroup();
}
//
float ThresholdCabinTemp::getThreshold_Temp01() {
    this->beginGroup(group); float value = this->value("threshold_Temp01").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_Temp01(float value) {
    this->beginGroup(group); this->setValue("threshold_Temp01", value); this->endGroup();
}
float ThresholdCabinTemp::getThreshold_Temp02() {
    this->beginGroup(group); float value = this->value("threshold_Temp02").toFloat(); this->endGroup();
    return value != 0.0f ? value : 20.0;
}
void ThresholdCabinTemp::setThreshold_Temp02(float value) {
    this->beginGroup(group); this->setValue("threshold_Temp02", value); this->endGroup();
}
//--------------(end)ThresholdCabinTemp---------
