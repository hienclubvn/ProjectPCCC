import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import "FlatUI-Controls-QML-master"
import IVIControls 1.0
import QtQuick.Controls 1.2
import QtCharts 2.3
import QtQuick.Extras 1.4
import Qt.labs.calendar 1.0
import QtQuick.Controls.Styles.Desktop 1.0
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import QtQuick.Dialogs.qml 1.0
import QtQuick.VirtualKeyboard 2.4
import QtTest 1.2

import QtQuick.Controls.Styles 1.4
import QtQuick.Extras.Private 1.0

Item {
    anchors.fill: parent
    Component.onCompleted: screenLabel.text = qsTr("THỬ NGHIỆM BẰNG TAY")

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent

        Input {
            id: input
            x: 37
            y: 90
            text: Cabin_Temp.q_temperature.toFixed(1)
            readOnly: true
            disabled: false
        }

        Input {
            id: input1
            x: 37
            y: 144
            text: Cabin_Temp.q_humidity.toFixed(1)
            readOnly: true
            disabled: false
        }

        Input {
            id: input2
            x: 38
            y: 211
            text: Cabin_Temp.q_temperature_sensor.toFixed(1)    //PV
            readOnly: true
            disabled: false
        }

        Input {
            id: input3
            x: 37
            y: 257
            text: Cabin_Temp.q_setpointSP.toFixed(1)
            readOnly: true
            disabled: false
        }

        Input {
            id: input4
            x: 349
            y: 90
            text: Cabin_Temp.q_volt_sensor_supply.toFixed(1)
            readOnly: true
            disabled: false
        }
        Input {
            id: input5
            x: 349
            y: 144
            text: Cabin_Temp.q_volt_sensor1_respone.toFixed(2)
            readOnly: true
            disabled: false
        }
        Input {
            id: input6
            x: 349
            y: 206
            text: Cabin_Temp.q_volt_sensor2_respone.toFixed(2)
            readOnly: true
            disabled: false
        }


        Input {
            id: input7
            x: 38
            y: 332
            text: Cabin_Temp.q_start_led_state.toString()
            readOnly: true
            disabled: false
        }

        Text {
            id: element
            x: 37
            y: 62
            text: qsTr("ModbusRTU - SHT11")
            font.pixelSize: 12
        }

        Text {
            id: element1
            x: 37
            y: 190
            text: qsTr("ModbusRTU - Bộ điều khiển nhiệt (PV,SP)")
            font.pixelSize: 12
        }

        Text {
            id: element2
            x: 37
            y: 311
            text: qsTr("ModbusRTU - GPIO State")
            font.pixelSize: 12
        }

        Text {
            id: element3
            x: 371
            y: 62
            text: qsTr("RS485 - ICP Dcon")
            font.pixelSize: 12
        }

        Text {
            id: element4
            x: 332
            y: 282
            text: qsTr("ModbusRTU - Bộ điều khiển nhiệt (setpoint)")
            font.pixelSize: 12
        }

        Input {
            id: input8
            x: 349
            y: 303
            //text: Cabin_Temp.q_setpointSP.toFixed(1)
            readOnly: false
            disabled: false
            onTextChanged: Cabin_Temp.q_setpointSP = parseFloat(input8.text)
        }

        PrimaryButton {
            id: primaryButton
            x: 253
            y: 394
            width: 122
            height: 64
            text: "Alarm 1"
            onButton_press: Cabin_Temp.writeAlarm(0,!Cabin_Temp.q_output_alarm1_state)

        }

        PrimaryButton {
            id: primaryButton1
            x: 402
            y: 394
            width: 122
            height: 64
            text: "Alarm 2"
            onButton_press: Cabin_Temp.writeAlarm(1,!Cabin_Temp.q_output_alarm2_state)
        }
    }

}

















/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:200;anchors_width:200;anchors_x:100;anchors_y:159}
}
 ##^##*/
