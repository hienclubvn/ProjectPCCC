QT += quick virtualkeyboard serialbus serialport widgets sql charts

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        devices/cabin_smoke.cpp \
        devices/cabin_temperature.cpp \
        devices/getcomport.cpp \
        devices/modbus.cpp \
        devices/rs485.cpp \
        devices/uart.cpp \
        listModels/deviceModel.cpp \
        listModels/deviceparameter.cpp \
        main.cpp \
        ui/baseobject.cpp \
        ui/dialitem.cpp \
        ui/dothi.cpp \
        ui/login.cpp \
        ui/logindevice.cpp \
        utils/config.cpp \
        utils/dataobject.cpp \
        utils/localdatabase.cpp \
        utils/logger.cpp \
        utils/network.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

INCLUDEPATH += devices \
    listModels \
    ui \
    utils

DISTFILES +=

HEADERS += \
    devices/cabin_smoke.hpp \
    devices/cabin_temperature.hpp \
    devices/getcomport.h \
    devices/modbus.hpp \
    devices/rs485.hpp \
    devices/uart.hpp \
    listModels/deviceModel.h \
    listModels/deviceparameter.h \
    ui/baseobject.h \
    ui/dialitem.h \
    ui/dothi.hpp \
    ui/login.hpp \
    ui/logindevice.hpp \
    utils/config.h \
    utils/constant.h \
    utils/dataobject.h \
    utils/localdatabase.h \
    utils/logger.h \
    utils/network.h
