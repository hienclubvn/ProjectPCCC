#ifndef CABIN_TEMP_HPP
#define CABIN_TEMP_HPP

#include <QObject>
#include "modbus.hpp"
#include "rs485.hpp"

#include "baseobject.h"
#include <QDebug>
#include <QObject>

class Cabin_Temperature : public QObject, BaseObject
{
    Q_OBJECT
    Q_PROPERTY(float q_temperature READ getTemperature  NOTIFY varChanged)
    Q_PROPERTY(float q_humidity READ getHumidity  NOTIFY varChanged)

    Q_PROPERTY(float q_temperature_sensor READ getTempSensor  NOTIFY varChanged2)
    Q_PROPERTY(float q_setpointSP READ getSetPointSP WRITE setSetPointSP NOTIFY varChanged2)

    Q_PROPERTY(bool q_start_led_state READ getStartButton  NOTIFY stateChanged)

    //ICP
    Q_PROPERTY(float q_volt_sensor_supply READ getVolt_Sensor_Supply NOTIFY varChanged)
    Q_PROPERTY(float q_volt_sensor1_respone READ getVolt_Sensor1_Respone NOTIFY varChanged)
    Q_PROPERTY(float q_volt_sensor2_respone READ getVolt_Sensor2_Respone NOTIFY varChanged)

    Q_PROPERTY(bool q_output_alarm1_state READ getOuputCoilState1  NOTIFY stateOuputChanged)
    Q_PROPERTY(bool q_output_alarm2_state READ getOuputCoilState2  NOTIFY stateOuputChanged)

    Q_PROPERTY(int q_angleStepMotor READ getAngleStepMotor WRITE setAngleStepMotor NOTIFY varChanged)

    Q_PROPERTY(bool q_run_system_state READ getSystemStatus  WRITE setSystemStatus NOTIFY stateChanged)

    //
    //Threshold
    Q_PROPERTY(float threshold_baoChay01    READ getThreshold_baoChay01     WRITE setThreshold_baoChay01    NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_baoChay02    READ getThreshold_baoChay02     WRITE setThreshold_baoChay02    NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_nganMach01   READ getThreshold_nganMach01    WRITE setThreshold_nganMach01   NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_nganMach02   READ getThreshold_nganMach02    WRITE setThreshold_nganMach02   NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_Temp01       READ getThreshold_Temp01        WRITE setThreshold_Temp01       NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_Temp02       READ getThreshold_Temp02        WRITE setThreshold_Temp02       NOTIFY varThresholdChanged)
    Q_PROPERTY(int threshold_TimeOut01      READ getThreshold_TimeOut01     WRITE setThreshold_TimeOut01    NOTIFY varThresholdChanged)
    Q_PROPERTY(int threshold_TimeOut02      READ getThreshold_TimeOut02     WRITE setThreshold_TimeOut02    NOTIFY varThresholdChanged)
    //

public:
    explicit Cabin_Temperature(QObject *parent = nullptr);
    Cabin_Temperature(Modbus *modbus, RS485 *rs485);
    //
    float getVolt_Sensor_Supply (){return voltSupplySensor;}
    float getVolt_Sensor1_Respone (){return currentSensorTemp1;}
    float getVolt_Sensor2_Respone (){return currentSensorTemp2;}

    //
    float     getTemperature(){return temperature;}
    float     getHumidity(){return humidity;}
    float     getTempSensor(){return temperature_sensor;}
    //
    void setSetPointSP (float SP){
        setpointSP = SP;
        write_SP(SP);
    }
    float getSetPointSP (){return setpointSP;}
    //
    Q_INVOKABLE void readAllData();
    Q_INVOKABLE void readAllSHT11();
    Q_INVOKABLE void readAll_PV_SP();
    Q_INVOKABLE void sendRequest();

    Q_INVOKABLE void write_SP(float temp_SP);
    Q_INVOKABLE void write_RunModuleTemp(bool run);
    //
    //Q_INVOKABLE void writeGpioRelay(int ID,);
    bool getStartButton(){return start_led_state;}
    Q_INVOKABLE void readAllStateInput();

