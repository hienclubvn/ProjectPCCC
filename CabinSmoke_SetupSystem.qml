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
                height: 388
                anchors.right: parent.right
                anchors.rightMargin: 658
                anchors.left: parent.left
                anchors.leftMargin: 25
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
                    text: "    Đặt Ngưỡng - cảm biến báo khói"
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
                    id: update_cbkhoi
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
                        Cabin_Smoke.threshold_baokhoi = parseFloat(ip_baokhoi.text)
                        Cabin_Smoke.threshold_chapmach = parseFloat(ip_nganmach.text)
                    }
                }

                Input {
                    id: ip_baokhoi
                    x: 33
                    y: 44
                    width: 175
                    height: 60
                    text: Cabin_Smoke.threshold_baokhoi.toFixed(2)
                    readOnly: true
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                }

                Label {
                    id: label
                    x: 37
                    y: 17
                    color: "#032fe1"
                    text: qsTr("Dòng báo khói (mA)")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 14
                }

                Label {
                    id: label1
                    x: 44
                    y: 118
                    color: "#032fe1"
                    text: qsTr("Dòng ngắn mạch (mA)")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 14
                }

                Input {
                    id: ip_nganmach
                    x: 42
                    y: 142
                    height: 60
                    text: Cabin_Smoke.threshold_chapmach.toFixed(2)
                    readOnly: true
                    anchors.verticalCenterOffset: 11
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: 30
                }
                //

            }

            GroupBox {
                id: groupBox1
                x: 25
                y: 8
                width: 276
                height: 388
                anchors.horizontalCenter: parent.horizontalCenter
                label: Label {
                    x: control.leftPadding
                    y: 10
                    width: control.availableWidth
                    color: "#21be2b"
                    text: "    Đặt Ngưỡng - Mật độ khói"
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.underline: true
                }
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                PrimaryButton {
                    id: update_matdokhoi
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
                    onButton_press: Cabin_Smoke.threshold_matdokhoi = parseFloat(ip_matdokhoi.text)
                }

                Input {
                    id: ip_matdokhoi
                    x: 33
                    y: 33
                    width: 175
                    height: 60
                    text: Cabin_Smoke.threshold_matdokhoi.toFixed(2)
                    anchors.verticalCenterOffset: 11
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                }

                Label {
                    id: label2
                    x: 37
                    y: 112
                    color: "#032fe1"
                    text: qsTr("Mật độ khói (%)")
                    anchors.horizontalCenterOffset: 1
                    font.pointSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
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
                    text: "    Đặt Ngưỡng - Thời gian chờ"
                    horizontalAlignment: Text.AlignLeft
                    elide: Text.ElideRight
                    font.underline: true
                }
                anchors.leftMargin: 655
                anchors.rightMargin: 28
                anchors.topMargin: 14
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                PrimaryButton {
                    id: update_timeOut
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
                    onButton_press: Cabin_Smoke.threshold_timeout = parseInt(ip_timeout.text)
                }

                Input {
                    id: ip_timeout
                    x: 33
                    y: 103
                    width: 175
                    height: 60
                    text: Cabin_Smoke.threshold_timeout
                    anchors.verticalCenterOffset: 11
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 30
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.horizontalCenterOffset: 0
                }

                Label {
                    id: label4
                    x: 37
                    y: 114
                    color: "#032fe1"
                    text: qsTr("Thời gian chờ (giây)")
                    anchors.horizontalCenterOffset: 0
                    font.pointSize: 14
                    anchors.horizontalCenter: parent.horizontalCenter
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
        }
    }
}

































































































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:1024}D{i:3;anchors_width:276;anchors_x:25;anchors_y:14}
D{i:11;anchors_width:276;anchors_x:25;anchors_y:14}D{i:17;anchors_width:276;anchors_x:25;anchors_y:14}
D{i:2;anchors_height:200;anchors_width:200}
}
 ##^##*/
