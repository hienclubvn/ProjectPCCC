#include "cabin_temperature.hpp"


Cabin_Temperature::Cabin_Temperature(Modbus *modbus, RS485 *rs485)
{
    cabin_modbus = modbus;

    connect (cabin_modbus,&Modbus::readHoldingRegisterCompletedOK,this,&Cabin_Temperature::readCompleted);
    //connect (cabin_modbus,&Modbus::readHoldingRegister0x47CompletedOK,this,&Cabin_Temperature::read0x47Completed);

    connect (cabin_modbus,&Modbus::writeSingleHoldingRegisterCompletedOK,this,&Cabin_Temperature::writeCompleted);
    connect (cabin_modbus,&Modbus::readDiscreteCompletedSignal,this,&Cabin_Temperature::readGPIOCompleted);
    //
    cabin_rs485 = rs485;
    connect(cabin_rs485,&RS485::readVoltICPCompleted,this,&Cabin_Temperature::ReadICPCompleted);

}
void Cabin_Temperature::sendRequest()   //RS485
{
   if (cabin_rs485->getState())
       cabin_rs485->writeData("#01\r");

}

//------------Write----------------
void Cabin_Temperature::write_SP(float temp_SP)
{
    if (cabin_modbus->getState())
    {
        int temp = temp_SP*10;
        cabin_modbus->writeSingleHoldingRegister(0x4701,temp,0x07);
        setpointSP = temp_SP;
    }

}
void Cabin_Temperature::write_RunModuleTemp(bool run)
{
    if (cabin_modbus->getState())
    {
        if(run) cabin_modbus->writeSingleHoldingRegister(0x4719,1,0x07);
        else    cabin_modbus->writeSingleHoldingRegister(0x4719,0,0x07);
    }

}
void Cabin_Temperature::writeStateRunSystem(bool value)
{
    if (value != run_system_state) {
        run_system_state = value;
        emit stateChanged();
    }
}
//------------Read----------------
void Cabin_Temperature::readAllData()
{
    switch (nIndexRequet++)
    {
        case 0: readAllSHT11(); break;
        case 1: readAllStateInput(); break;
        case 2: readAll_PV_SP(); break;
    }
    //
    if (nIndexRequet >= 3) nIndexRequet = 0;
}
void Cabin_Temperature::readAllSHT11()
{
    if (cabin_modbus->getState())
        cabin_modbus->readHoldingRegister(10,0,2); //ID = 10
}
void Cabin_Temperature::readAll_PV_SP()
{
    if (cabin_modbus->getState())
        cabin_modbus->readHoldingRegister(07,0x4700,2);  //ID = 07
}
void Cabin_Temperature::readAllStateInput()
{
    if (cabin_modbus->getState())
        cabin_modbus ->readMultiDiscrete(11,0,4,discrete_receive);
}
//------------Write----------------
void Cabin_Temperature::writeAngleStepMotor(int angle)
{
    if (cabin_modbus->getState())
        cabin_modbus->writeSingleHoldingRegister(2,angle,10);
}
void Cabin_Temperature::writeAlarm(int channel, bool value)
{
    cabin_modbus->writeSingleCoil(channel,value,11);    //ID=11
    if (channel == 0) output_alarm1_state = value;
    else if (channel == 1) output_alarm2_state = value;
    emit stateOuputChanged();
}
//------------Signals----------------
void Cabin_Temperature::readCompleted()
{
    //debug
    humidity    =   (float)cabin_modbus->holding_register_store[1]/10;
    if (humidity < 50) return;
    //
    if (cabin_modbus->nNumAddress == 10) {
        temperature =   (float)cabin_modbus->holding_register_store[0]/10;
        humidity    =   (float)cabin_modbus->holding_register_store[1]/10;
        emit varChanged();
    }
    else if (cabin_modbus->nNumAddress == 07)
    {
        setpointSP          = (float)cabin_modbus->holding_register_store_PVSP[1]/10;
        temperature_sensor  = (float)cabin_modbus->holding_register_store_PVSP[0]/10;
        emit varChanged2();
    }
}
void Cabin_Temperature::read0x47Completed()
{
    setpointSP          = (float)cabin_modbus->holding_register_store_PVSP[0]/10;
    temperature_sensor  = (float)cabin_modbus->holding_register_store_PVSP[1]/10;

    emit varChanged2();
}
void Cabin_Temperature::readGPIOCompleted()
{
//    start_led_state = discrete_receive[0];
//    emit stateChanged();
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
void Cabin_Temperature::writeCompleted()
{
    emit varChanged();
}
//ICP
void Cabin_Temperature::ReadICPCompleted()
{
    //Tu nhiet
    voltSupplySensor = cabin_rs485->dataFloat[5]*3;
    currentSensorTemp1 = cabin_rs485->dataFloat[3];
    currentSensorTemp2 = cabin_rs485->dataFloat[4];
    //bien tro dieu chinh setpoint
    setpoit_varitor = cabin_rs485->dataFloat[6]*150.0f/5.2f;

    write_SP(setpoit_varitor);

    emit varChanged();
}
