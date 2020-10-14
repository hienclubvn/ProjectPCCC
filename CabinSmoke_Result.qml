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
    id: wd_result
    width: 380
    height: 250
    //
    Timer {
        interval: 500
        running: true //false
        repeat: true
        onTriggered:{
            label.visible = !label.visible
        }
    }
    //
    property var volt: 0.0
    property var current: 0.0

    Timer {
        interval: 500
        running: true //false
        repeat: false
        onTriggered:{
            volt = Cabin_Smoke.q_volt_sensor_supply;
            current = Cabin_Smoke.q_volt_sensor_respone;
        }
    }
    //
    Rectangle {
        id: rectangle
        height: 258
        color: "#4393f8"
        radius: 4
        border.color: "#dc0c8b"
        border.width: 2
        anchors.fill: parent

        Label {
            id: label
            x: 116
            y: 73
            color: "#edf467"
            text: qsTr("PASSED")
            anchors.verticalCenterOffset: -101
            anchors.horizontalCenterOffset: 77
            visible: true
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 20
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: stack3.clear()

            Label {
                id: label5
                x: 88
                y: 14
                width: 79
                height: 28
                text: qsTr("Kết quả:")
                font.pointSize: 14
            }
        }

        ColumnLayout {
            x: 244
            y: 54
            width: 120
            height: 175

            Input {
                id: txtMdKhoi
                width: 130
                text: Cabin_Smoke.q_density_smoke.toFixed(1)
                Layout.fillWidth: true//"11.0"
                borderColor: "orange"
                Layout.preferredHeight: 40
                Layout.preferredWidth: 99
                font.pointSize: 20
            }

            Input {
                id: txtVolt
                width: 130
                text: Cabin_Smoke.q_volt_sensor_supply.toFixed(2) //volt.toFixed(2) //
                Layout.fillWidth: true//"12.0"
                borderColor: "orange"
                Layout.preferredHeight: 40
                Layout.preferredWidth: 99
                font.pointSize: 20
            }

            Input {
                id: txtDong
                width: 130
                text: Cabin_Smoke.q_volt_sensor_respone.toFixed(2) //current.toFixed(2) //
                Layout.fillWidth: true//"13.0"
                borderColor: "orange"
                Layout.preferredHeight: 40
                Layout.preferredWidth: 99
                font.pointSize: 20
            }

            Input {
                id: txtTime
                width: 130
                text: Cabin_Smoke.q_time_reponse.toFixed(0)
                Layout.fillWidth: true
                borderColor: "orange"
                Layout.preferredHeight: 40
                Layout.preferredWidth: 99
                font.pointSize: 20
            }
        }

        ColumnLayout {
            x: 17
            y: 53
            width: 200
            height: 180

            Label {
                id: label2
                text: qsTr("Mật độ khói:")
                font.pointSize: 14
            }

            Label {
                id: label1
                text: qsTr("Điện áp cảm biến")
                font.pointSize: 14
            }

            Label {
                id: label3
                text: qsTr("Dòng điện cảm biến")
                font.pointSize: 14
            }

            Label {
                id: label4
                text: qsTr("Thời gian vượt ngưỡng:")
                font.pointSize: 14
            }
        }



    }

}

















