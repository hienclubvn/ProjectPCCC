#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlContext>
#include <calib_param.h>
#include "dialitem.h"
#include "login.hpp"
#include "logindevice.hpp"
#include "dataobject.h"
//add new-----
#include "getcomport.h"
#include "modbus.hpp"
#include "uart.hpp"
#include "rs485.hpp"
#include "cabin_temperature.hpp"
#include "cabin_smoke.hpp"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
    ComPort * m_comport = new ComPort();
    Modbus * m_modbus = new Modbus; 
    //
    Uart * m_uart = new Uart;
    RS485 * m_rs485 = new RS485;

    Cabin_Temperature *m_cabin_temp = new Cabin_Temperature(m_modbus,m_rs485);
    Cabin_Smoke *m_cabin_smoke = new Cabin_Smoke(m_modbus,m_rs485, m_uart);

    Login *m_login = new Login();
<<<<<<< Updated upstream
    CalibParam *m_CalibParam = new CalibParam();
    DangNhapThietBi *m_DangNhapThietBi = new DangNhapThietBi();
    ThuNghiemBangTay *m_thuNghiemBangTay = new ThuNghiemBangTay(m_cambien, m_bientan, m_modbus, m_relay);
    KiemDinhTuDong *m_kiemDinhTuDong = new KiemDinhTuDong();
    HieuChinhThongSo *m_hieuChinhThongSo = new HieuChinhThongSo();
    qmlRegisterType<DialItem>("IVIControls", 1, 0, "DialItem");
    qmlRegisterType<CamBienApSuat>("camBienApSuat", 1, 0, "CamBienApSuat");
    //qmlRegisterType<HieuChinhThongSo>("HieuChinhThongSo", 1, 0, "HieuChinhThongSo");
=======
    LoginDevice *m_loginDevice = new LoginDevice();
>>>>>>> Stashed changes

    // qmlRegisterType<HieuChinhThongSo>("HieuChinhThongSo", 1, 0, "HieuChinhThongSo");
    //
    qmlRegisterType<DialItem>("IVIControls", 1, 0, "DialItem");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    //
    context->setContextProperty("QLogin", m_login);
<<<<<<< Updated upstream
    context->setContextProperty("LoginTB", m_DangNhapThietBi);
    context->setContextProperty("CParam", m_CalibParam);
    context->setContextProperty("Relay", m_relay);
    context->setContextProperty("TnBangTay", m_thuNghiemBangTay);
    context->setContextProperty("KiemDinhTD", m_kiemDinhTuDong);
    context->setContextProperty("listLoaiVoi", QVariant::fromValue(m_kiemDinhTuDong->listLoaiVoi));
    context->setContextProperty("listApSuatThu", QVariant::fromValue(m_kiemDinhTuDong->listApSuatThu));
    context->setContextProperty("listApSuatLamViec", QVariant::fromValue(m_kiemDinhTuDong->listApSuatLamViec));
    context->setContextProperty("HieuChinh", m_hieuChinhThongSo);
=======
    context->setContextProperty("LoginDevice", m_loginDevice);
    //Device Level
    context->setContextProperty("ComPort", m_comport);
    context->setContextProperty("Modbus", m_modbus);
    context->setContextProperty("Uart", m_uart);            //add_new
    context->setContextProperty("RS485", m_rs485);          //add_new
    // Application - UI
    context->setContextProperty("Cabin_Temp",m_cabin_temp);
    context->setContextProperty("Cabin_Smoke",m_cabin_smoke);

    // Main - UI
>>>>>>> Stashed changes
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
