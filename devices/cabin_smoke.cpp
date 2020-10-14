#include "cabin_smoke.hpp"

Cabin_Smoke::Cabin_Smoke(Modbus *modbus, RS485 *rs485, Uart *uart)
{
    cabin_modbus = modbus;
    angleStepMotor = 0;

    connect (cabin_modbus,&Modbus::readHoldingRegisterCompletedOK,this,&Cabin_Smoke::readHoldingCompleted);
    connect (cabin_modbus,&Modbus::writeSingleHoldingRegisterCompletedOK,this,&Cabin_Smoke::writeSingleHoldingCompleted);
    connect (cabin_modbus,&Modbus::readSingleHoldingRegisterCompleted,this,&Cabin_Smoke::readSingleHoldingCompleted);

    connect (cabin_modbus,&Modbus::readDiscreteCompletedSignal,this,&Cabin_Smoke::readDiscreteCompleted);
    connect (cabin_modbus,&Modbus::readCoilsCompletedSignal,this,&Cabin_Smoke::readCoilsCompleted);
    //
    cabin_rs485 = rs485;
    connect(cabin_rs485,&RS485::readVoltICPCompleted,this,&Cabin_Smoke::ReadICPCompleted);

    //
    smoke_uart = uart;
    connect(uart,&Uart::readSmokeCompleted,this,&Cabin_Smoke::densityReadCompleted);
    density_smoke = 0;

}
void Cabin_Smoke::sendRequest()   //RS485
{
    if (cabin_rs485->getState())
        cabin_rs485->writeData("#01\r");
}

//------------Write----------------
void Cabin_Smoke::writeAngleStepMotor(int angle)
{
    if (cabin_modbus->getState())
        cabin_modbus->writeSingleHoldingRegister(2,angle,10);
}
void Cabin_Smoke::writeAlarm(int channel, bool value)
{
    cabin_modbus->writeSingleCoil(channel,value,11);    //ID=11
    if (channel == 0) output_alarm1_state = value;
    else if (channel == 1) output_alarm2_state = value;
    emit stateOuputChanged();
}
void Cabin_Smoke::writeStateRunSystem(bool value)
{
    if (value != run_system_state) {
        run_system_state = value;
        emit stateChanged();
    }
}
//------------Read----------------
void Cabin_Smoke::readAllData()
{
    switch (nIndexRequet++)
    {
        case 0: readAllSHT11(); break;
        case 1: readAllStateInput(); break;
        case 2: readAllStateOutput(); break;
        //case 3: readAngleStepMotor(); break;
    }
    //
    if (nIndexRequet >= 3) nIndexRequet = 0;
}

void Cabin_Smoke::readAllSHT11()
{
    //if (!cabin_modbus->getIsBusy())
        //cabin_modbus->readHoldingRegister(10,0,2); //ID = 10
        cabin_modbus->readHoldingRegister(10,0,4); //ID = 10
}
void Cabin_Smoke::readAngleStepMotor()  //dang ko dung./
{
    //    if (!cabin_modbus->getIsBusy())
            //cabin_modbus->readSingleHoldingRegister(0,10,&angle_current);
}
void Cabin_Smoke::readAllStateInput()
{
    //if (!cabin_modbus->getIsBusy())
        cabin_modbus ->readMultiDiscrete(11,0,4,discrete_receive);      
}
void Cabin_Smoke::readAllStateOutput()
{
    //cabin_modbus -> readMultiCoils(11,0,3,coils_receive); //ID=11
}

//------------Signals----------------
//-------ModbusRTU--------
void Cabin_Smoke::readHoldingCompleted()
{
    //
    temperature =   (float)cabin_modbus->holding_register_store[0]/10;
    humidity    =   (float)cabin_modbus->holding_register_store[1]/10;

    angleStepMotor = cabin_modbus->holding_register_store[2];
    angle_current = cabin_modbus->holding_register_store[3];

    emit varChanged();
}
void Cabin_Smoke::readSingleHoldingCompleted()
{
    emit varAngleChanged();
}
void Cabin_Smoke::readDiscreteCompleted()
{
    start_led_state = discrete_receive[0];
    //Xu ly du lieu nhan o day ...../
    if (start_led_state == true)
    {
        //phai check duoc su khac biet:
        if (run_system_latch == false)
        {
            run_system_state = !run_system_state; //run_system_state_last;
            //run_system_state_last = run_system_state;
        }
        run_system_latch = true;
        //
    }
    else {
        //kiem tra trang thai da thay doi chua??
        run_system_latch = false;
    }
    emit stateChanged();
}
void Cabin_Smoke::readCoilsCompleted()
{
    output_alarm1_state = coils_receive[0];
    output_alarm2_state = coils_receive[1];
    emit stateOuputChanged();
}

void Cabin_Smoke::writeSingleHoldingCompleted()
{
    //angleStepMotor = angle_temp;
    //emit varChanged();
}
//-------RS485 - ICP --------
void Cabin_Smoke::ReadICPCompleted()
{
    //Tu nhiet
    voltSupplySensor = cabin_rs485->dataFloat[5]*3;
    currentSensorSmoke = cabin_rs485->dataFloat[3]*1000/227.5;

    emit varChanged();
    emit varThresholdChanged1();
}
//-------RS232 --------
void Cabin_Smoke::densityReadCompleted()
{
    density_smoke = smoke_uart->density_smoke/10.0;
    emit varChanged();
}
//----------SAVE-- Data --
void Cabin_Smoke::writeSaveThreshold(float value)
{
    settings->thresholdCabinSmoke.setThreshold_baokhoi(value);
    emit varThresholdChanged();
}
