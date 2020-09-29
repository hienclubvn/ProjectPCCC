#ifndef CABIN_SMOKE_HPP
#define CABIN_SMOKE_HPP

#include <QObject>
#include "uart.hpp"
#include "rs485.hpp"
#include "modbus.hpp"

#include "baseobject.h"
#include <QDebug>
#include <QObject>

class Cabin_Smoke : public QObject, BaseObject
{
    Q_OBJECT
    //ModbusRTU
    Q_PROPERTY(float q_temperature READ getTemperature  NOTIFY varChanged)
    Q_PROPERTY(float q_humidity READ getHumidity  NOTIFY varChanged)
    //angle Motor Step
    Q_PROPERTY(int q_angleStepMotor READ getAngleStepMotor WRITE setAngleStepMotor NOTIFY varChanged)
    //Q_PROPERTY(int q_angleStepMotor READ getAngleStepMotor NOTIFY varAngleChanged)

    Q_PROPERTY(bool q_start_led_state READ getStartButton  NOTIFY stateChanged)

    Q_PROPERTY(bool q_run_system_state READ getSystemStatus  WRITE setSystemStatus NOTIFY stateChanged)

    //Output
    Q_PROPERTY(bool q_output_alarm1_state READ getOuputCoilState1  NOTIFY stateOuputChanged)
    Q_PROPERTY(bool q_output_alarm2_state READ getOuputCoilState2  NOTIFY stateOuputChanged)

    //ICP
    Q_PROPERTY(float q_volt_sensor_supply READ getVolt_Sensor_Supply NOTIFY varChanged)
    Q_PROPERTY(float q_volt_sensor_respone READ getVolt_Sensor_Respone NOTIFY varChanged)
    //RS232
    Q_PROPERTY(float q_density_smoke READ getDensitySmoke NOTIFY varChanged)

    //Threshold
    Q_PROPERTY(float threshold_baokhoi READ getThreshold_baokhoi WRITE setThreshold_baokhoi NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_chapmach READ getThreshold_chapmach WRITE setThreshold_chapmach NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_matdokhoi READ getThreshold_matdokhoi WRITE setThreshold_matdokhoi NOTIFY varThresholdChanged)
    Q_PROPERTY(float threshold_timeout READ getThreshold_timeout WRITE setThreshold_timeout NOTIFY varThresholdChanged)

    Q_PROPERTY(bool q_bIsTimeOut READ getIsTimeOut WRITE setIsTimeOut NOTIFY varThresholdChanged)


public:
    explicit Cabin_Smoke(QObject *parent = nullptr);
    Cabin_Smoke(Modbus *modbus, RS485 *rs485, Uart *uart);
    //
    float getDensitySmoke (){return density_smoke;}
    //
    float getVolt_Sensor_Supply (){return voltSupplySensor;}
    float getVolt_Sensor_Respone (){return currentSensorSmoke;}

    //
    float     getTemperature(){return temperature;}
    float     getHumidity(){return humidity;}
    //
    void setAngleStepMotor (int angle){
        //angleStepMotor = angle;
        writeAngleStepMotor(angle);
    }
    int getAngleStepMotor (){return angle_current;}
    //
    bool getOuputCoilState1(){return output_alarm1_state;}
    bool getOuputCoilState2(){return output_alarm2_state;}

    Q_INVOKABLE void readAllData();
    Q_INVOKABLE void readAllSHT11();
    Q_INVOKABLE void readAngleStepMotor();
    Q_INVOKABLE void sendRequest();

    //Q_INVOKABLE void write_SP(int temp_SP);
    Q_INVOKABLE void writeAngleStepMotor(int angle);
    Q_INVOKABLE void writeAlarm(int channel, bool value);
    Q_INVOKABLE void writeStateRunSystem(bool value);
    //
    //Q_INVOKABLE void writeGpioRelay(int ID,);
    bool getStartButton(){return start_led_state;}
    bool getSystemStatus(){return run_system_state;}
    void setSystemStatus(bool state){ run_system_state = state; }

    Q_INVOKABLE void readAllStateInput();
    Q_INVOKABLE void readAllStateOutput();
    // Save Threshold
    Q_INVOKABLE void writeSaveThreshold(float value);
    float getThreshold_baokhoi(){return settings->thresholdCabinSmoke.getThreshold_baokhoi();}
    float getThreshold_chapmach(){return settings->thresholdCabinSmoke.getThreshold_chapmach();}
    float getThreshold_matdokhoi(){return settings->thresholdCabinSmoke.getThreshold_matdokhoi();}
    int   getThreshold_timeout(){return settings->thresholdCabinSmoke.getThreshold_timeout();}

    void  setThreshold_baokhoi(float value){ settings->thresholdCabinSmoke.setThreshold_baokhoi(value);}
    void  setThreshold_chapmach(float value){ settings->thresholdCabinSmoke.setThreshold_chapmach(value);}
    void  setThreshold_matdokhoi(float value){ settings->thresholdCabinSmoke.setThreshold_matdokhoi(value);}
    void   setThreshold_timeout(int value){ settings->thresholdCabinSmoke.setThreshold_timeout(value);}

    bool getIsTimeOut() {return bIsTimeOut; }
    void setIsTimeOut(bool value) {bIsTimeOut = value; }

    //
    void readHoldingCompleted();
    void readSingleHoldingCompleted();
    void readDiscreteCompleted();
    void readCoilsCompleted();
    void writeSingleHoldingCompleted();
    void ReadICPCompleted();
    //
    void densityReadCompleted();
signals:
    void varChanged ();
    void stateChanged ();
    void stateOuputChanged();
    void varAngleChanged();
    void varThresholdChanged();

public slots:

private:
    Modbus *cabin_modbus;
    RS485 *cabin_rs485;
    Uart *smoke_uart;
    //UART
    float density_smoke;
    //ModbusRTU
    float temperature;
    float humidity;
    int angleStepMotor;
    int angle_current = 0;
    int nIndexRequet = 0;
    //
    bool start_led_state = false;
    bool run_system_state = false;
    bool run_system_state_last = false;
    bool run_system_latch = false;

    bool output_alarm1_state = false;
    bool output_alarm2_state = false;
    bool discrete_receive[4] = {false,false,false,false};
    bool coils_receive[3] = {false,false,false};

    //(ICP - RS485)
    float voltSupplySensor = 0.0;
    float currentSensorSmoke = 0.0;
    //
    bool bIsTimeOut = false;
};

#endif // CABIN_SMOKE_HPP