    Q_INVOKABLE void writeAngleStepMotor(int angle);
    Q_INVOKABLE void writeAlarm(int channel, bool value);
    Q_INVOKABLE void writeStateRunSystem(bool value);

    //
    void setAngleStepMotor (int angle){
        //angleStepMotor = angle;
        writeAngleStepMotor(angle);
    }
    int getAngleStepMotor (){return angle_current;}
    //
    bool getOuputCoilState1(){return output_alarm1_state;}
    bool getOuputCoilState2(){return output_alarm2_state;}

    bool getSystemStatus(){return run_system_state;}
    void setSystemStatus(bool state){ run_system_state = state; }
    //Save Threshold
    int     getThreshold_TimeOut01(){return settings->thresholdCabinTemp.getThreshold_TimeOut01();}
    int     getThreshold_TimeOut02(){return settings->thresholdCabinTemp.getThreshold_TimeOut02();}
    float   getThreshold_baoChay01(){return settings->thresholdCabinTemp.getThreshold_baoChay01();}
    float   getThreshold_baoChay02(){return settings->thresholdCabinTemp.getThreshold_baoChay02();}
    float   getThreshold_nganMach01(){return settings->thresholdCabinTemp.getThreshold_nganMach01();}
    float   getThreshold_nganMach02(){return settings->thresholdCabinTemp.getThreshold_nganMach02();}
    float   getThreshold_Temp01(){return settings->thresholdCabinTemp.getThreshold_Temp01();}
    float   getThreshold_Temp02(){return settings->thresholdCabinTemp.getThreshold_Temp02();}

    void    setThreshold_TimeOut01(int value){ settings->thresholdCabinTemp.setThreshold_TimeOut01(value);}
    void    setThreshold_TimeOut02(int value){ settings->thresholdCabinTemp.setThreshold_TimeOut02(value);}
    void    setThreshold_baoChay01(float value){ settings->thresholdCabinTemp.setThreshold_baoChay01(value);}
    void    setThreshold_baoChay02(float value){ settings->thresholdCabinTemp.setThreshold_baoChay02(value);}
    void    setThreshold_nganMach01(float value){ settings->thresholdCabinTemp.setThreshold_nganMach01(value);}
    void    setThreshold_nganMach02(float value){ settings->thresholdCabinTemp.setThreshold_nganMach02(value);}
    void    setThreshold_Temp01(float value){ settings->thresholdCabinTemp.setThreshold_Temp01(value);}
    void    setThreshold_Temp02(float value){ settings->thresholdCabinTemp.setThreshold_Temp02(value);}



    void readCompleted();
    void read0x47Completed();
    void readGPIOCompleted();
    void writeCompleted();
    void ReadICPCompleted();

    //
    float setpoit_varitor = 0.0;
    //
signals:
    void varChanged ();
    void varChanged2 ();
    void stateChanged ();
    void stateOuputChanged();
    void varThresholdChanged();

public slots:

private:
    Modbus *cabin_modbus;
    RS485 *cabin_rs485;
    //
    float temperature;
    float humidity;
    float setpointSP = 0.0;
    float temperature_sensor = 0.0;
    //float setpoit_varitor = 0.0;
    int angleStepMotor;
    int angle_current = 0;
    int nIndexRequet = 0;
    //
    bool start_led_state = false;
    bool output_alarm1_state = false;
    bool output_alarm2_state = false;
    bool discrete_receive[4] = {false,false,false,false};
    bool coils_receive[3] = {false,false,false};

    //Tu nhiet do (ICP - RS485)
    float voltSupplySensor = 0.0;
    float currentSensorTemp1 = 0.0;
    float currentSensorTemp2 = 0.0;
    //
    bool run_system_state = false;
    bool run_system_latch = false;
};


#endif // CABIN_TEMP_HPP
