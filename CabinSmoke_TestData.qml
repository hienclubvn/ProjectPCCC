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
import QtQuick.Extras.Private 1.0

import QtQuick.Controls.Styles 1.4

Item {

    Rectangle {
        id: rectangle
        color: "#ffffff"
        anchors.fill: parent

        Input {
            id: input5
            x: 269
            y: 101
            text: Cabin_Smoke.q_start_led_state.toString()
        }

        Input {
            id: input4
            x: 61
            y: 294
            text: Cabin_Smoke.q_volt_sensor_respone.toFixed(1)
        }

        Input {
            id: input3
            x: 61
            y: 233
            text: Cabin_Smoke.q_volt_sensor_supply.toFixed(1)
        }

        Input {
            id: input2
            x: 269
            y: 227
            text: Cabin_Smoke.q_angleStepMotor.toFixed(1)
        }

        Input {
            id: input1
            x: 61
            y: 155
            text: Cabin_Smoke.q_humidity.toFixed(1)
        }

        Input {
            id: input
            x: 61
            y: 101
            text: Cabin_Smoke.q_temperature.toFixed(1)
        }

        Text {
            id: element
            x: 64
            y: 80
            text: qsTr("ModbusRTU - Nhiet do + Do am")
            font.pixelSize: 12
        }

        Text {
            id: element1
            x: 287
            y: 200
            text: qsTr("ModbusRTU - Goc quay (get)")
            font.pixelSize: 12
        }

        Text {
            id: element2
            x: 64
            y: 212
            text: qsTr("RS485-ICP (cảm biến khói)")
            font.pixelSize: 12
        }

        Text {
            id: element3
            x: 277
            y: 80
            text: qsTr("ModbusRTU - Button State")
            font.pixelSize: 12
        }

        Text {
            id: element4
            x: 61
            y: 363
            text: qsTr("Uart - Cảm biến mật độ khói")
            font.pixelSize: 12
        }

        Textinput {
            id: textinput
            x: 61
            y: 391
            text: Cabin_Smoke.q_density_smoke.toFixed(1)
        }

        Input {
            id: input6
            x: 269
            y: 314
            //text: Cabin_Smoke.writeAngleStepMotor()
            onTextChanged: Cabin_Smoke.q_angleStepMotor = parseInt(input6.text)
        }

        Text {
            id: element5
            x: 277
            y: 294
            text: qsTr("ModbusRTU - Goc quay (set)")
            font.pixelSize: 12
        }

        PrimaryButton {
            id: primaryButton
            x: 477
            y: 212
            width: 117
            height: 64
            text: "Alarm 01"
            onButton_press: Cabin_Smoke.writeAlarm(0,!Cabin_Smoke.q_output_alarm1_state)
        }

        StatusIndicator {
            id: statusIndicator
            x: 461
            y: 53
            width: 82
            height: 88
            active: Cabin_Smoke.q_output_alarm1_state
        }

    }
}



























/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:200;anchors_width:200;anchors_x:341;anchors_y:200}
}
 ##^##*/
