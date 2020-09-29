import QtQuick 2.0
import QtCharts 2.3
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import "FlatUI-Controls-QML-master"
import QtQuick.Dialogs 1.1

Item {
    id: window
    width: 1024
    height: 600
    visible: true

    //
    Timer { //ModbusRTU
        interval: 200; running: true; repeat: true
        //
        onTriggered: {
            Cabin_Temp.readAllData()
        }
    }
    //
    Timer { //RS485
        interval: 100; running: true; repeat: true
        //
        onTriggered: {
            Cabin_Temp.sendRequest() //RS485
        }
    }

    Component.onCompleted: {
        Modbus.startConnection();
        RS485.openSerialPort();
    }

    Rectangle{
        id: rectangle
        anchors.fill: parent
        color: "#ddf6fe"

        Text {
            id: screenLabel
            x: 244
            anchors.top: parent.top
            anchors.topMargin: 16
            color: "#fd1d1d"
            text: qsTr("THIẾT BỊ KIỂM ĐỊNH " + LoginDevice.deviceModelName())
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignLeft
            font.capitalization: Font.AllUppercase
            font.family: "Tahoma"
            font.pixelSize: 27
            font.bold: true
        }

        StackView {
            id: stack2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: screenLabel.bottom
            anchors.bottom: footer.top
            anchors.topMargin: 20
            replaceEnter: Transition {
                PropertyAnimation{
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                }
            }

            replaceExit: Transition {
                PropertyAnimation{
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 250
                }
            }

            Row {
                width: parent.width - 20
                height: parent.height
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Column {
                    width: 480
                    anchors.top: parent.top
                    height: 450
                    anchors.topMargin: 0
                    spacing: parent.height/3 - 120

                    PrimaryButton{
                        id: thuNghiem
                        width: 400
                        height: 120
                        radius: 6
                        text: "              KIỂM ĐỊNH TỰ ĐỘNG"
                        gradient: Gradient {
                            GradientStop {
                                position: 0
                                color: "#1abc9c"
                            }

                            GradientStop {
                                position: 1
                                color: "#000000"
                            }
                        }
                        textColor: "blue"
                        pointSize: 16
                        border.color: "#4dade9"
                        activeFocusOnTab: false
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/play2.png"
                            anchors.left:  parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                stack2.push("CabinTemp_TestAuto.qml")
                            }
                        }
                    }

                    PrimaryButton {
                        id: thuNghiemBangTay
                        width: 400
                        height: 120
                        radius: 6
                        text: "             KIỂM ĐỊNH BẰNG TAY"
                        textColor: "blue"
                        pointSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/hand2.png"
                            anchors.left: parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            height: 64
                            anchors.fill: parent
                            onClicked: {
                                stack2.push("CabinTemp_Manual.qml")
                            }
                        }
                    }

                    PrimaryButton {
                        id: capNhat
                        width: 400
                        height: 120
                        radius: 6
                        text: "         CẬP NHẬT THÔNG SỐ\n                  KIỂM ĐỊNH"
                        textColor: "blue"
                        pointSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/update2.png"
                            anchors.left: parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked:
                            {
                                //                                if (LoginDevice.logged()){
                                //                                    HieuChinh.readJson()
                                //                                    //stack2.push("HieuChinhThamSo.qml")
                                //                                } else {
                                //                                    stack2.push("LoginDevice.qml")
                                //                                }
                            }
                        }
                    }
                }

                Column {
                    width: 480
                    height: 450
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    spacing: parent.height/3 - 120

                    PrimaryButton {
                        id: thuNghiem4
                        width: 400
                        height: 120
                        radius: 6
                        text: "              CÀI ĐẶT THÔNG SỐ "
                        textColor: "blue"
                        pointSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/adjust2.png"
                            anchors.left: parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stack2.push("CabinTemp_SetupSystem.qml")
                        }
                    }

                    PrimaryButton {
                        id: setupConnect
                        width: 400
                        height: 120
                        radius: 6
                        text: "         CÀI ĐẶT KẾT NỐI"
                        textColor: "blue"
                        border.color: "#1b26d2"
                        pointSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/setting2.png"
                            anchors.left: parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: stack2.push("CabinTemp_setupConnect.qml")
                        }
                    }

                    PrimaryButton {
                        id: thuNghiem2
                        width: 400
                        height: 120
                        radius: 6
                        text: "           LỊCH SỬ KIỂM ĐỊNH"
                        textColor: "blue"
                        pointSize: 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled: stack2.empty
                        Image {
                            width: 100
                            height: 100
                            anchors.verticalCenter: parent.verticalCenter
                            source: "qrc:/Icon/history2.png"
                            anchors.left: parent.left
                            scale: 0.7
                        }
                        MouseArea {
                            height: 120
                            anchors.fill: parent
                            onClicked: stack2.push("CabinTemp_HistoryTest.qml")
                        }
                    }
                }

            }
        }

        Image {
            id: userAvatar
            source: "qrc:/Icon/account.png"
            scale: 0.8
            anchors.right: parent.right
            anchors.top: parent.top
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    stack2.clear()
                    stack2.push("Menu.qml")
                }
            }
        }

        Text {
            anchors.right: userAvatar.left
            height: userAvatar.height
            text: qsTr("Xin chào\n") + QLogin.displayedNamed()
            font.pointSize: 10
            font.weight: Font.Bold
            font.family: "Tahoma"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Row {
            id: footer
            y: 551
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 50
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0

            Rectangle{
                x: 0
                width: 200
                height: homeBtn.height
                color: "palegoldenrod"
                radius: 0
                visible: true
                anchors.left: parent.left
                anchors.leftMargin: 450
                transformOrigin: Item.Center
                Text {
                    id: perphiralStatusTxt
                    anchors.top: perphiralStatus.top
                    anchors.right: perphiralStatus.left
                    height: homeBtn.height
                    text: qsTr("Kết nối\nModbusRTU")
                    font.bold: false
                    horizontalAlignment: Text.AlignHCenter
                    style: Text.Normal
                    font.weight: Font.ExtraBold
                    font.capitalization: Font.MixedCase
                    font.family: "Tahoma"
                    anchors.rightMargin: 15
                    anchors.leftMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
                DangerButton {
                    id: perphiralStatus
                    width: 100
                    height: homeBtn.height
                    text: ""
                    radius: 7
                    color: "palegoldenrod"
                    anchors.right: parent.right
                    anchors.bottom:  parent.bottom
                    Image {
                        width: 70
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        source: Modbus.q_connectionState ? "qrc:/Icon/tick.png" : "qrc:/Icon/close.png"
                        scale: 0.7
                    }
                }
            }

            Rectangle{
                width: 200
                height: homeBtn.height
                color: "palegoldenrod"
                radius: 1
                anchors.left: parent.left
                anchors.leftMargin: 800
                Text {
                    id: sensorStatusTxt
                    anchors.top: sensorStatus.top
                    anchors.right: sensorStatus.left
                    height: homeBtn.height
                    text: qsTr("Kết nối\nRS485-ICP")
                    font.family: "Tahoma"
                    font.bold: false
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.ExtraBold
                    font.capitalization: Font.MixedCase
                    anchors.rightMargin: 15
                    anchors.leftMargin: 15
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 12
                }
                DangerButton {
                    id: sensorStatus
                    text: ""
                    color: "palegoldenrod"
                    radius: 3
                    width: 100
                    height: 50
                    anchors.right: parent.right
                    anchors.bottom:  parent.bottom
                    Image {
                        width: 70
                        height: 70
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        source: RS485.q_connectionState ? "qrc:/Icon/tick.png" : "qrc:/Icon/close.png"
                        scale: 0.7
                    }
                }
            }



            DangerButton {
                id: homeBtn
                text: "Home"
                textColor: "blue"
                pointSize: 16
                color: "#16f2c1"
                radius: 3
                width: 200
                height: 50
                anchors.left: parent.left
                anchors.bottom:  parent.bottom
                Image {
                    source: "qrc:/Icon/home2.png"
                    anchors.left: parent.left
                    scale: 0.5
                }
                MouseArea {
                    anchors.topMargin: 0
                    anchors.fill: parent
                    onClicked: {
                        //                        if (LoginDevice.deviceModelName() !== ""){
                        //                            screenLabel.text = "THIẾT BỊ KIỂM ĐỊNH " + LoginDevice.deviceModelName()
                        //                            if (!stack2.empty) stack2.clear()
                        //                            screenLabel.text = qsTr("THIẾT BỊ KIỂM ĐỊNH " + LoginDevice.deviceModelName())
                        //                        } else {
                        //                            messageDialog.visible = true
                        //                        }
                        stack2.clear()
                        //stack.push("CabinTemp_MainWindow.qml")
                    }
                }
            }
        }



    }
}




































































































































