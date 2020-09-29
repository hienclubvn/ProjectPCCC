import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import "FlatUI-Controls-QML-master"
import IVIControls 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls 2.12
import QtCharts 2.3
import QtQuick.Extras 1.4
import Qt.labs.calendar 1.0
import QtQuick.Controls.Styles.Desktop 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs.qml 1.0
import QtQuick.VirtualKeyboard 2.4
import QtTest 1.2
import QtQuick.Extras.Private 1.0
import QtQuick.Controls.Styles 1.4

Item {
    anchors.fill: parent
    Component.onCompleted: screenLabel.text = qsTr("CÀI ĐẶT THÔNG SỐ")

    Rectangle{
        anchors.fill: parent
        color: "#ddf6fe"

        Rectangle {
            id: rectangle
            color: "#00000000"
            radius: 4
            anchors.leftMargin: 37
            anchors.bottomMargin: 31
            anchors.topMargin: 31
            border.color: "#064fe2"
            border.width: 1
            anchors.rightMargin: 28
            anchors.fill: parent

            GroupBox {
                id: groupBox
                width: 230
                height: 380
                anchors.right: parent.right
                anchors.rightMargin: 727
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.top: parent.top
                anchors.topMargin: 14
                title: qsTr("Ngưỡng - cảm biến báo khói")
                //
                label: Label {
                    x: control.leftPadding
                    y: 10
                    width: control.availableWidth
                    color: "#21be2b"
                    text: " Ngưỡng - Đầu báo 01"
                    font.bold: false
                    font.pointSize: 12
                    font.underline: true
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    y: control.topPadding - control.bottomPadding
                    width: parent.width
                    height: parent.height - control.topPadding + control.bottomPadding
                    color: "#00000000"
                    radius: 6
                    border.color: "#21be2b"
                    border.width: 2
                }

                PrimaryButton {
                    id: btn_cbNhiet01
                    x: 365
                    y: 248
                    width: 159
                    height: 74
                    text: "Cập nhập"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18
                    pointSize: 16
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    onButton_press: {
                        Cabin_Temp.threshold_baoChay01 = parseFloat(ip_baochay1.text)
                        Cabin_Temp.threshold_nganMach01 = parseFloat(ip_nganmach1.text)
                    }
                }

                Input {
                    id: ip_baochay1
                    x: 33
                    y: 44
                    width: 175
                    height: 60
                    text: Cabin_Temp.threshold_baoChay01.toFixed(2)
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                }

                Label {
                    id: label
                    x: 37
                    y: 17
                    color: "#032fe1"
                    text: qsTr("Dòng báo cháy (mA)")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Label {
                    id: label1
                    x: 44
                    y: 118
                    color: "#032fe1"
                    text: qsTr("Dòng ngắn mạch (mA)")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 12
                }

                Input {
                    id: ip_nganmach1
                    x: 42
                    y: 142
                    height: 60
                    text: Cabin_Temp.threshold_nganMach01.toFixed(2)
                    anchors.verticalCenterOffset: 11
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                }
                //

            }

            GroupBox {
                id: groupBox2
                x: 12
                y: 1
                height: 388
                anchors.left: parent.left
                label: Label {
                    x: control.leftPadding
                    y: 10
                    width: control.availableWidth
                    color: "#21be2b"
                    text: "Thời gian TimeOut"
                    font.pointSize: 12
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.underline: true
                }
                anchors.leftMargin: 714
                anchors.rightMargin: 20
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                PrimaryButton {
                    id: btn_timeOut
                    x: 365
                    y: 248
                    width: 159
                    height: 74
                    text: "Cập nhập"
                    pointSize: 16
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenterOffset: 0
                    anchors.bottomMargin: 18
                    onButton_press: {
                        Cabin_Temp.threshold_TimeOut01 = parseInt(ip_timeout1.text)
                        Cabin_Temp.threshold_TimeOut02 = parseInt(ip_timeout2.text)
                    }
                }

                Input {
                    id: ip_timeout1
                    x: 33
                    y: 44
                    width: 175
                    height: 60
                    text: Cabin_Temp.threshold_TimeOut01
                    font.pointSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                }

                Label {
                    id: label4
                    x: 37
                    y: 17
                    color: "#032fe1"
                    text: qsTr("Đầu báo cháy 01 (giây)")
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Label {
                    id: label5
                    x: 39
                    y: 118
                    color: "#032fe1"
                    text: qsTr("Đầu báo cháy 02 (giây)")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                }

                Input {
                    id: ip_timeout2
                    x: 42
                    y: 96
                    width: 175
                    height: 60
                    text: Cabin_Temp.threshold_TimeOut02
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 30
                    anchors.verticalCenterOffset: 11
                }
                title: qsTr("Ngưỡng - cảm biến báo khói")
                anchors.top: parent.top
                background: Rectangle {
                    y: control.topPadding - control.bottomPadding
                    width: parent.width
                    height: parent.height - control.topPadding + control.bottomPadding
                    color: "#00000000"
                    radius: 6
                    border.width: 2
                    border.color: "#21be2b"
                }
                anchors.bottomMargin: 16
            }

            GroupBox {
                id: groupBox1
                x: -9
                y: -8
                width: 230
                height: 388
                anchors.rightMargin: 494
                PrimaryButton {
                    id: btn_cbNhiet02
                    x: 365
                    y: 248
                    width: 159
                    height: 74
                    text: "Cập nhập"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    pointSize: 16
                    onButton_press: {
                        Cabin_Temp.threshold_baoChay02 = parseFloat(ip_baochay2.text)
                        Cabin_Temp.threshold_nganMach02 = parseFloat(ip_nganmach2.text)
                    }
                }

                Input {
                    id: ip_baochay2
                    x: 33
                    y: 44
                    width: 175
                    height: 60
                    text: Cabin_Temp.threshold_baoChay02.toFixed(2)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 30
                }

                Label {
                    id: label2
                    x: 37
                    y: 17
                    color: "#032fe1"
                    text: qsTr("Dòng báo cháy (mA)")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                }

                Label {
                    id: label3
                    x: 44
                    y: 118
                    color: "#032fe1"
                    text: qsTr("Dòng ngắn mạch (mA)")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                }

                Input {
                    id: ip_nganmach2
                    x: 42
                    y: 142
                    height: 60
                    text: Cabin_Temp.threshold_nganMach02.toFixed(2)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 30
                    anchors.verticalCenterOffset: 11
                }
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.topMargin: 14
                anchors.left: parent.left
                anchors.right: parent.right
                label: Label {
                    x: control.leftPadding
                    y: 10
                    width: control.availableWidth
                    color: "#21be2b"
                    text: "  Ngưỡng - Đầu báo 02"
                    font.pointSize: 12
                    font.underline: true
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                }
                background: Rectangle {
                    y: control.topPadding - control.bottomPadding
                    width: parent.width
                    height: parent.height - control.topPadding + control.bottomPadding
                    color: "#00000000"
                    radius: 6
                    border.color: "#21be2b"
                    border.width: 2
                }
                title: qsTr("Ngưỡng - cảm biến báo khói")
                anchors.top: parent.top
                anchors.leftMargin: 252
            }

            GroupBox {
                id: groupBox3
                x: -8
                y: -10
                height: 388
                anchors.rightMargin: 261
                PrimaryButton {
                    id: btn_thresholdNhiet01
                    x: 365
                    y: 248
                    width: 159
                    height: 74
                    text: "Cập nhập"
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    pointSize: 16
                    onButton_press: {
                        Cabin_Temp.threshold_Temp01 = parseFloat(ip_thresholdTemp1.text)
                        Cabin_Temp.threshold_Temp02 = parseFloat(ip_thresholdTemp2.text)
                    }
                }

                Input {
                    id: ip_thresholdTemp1
                    x: 33
                    y: 44
                    width: 175
                    height: 60
                    text: Cabin_Temp.threshold_Temp01.toFixed(1)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 30
                }

                Label {
                    id: label6
                    x: 37
                    y: 17
                    color: "#032fe1"
                    text: qsTr("Nhiệt độ đầu báo 01")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                }

                Label {
                    id: label7
                    x: 44
                    y: 118
                    color: "#032fe1"
                    text: qsTr("Nhiệt độ đầu báo 02")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 12
                }

                Input {
                    id: ip_thresholdTemp2
                    x: 42
                    y: 142
                    height: 60
                    text: Cabin_Temp.threshold_Temp02.toFixed(1)
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 30
                    anchors.verticalCenterOffset: 11
                }
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 16
                anchors.topMargin: 14
                anchors.left: parent.left
                anchors.right: parent.right
                label: Label {
                    x: control.leftPadding
                    y: 10
                    width: control.availableWidth
                    color: "#21be2b"
                    text: "  Ngưỡng - Nhiệt độ"
                    font.pointSize: 12
                    font.underline: true
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignLeft
                }
                background: Rectangle {
                    y: control.topPadding - control.bottomPadding
                    width: parent.width
                    height: parent.height - control.topPadding + control.bottomPadding
                    color: "#00000000"
                    radius: 6
                    border.color: "#21be2b"
                    border.width: 2
                }
                title: qsTr("Ngưỡng - cảm biến báo khói")
                anchors.top: parent.top
                anchors.leftMargin: 485
            }
        }
    }
}























































































































































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:1024}
}
 ##^##*/
