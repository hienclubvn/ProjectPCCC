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
    Component.onCompleted: screenLabel.text = qsTr("KIỂM ĐỊNH TỰ ĐỘNG")
    //
    Timer { //Button Start (Running)
        interval: 500; running: true; repeat: true
        //
        onTriggered: {
            toggleButton.checked = Cabin_Temp.q_run_system_state;
            //
            if (Cabin_Temp.q_run_system_state) toggleButton.text = qsTr("DỪNG LẠI");
            else toggleButton.text = qsTr("BẮT ĐẦU");
            //
            if (bIsAlarm1) statusAlarm01.active = !statusAlarm01.active;
            if (bIsAlarm2) statusAlarm01.active = !statusAlarm02.active;
        }
    }
    //
    property var x_var: 0
    property bool bIsAlarm1: false
    property bool bIsAlarm2: false
    property bool bIsRun: false
    //
    Timer { //ve do thi..
        interval: 1000; running: true; repeat: true
        onTriggered:{
            if (bIsRun){
                x_var ++;
                lineSeries.append(x_var, Cabin_Temp.q_volt_sensor1_respone);
                lineSeries1.append(x_var, Cabin_Temp.q_volt_sensor2_respone);
                lineSeries2.append(x_var, Cabin_Temp.threshold_Temp01);
                //
                //axisY.max = 10.5 + 5.0;
                //axisY.min = -2;
                if (lineSeries.count > axisX.max)
                {
                    axisX.min = axisX.max;
                    axisX.max = axisX.min + 60;
                }
            }
            else {
                x_var = 0;
                //lineSeries.clear(); lineSeries1.clear(); lineSeries2.clear();
                //axisX.min = 0;
                //axisX.max = 60;
            }
        }
    }
    //
    property int nCountTime1: 0
    property int nCountTime2: 0
    property bool bIsRunED: false
    property bool bTimeOut1: false
    Timer { //process
        id: timeClock
        interval: 1000
        running: true //false
        repeat: true
        onTriggered:{
            if (Cabin_Temp.q_run_system_state){
                bIsRun = true;
            }
            else {
                bIsRun = false;
                bIsAlarm1 = false;
                bIsAlarm2 = false;
                Cabin_Temp.writeAlarm(0,false);
                Cabin_Temp.writeAlarm(1,false);
                statusAlarm01.active = false;
                statusAlarm02.active = false;
                Cabin_Temp.write_RunModuleTemp(false);
                //
                if (nCountTime > 0) bIsRunED = true;
            }
            //
            if (bIsRun) {
                //cho gia nhiet
                Cabin_Temp.write_RunModuleTemp(true);
                //reset..
                if (bIsRunED)  {
                    nCountTime1 = 0;  nCountTime2 = 0;
                    bIsRunED = false;
                    bTimeOut1 = bTimeOut2 = false;
                    //
                    lineSeries.clear(); lineSeries1.clear();
                    axisX.min = 0;
                    axisX.max = 60;
                    //
                }
                //check Thresholds + nCountTime1
                if ((Cabin_Temp.q_temperature_sensor >= Cabin_Temp.threshold_Temp01) & !bIsAlarm1) {
                    nCountTime1++;
                    //
                    if (Cabin_Temp.q_volt_sensor1_respone >= Cabin_Temp.threshold_baoChay01) {
                        Cabin_Temp.writeAlarm(0,true);
                        bIsAlarm1 = true;
                        //
                        stack4.clear()
                        stack4.push("CabinTemp_Result.qml")

                    } else {
                        Cabin_Temp.writeAlarm(0,false);
                        statusAlarm01.active = false;
                        bIsAlarm1 = false;
                        stack4.clear()
                    }
                    //
                }
                //check Thresholds + nCountTime2
                if ((Cabin_Temp.q_temperature_sensor >= Cabin_Temp.threshold_Temp02) & !bIsAlarm2) {
                    nCountTime2++;
                    //
                    if (Cabin_Temp.q_volt_sensor2_respone >= Cabin_Temp.threshold_baoChay02) {
                        Cabin_Temp.writeAlarm(1,true);
                        bIsAlarm1 = true;
                        //
                        stack5.clear()
                        stack5.push("CabinTemp_Result.qml")

                    } else {
                        Cabin_Temp.writeAlarm(1,false);
                        statusAlarm02.active = false;
                        bIsAlarm2 = false;
                        stack5.clear()
                    }
                    //
                }
                //
                txt_time_threshold01.text = (nCountTime1 % 60).toFixed(0)
                txt_time_threshold02.text = (nCountTime2 % 60).toFixed(0)
                //
                if (nCountTime1 > Cabin_Temp.threshold_Temp01) bTimeOut1 = true;
                if (nCountTime2 > Cabin_Temp.threshold_Temp02) bTimeOut2 = true;

                if (bTimeOut1 & bTimeOut2){
                    Cabin_Temp.writeStateRunSystem(false);
                }
            } //bRun
            else {
                if (bTimeOut1) {
                    //cho 02 stack voi ket qua khac nhau cho nhanh./
                    stack4.clear()
                    stack4.push("CabinTemp_ResultTimeOut.qml")
                }
                if (bTimeOut2) {
                    stack5.clear()
                    stack5.push("CabinTemp_ResultTimeOut.qml")
                }
            }
            // no-if-else
        }
    } //end-Timer

    Rectangle {
        id: rectangle
        color: "#e4f9ff"
        anchors.fill: parent

        Rectangle {
            id: rectangle1
            color: "#00000000"
            anchors.leftMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.rightMargin: parent.width/2
            anchors.fill: parent

            Rectangle {
                id: rectangle5
                color: "#00000000"
                radius: 4
                border.color: "#0a38da"
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.topMargin: 5
                anchors.bottomMargin: parent.height/2
                anchors.fill: parent
                anchors.top: rectangle3.bottom

                GroupBox {
                    id: groupBox2
                    anchors.leftMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.rightMargin: parent.width/2
                    anchors.fill: parent
                    //title: qsTr("Group Box")
                    //
                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "transparent"
                        border.color: "#21be2b"
                        radius: 4
                        border.width: 2
                    }
                    label: Label {
                        x: control.leftPadding
                        y: 6
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "   Bộ điều khiển nhiệt"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    //
                    CircularGauge {
                        id: circularGauge
                        x: 13
                        width: 200
                        height: 200
                        anchors.horizontalCenterOffset: 0
                        anchors.top: parent.top
                        anchors.topMargin: -4
                        anchors.horizontalCenter: parent.horizontalCenter
                        minimumValue: 0
                        maximumValue: 100
                        value: Cabin_Temp.q_temperature_sensor
                        style: CircularGaugeStyle {
                            minimumValueAngle: -90
                            maximumValueAngle: 90
                            //
                            tickmarkLabel:  Text {
                                font.pixelSize: Math.max(6, outerRadius * 0.1)
                                text: styleData.value
                                color: styleData.value < 50 ? "black" : "red"
                                antialiasing: true
                            }
                            //
                            function degreesToRadians(degrees) {
                                return degrees * (Math.PI / 180);
                            }
                            //vẽ một vòng cung giữa 50và 100
                            background: Canvas {
                                //id: canvas0
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.reset();

                                    ctx.beginPath();
                                    ctx.strokeStyle = "red"
                                    ctx.lineWidth = outerRadius * 0.02;

                                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                            degreesToRadians(valueToAngle(50) - 90), degreesToRadians(valueToAngle(100) - 90));
                                    ctx.stroke();
                                }
                            }
                            //Tô màu các điểm gạch lớn (bội của 10, <80)
                            tickmark: Rectangle {
                                //visible: styleData.value < 80 || styleData.value % 10 == 0
                                visible: styleData.value % 10 == 0  //Chỉ hiện thị các điểm là bội 10
                                implicitWidth: outerRadius * 0.02
                                antialiasing: true
                                implicitHeight: outerRadius * 0.1//06
                                color: styleData.value >= 50 ? "#e34c22" : "#0000ff"
                            }
                            //Tô màu các điểm gạch nhỏ
                            minorTickmark: Rectangle {
                                //visible: styleData.value < 80 //Tô những gạch nhỏ hơn <80
                                implicitWidth: outerRadius * 0.01
                                antialiasing: true
                                implicitHeight: outerRadius * 0.05//3
                                color: styleData.value >= 50 ? "red" : "black"
                                //color: "black"
                            }
                        }

                        Label {
                            id: label3
                            x: 91
                            y: 58
                            text: qsTr("o")
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            Label {
                                id: label4
                                x: 8
                                y: 11
                                text: qsTr("C")
                            }
                        }
                    }

                    ColumnLayout {
                        x: 7
                        y: 8
                        width: 60
                        anchors.leftMargin: 8
                        anchors.left: parent.left
                        Text {
                            id: element15
                            color: "#0534db"
                            text: "Nhiệt độ (PV):"
                            font.pixelSize: 14
                        }

                        Text {
                            id: element16
                            color: "#0534db"
                            text: "Nhiệt đặt (SV):"
                            font.pixelSize: 14
                        }
                        anchors.top: parent.top
                        anchors.bottomMargin: -3
                        anchors.topMargin: 109
                        anchors.bottom: parent.bottom
                    }

                    ColumnLayout {
                        x: -4
                        y: 8
                        width: 67
                        anchors.leftMargin: 107
                        anchors.left: parent.left
                        Textinput {
                            id: txt_tempPV
                            text: Cabin_Temp.q_temperature_sensor.toFixed(1)
                            font.pointSize: 14
                            borderColor: "orange"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 59
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            readOnly: true
                        }

                        Textinput {
                            id: txt_tempSV
                            text: Cabin_Temp.q_setpointSP.toFixed(1)//"35.2"
                            font.pointSize: 14
                            borderColor: "orange"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 59
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            readOnly: true
                        }
                        anchors.top: parent.top
                        anchors.bottomMargin: -3
                        anchors.topMargin: 109
                        anchors.bottom: parent.bottom
                    }

                    ColumnLayout {
                        x: -1
                        y: -3
                        width: 38
                        anchors.leftMargin: 181
                        anchors.left: parent.left
                        Text {
                            id: element17
                            color: "#0534db"
                            text: "(*C)"
                            Layout.preferredHeight: 19
                            Layout.preferredWidth: 26
                            font.pixelSize: 14
                        }

                        Text {
                            id: element18
                            color: "#0534db"
                            text: "(*C)"
                            Layout.preferredHeight: 19
                            Layout.preferredWidth: 26
                            font.pixelSize: 14
                        }
                        anchors.top: parent.top
                        anchors.bottomMargin: -3
                        anchors.topMargin: 109
                        anchors.bottom: parent.bottom
                    }
                    //

                }

                GroupBox {
                    id: groupBox3
                    x: -1
                    y: 7
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.left: groupBox2.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.leftMargin: 4
                    anchors.rightMargin: 4
                    label: Label {
                        x: control.leftPadding
                        y: 6
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Nhiệt độ môi trường"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "#00000000"
                        radius: 4
                        border.color: "#21be2b"
                        border.width: 2
                    }

                    CircularGauge {
                        id: circularGauge1
                        x: 0
                        y: 0
                        width: 190
                        height: 180
                        value: Cabin_Temp.q_temperature
                        anchors.left: parent.left
                        anchors.leftMargin: -5
                        stepSize: 0
                        anchors.top: parent.top
                        minimumValue: 20
                        maximumValue: 100
                        anchors.topMargin: -5
                        style: CircularGaugeStyle {
                            minimumValueAngle: -90
                            maximumValueAngle: 0
                            //
                            tickmarkLabel:  Text {
                                visible: styleData.value % 20 == 0  //Chỉ hiện thị các điểm là bội 10
                                font.pixelSize: Math.max(6, outerRadius * 0.1)
                                text: styleData.value
                                color: styleData.value < 80 ? "black" : "red"
                                antialiasing: true
                            }
                            //
                            function degreesToRadians(degrees) {
                                return degrees * (Math.PI / 180);
                            }
                            //vẽ một vòng cung giữa 50và 100
                            background: Canvas {
                                //id: canvas0
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.reset();

                                    ctx.beginPath();
                                    ctx.strokeStyle = "red"
                                    ctx.lineWidth = outerRadius * 0.02;

                                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                            degreesToRadians(valueToAngle(80) - 90), degreesToRadians(valueToAngle(100) - 90));
                                    ctx.stroke();
                                }
                            }
                            //Tô màu các điểm gạch lớn (bội của 10, <80)
                            tickmark: Rectangle {
                                //visible: styleData.value < 80 || styleData.value % 10 == 0
                                visible: styleData.value % 10 == 0  //Chỉ hiện thị các điểm là bội 10
                                implicitWidth: outerRadius * 0.02
                                antialiasing: true
                                implicitHeight: outerRadius * 0.1//06
                                color: styleData.value >= 80 ? "#e34c22" : "#0000ff"
                            }
                            //Tô màu các điểm gạch nhỏ
                            minorTickmark: Rectangle {
                                //visible: styleData.value < 80 //Tô những gạch nhỏ hơn <80
                                implicitWidth: outerRadius * 0.01
                                antialiasing: true
                                implicitHeight: outerRadius * 0.05//3
                                color: styleData.value >= 80 ? "red" : "black"
                                //color: "black"
                            }
                        }

                        Label {
                            id: label
                            x: 63
                            y: 46
                            text: qsTr("o")

                            Label {
                                id: label1
                                x: 8
                                y: 11
                                text: qsTr("C")
                            }
                        }
                    }

                    CircularGauge {
                        id: circularGauge2
                        x: 0
                        y: 0
                        width: 190
                        height: 180
                        value: CabinTemp.q_humidity
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        z: 1
                        stepSize: 0
                        anchors.leftMargin: parent.width/2
                        anchors.top: parent.top
                        minimumValue: 50
                        maximumValue: 100
                        anchors.topMargin: -5
                        style: CircularGaugeStyle {
                            tickmark: Rectangle {
                                color: styleData.value >= 80 ? "#e34c22" : "#0000ff"
                                implicitHeight: outerRadius * 0.1
                                antialiasing: true
                                implicitWidth: outerRadius * 0.02
                                visible: styleData.value % 10 == 0
                            }
                            minorTickmark: Rectangle {
                                color: styleData.value >= 80 ? "red" : "black"
                                implicitHeight: outerRadius * 0.05
                                antialiasing: true
                                implicitWidth: outerRadius * 0.01
                            }
                            maximumValueAngle: 0
                            tickmarkLabel: Text {
                                color: styleData.value < 80 ? "black" : "red"
                                text: styleData.value
                                antialiasing: true
                                font.pixelSize: Math.max(6, outerRadius * 0.1)
                                visible: styleData.value % 10 == 0
                            }
                            //
                            function degreesToRadians(degrees) {
                                return degrees * (Math.PI / 180);
                            }
                            //vẽ một vòng cung giữa 50và 100
                            background: Canvas {
                                //id: canvas0
                                onPaint: {
                                    var ctx = getContext("2d");
                                    ctx.reset();

                                    ctx.beginPath();
                                    ctx.strokeStyle = "red"
                                    ctx.lineWidth = outerRadius * 0.02;

                                    ctx.arc(outerRadius, outerRadius, outerRadius - ctx.lineWidth / 2,
                                            degreesToRadians(valueToAngle(80) - 90), degreesToRadians(valueToAngle(100) - 90));
                                    ctx.stroke();
                                }
                            }
                            minimumValueAngle: -90
                        }
                        anchors.left: parent.left

                        Label {
                            id: label2
                            x: 57
                            y: 50
                            width: 33
                            height: 16
                            text: qsTr("%RH")
                        }
                    }

                    ColumnLayout {
                        width: 38
                        anchors.left: parent.left
                        anchors.leftMargin: 160
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        anchors.top: parent.top
                        anchors.topMargin: 108

                        Text {
                            id: element12
                            color: "#0534db"
                            text: "(*C)"
                            Layout.preferredWidth: 26
                            font.pixelSize: 14
                            Layout.preferredHeight: 19
                        }

                        Text {
                            id: element14
                            color: "#0534db"
                            text: "(%RH)"
                            font.pixelSize: 14
                            Layout.preferredWidth: 26
                            Layout.preferredHeight: 19
                        }
                    }

                    ColumnLayout {
                        width: 59
                        anchors.top: parent.top
                        anchors.topMargin: 108
                        anchors.left: parent.left
                        anchors.leftMargin: 87
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2

                        Textinput {
                            id: textinput4
                            text: Cabin_Temp.q_temperature.toFixed(1)
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            readOnly: true
                            borderColor: "orange"
                            Layout.preferredWidth: 59
                            Layout.preferredHeight: 30
                        }

                        Textinput {
                            id: textinput5
                            text: Cabin_Temp.q_humidity.toFixed(1)
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            readOnly: true
                            borderColor: "orange"
                            Layout.preferredWidth: 59
                            Layout.preferredHeight: 30
                        }
                    }

                    ColumnLayout {
                        width: 60
                        anchors.top: parent.top
                        anchors.topMargin: 108
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        anchors.left: parent.left
                        anchors.leftMargin: 16

                        Text {
                            id: element11
                            color: "#0534db"
                            text: "Nhiệt độ:"
                            font.pixelSize: 14
                        }

                        Text {
                            id: element13
                            color: "#0534db"
                            text: "Độ ẩm:    "
                            font.pixelSize: 14
                        }
                    }


                }






            }

            Rectangle {
                id: rectangle6
                x: 0
                y: 0
                color: "#00000000"
                radius: 4
                border.color: "#0712cf"
                anchors.top: rectangle5.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin: 5
                anchors.leftMargin: 5
                anchors.rightMargin: 5
                anchors.topMargin: 5

                GroupBox {
                    id: groupBox
                    anchors.leftMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.rightMargin: parent.width/2
                    anchors.fill: parent
                    //title: qsTr("Group Box")
                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "transparent"
                        border.color: "#21be2b"
                        radius: 4
                        border.width: 2
                    }
                    label: Label {
                        x: control.leftPadding
                        y: 6
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Điều khiển hệ thống"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }

                    ToggleButton {
                        id: toggleButton
                        x: 0
                        y: 32
                        width: 170
                        height: 170
                        //text: qsTr("BẮT ĐẦU")
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        //checked: Cabin_Temp.q_run_system_state
                        //
                        onClicked:
                        {
                            Cabin_Temp.writeStateRunSystem(!Cabin_Temp.q_run_system_state)
                        }
                    }
                }

                GroupBox {
                    id: groupBox1
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.left: groupBox.right
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    anchors.leftMargin: 5
                    title: qsTr("Group Box")
                    //
                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "transparent"
                        border.color: "#21be2b"
                        radius: 4
                        border.width: 2
                    }
                    label: Label {
                        x: control.leftPadding
                        y: 6
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Góc quay cảm biến"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    //

                    Dial {
                        id: dial
                        x: 0
                        y: -6
                        width: 190
                        height: 190
                        anchors.verticalCenterOffset: 4
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        stepSize: 45
                        maximumValue: 315
                        value: 45
                        onValueChanged: Cabin_Temp.writeAngleStepMotor(parseInt(dial.value.toFixed(0)))
                        style: DialStyle{
                            id: dialStyle
                            tickmarkLabel:
                                Text {
                                color: "red"
                                visible: styleData.value % 45 == 0
                                text: styleData.value
                                font.pixelSize: 14
                                //renderType: Text.QtRendering
                                styleColor: "#f94646"
                                //lineHeight: 0
                                //font.kerning: false
                                //font.preferShaping: false
                                font.bold: true
                                antialiasing: true
                                //styleData.value >= 300 ? "#e34c22" : "#0000ff" //"#e5e5e5"
                            }
                        }
                    }


                }
            }
        }

        Rectangle {
            id: rectangle2
            color: "#00000000"
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            anchors.topMargin: 5
            anchors.left: rectangle1.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 5

            Rectangle {
                id: rectangle3
                color: "#00000000"
                radius: 4
                border.color: "#0531c8"
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.topMargin: 5
                anchors.bottomMargin: parent.height/2
                anchors.fill: parent

                GroupBox {
                    id: grBox_CBKhoi
                    height: 222
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.rightMargin: 249
                    anchors.leftMargin: 5
                    anchors.topMargin: 4
                    //flat: false
                    //title: qsTr("    Cảm biến: Đầu báo khói")

                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "transparent"
                        border.color: "#21be2b"
                        radius: 4
                        border.width: 2
                    }
                    label: Label {
                        x: control.leftPadding
                        y: 4
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Đầu báo nhiệt 01"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }


                    GroupBox {
                        id: grBox_Volt_Ample
                        anchors.top: parent.top
                        anchors.topMargin: -11
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 43
                        anchors.right: parent.right
                        anchors.rightMargin: 99
                        anchors.left: parent.left
                        anchors.leftMargin: -2
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }

                        Text {
                            id: element
                            x: 12
                            y: -7
                            color: "#0534db"
                            text: "Điện áp (Volt)"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 14
                        }

                        Textinput {
                            id: textinput
                            x: 10
                            y: 13
                            width: 71
                            height: 40
                            text: Cabin_Temp.q_volt_sensor_supply.toFixed(1)
                            font.pointSize: 14
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            borderColor: "orange"
                            readOnly: true
                        }

                        Text {
                            id: element1
                            x: 10
                            y: 61
                            color: "#0434e0"
                            text: "Dòng điện (mA)"
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 14
                        }

                        Textinput {
                            id: textinput1
                            x: 12
                            y: 82
                            width: 72
                            height: 40
                            text: Cabin_Temp.q_volt_sensor_respone.toFixed(2)
                            font.pointSize: 14
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            borderColor: "orange"
                            readOnly: true
                        }
                        //title: qsTr("Điện áp & Dòng điện")





                    }

                    GroupBox {
                        id: grBox_Volt_Ample2
                        x: -1
                        y: 3
                        anchors.leftMargin: 124
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottomMargin: 43
                        anchors.topMargin: -11
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: -2
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }

                        StatusIndicator {
                            id: statusShort01
                            x: -1
                            y: 81
                            width: 45
                            height: 45
                            color: "#ff0000"
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            active: false
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            Layout.preferredHeight: 55
                            Layout.preferredWidth: 55
                        }

                        Text {
                            id: element5
                            x: 0
                            y: -8
                            width: 61
                            height: 15
                            color: "#f81ea4"
                            text: qsTr("Báo nhiệt")
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                        }

                        Text {
                            id: element6
                            x: -5
                            y: 61
                            width: 72
                            height: 15
                            color: "#f81ea4"
                            text: qsTr("Ngắn mạch  ")
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                        }

                        StatusIndicator {
                            id: statusAlarm01
                            x: 0
                            y: 11
                            width: 45
                            height: 45
                            color: "#00ff00"
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter
                            active: Cabin_Temp.q_output_alarm1_state
                            Layout.preferredHeight: 55
                            Layout.preferredWidth: 55
                        }
                    }

                    GroupBox {
                        id: groupBox4
                        anchors.right: parent.right
                        anchors.rightMargin: -2
                        anchors.left: parent.left
                        anchors.leftMargin: -2
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -6
                        anchors.top: parent.top
                        anchors.topMargin: 134
                        //title: qsTr("Group Box")
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }

                        Textinput {
                            id: txt_time_threshold01
                            x: 102
                            y: -7
                            width: 49
                            height: 38
                            text: "00"
                            font.pointSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            borderColor: "orange"
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            readOnly: true
                        }

                        Label {
                            id: label7
                            x: -5
                            y: -3
                            width: 103
                            height: 19
                            color: "#025ade"
                            text: qsTr("Thời gian \nVượt ngưỡng")
                            horizontalAlignment: Text.AlignHCenter
                            anchors.verticalCenterOffset: -8
                            anchors.verticalCenter: parent.verticalCenter
                            font.pointSize: 11
                        }

                        Label {
                            id: label8
                            x: 156
                            y: 5
                            width: 45
                            height: 19
                            color: "#025ade"
                            text: qsTr("(giây)")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 1
                            font.pointSize: 12
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }

                GroupBox {
                    id: grBox_CBKhoi1
                    x: 9
                    y: -6
                    anchors.bottom: grBox_CBKhoi.bottom
                    anchors.bottomMargin: 0
                    anchors.right: parent.right
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 250
                    GroupBox {
                        id: grBox_Volt_Ample1
                        anchors.leftMargin: -2
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.top: parent.top
                        anchors.bottomMargin: 43
                        Text {
                            id: element2
                            x: 12
                            y: -7
                            color: "#0534db"
                            text: "Điện áp (Volt)"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 14
                        }

                        Textinput {
                            id: textinput2
                            x: 10
                            y: 13
                            width: 71
                            height: 40
                            text: Cabin_Temp.q_volt_sensor_supply.toFixed(1)
                            font.pointSize: 14
                            anchors.horizontalCenter: parent.horizontalCenter
                            borderColor: "orange"
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            readOnly: true
                        }

                        Text {
                            id: element3
                            x: 10
                            y: 61
                            color: "#0434e0"
                            text: "Dòng điện (mA)"
                            anchors.horizontalCenter: parent.horizontalCenter
                            font.pixelSize: 14
                            anchors.horizontalCenterOffset: 0
                        }

                        Textinput {
                            id: textinput3
                            x: 12
                            y: 82
                            width: 72
                            height: 40
                            text: Cabin_Temp.q_volt_sensor_respone.toFixed(2)
                            font.pointSize: 14
                            anchors.horizontalCenter: parent.horizontalCenter
                            borderColor: "orange"
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            readOnly: true
                            anchors.horizontalCenterOffset: 0
                        }
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }
                        anchors.topMargin: -11
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 99
                    }

                    GroupBox {
                        id: grBox_Volt_Ample3
                        x: -1
                        y: 3
                        anchors.leftMargin: 124
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottomMargin: 43
                        StatusIndicator {
                            id: statusShort02
                            x: -1
                            y: 81
                            width: 45
                            height: 45
                            color: "#ff0000"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.preferredHeight: 55
                            active: false
                            Layout.preferredWidth: 55
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            anchors.horizontalCenterOffset: 0
                        }

                        Text {
                            id: element7
                            x: 0
                            y: -8
                            width: 61
                            height: 15
                            color: "#f81ea4"
                            text: qsTr("Báo nhiệt")
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                            anchors.horizontalCenterOffset: 0
                        }

                        Text {
                            id: element8
                            x: -5
                            y: 61
                            width: 72
                            height: 15
                            color: "#f81ea4"
                            text: qsTr("Ngắn mạch  ")
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            font.pixelSize: 14
                            anchors.horizontalCenterOffset: 0
                        }

                        StatusIndicator {
                            id: statusAlarm02
                            x: 0
                            y: 11
                            width: 45
                            height: 45
                            color: "#00ff00"
                            anchors.horizontalCenter: parent.horizontalCenter
                            Layout.preferredHeight: 55
                            active: Cabin_Temp.q_output_alarm1_state
                            Layout.preferredWidth: 55
                            anchors.horizontalCenterOffset: 0
                        }
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }
                        anchors.topMargin: -11
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: -2
                    }

                    GroupBox {
                        id: groupBox5
                        anchors.leftMargin: -2
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.top: parent.top
                        anchors.bottomMargin: -6
                        Textinput {
                            id: txt_time_threshold02
                            x: 102
                            y: -7
                            width: 49
                            height: 38
                            text: "00"
                            borderColor: "orange"
                            anchors.verticalCenter: parent.verticalCenter
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 60
                            readOnly: true
                            font.pointSize: 14
                        }

                        Label {
                            id: label9
                            x: -5
                            y: -3
                            width: 103
                            height: 19
                            color: "#025ade"
                            text: qsTr("Thời gian \nVượt ngưỡng")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: -9
                            font.pointSize: 11
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Label {
                            id: label10
                            x: 155
                            y: 5
                            width: 45
                            height: 19
                            color: "#025ade"
                            text: qsTr("(giây)")
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: 1
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: 12
                        }
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }
                        anchors.topMargin: 134
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: -2
                    }
                    background: Rectangle {
                        y: control.topPadding - control.bottomPadding
                        width: parent.width
                        height: parent.height - control.topPadding + control.bottomPadding
                        color: "#00000000"
                        radius: 4
                        border.color: "#21be2b"
                        border.width: 2
                    }
                    label: Label {
                        x: control.leftPadding
                        y: 4
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Đầu báo nhiệt 02"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }
                    anchors.topMargin: 4
                    anchors.rightMargin: 4
                }
            }

            Rectangle {
                id: rectangle4
                color: "#93d5fe"
                anchors.rightMargin: 5
                anchors.leftMargin: 5
                anchors.bottomMargin: 5
                anchors.top: rectangle3.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 5

                ChartView {
                    id: spline
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 0
                    anchors.topMargin: 0
                    anchors.fill: parent
                    ValueAxis {
                        id: axisY
                        color: "#000000"
                        min: -2
                        gridVisible: true
                        labelFormat: "%.0f"
                        max: 100 //> nguong.
                        labelsColor: "#000000"
                    }

                    ValueAxis {
                        id: axisX
                        color: "#000000"
                        min: 0
                        tickCount: 5
                        gridVisible: false
                        labelFormat: "%.0f"
                        max: 60
                        labelsColor: "#000000"
                    }

                    LineSeries {
                        id: lineSeries
                        name: "Đầu báo 01"
                        color: "#ff0000"
                        axisX: axisX
                        axisY: axisY
                    }
                    LineSeries {
                        id: lineSeries1
                        name: "Đầu báo 02"
                        color: "green" //#c69b07"//"yellow" //"#c714f4"
                        axisX: axisX
                        axisY: axisY
                    }
                    LineSeries {
                        id: lineSeries2
                        name: "Ngưỡng nhiệt"
                        color: "blue"
                        axisX: axisX
                        axisY: axisY
                    }
                }
            }
        }

        StackView {
            id: stack4
            x: 532
            y: 232
            width: 185
            height: 70
        }

        StackView {
            id: stack5
            x: 794
            y: 232
            width: 185
            height: 70
        }


    }

}






































































































































































































































































































































































































































































































































































































































































































































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:1024}D{i:72;anchors_x:10}D{i:73;anchors_x:12}
D{i:74;anchors_x:12}D{i:71;anchors_x:10}D{i:80;anchors_height:38;anchors_width:200;anchors_x:0;anchors_y:139}
D{i:81;anchors_height:38;anchors_width:200;anchors_x:0;anchors_y:139}D{i:89;anchors_x:10}
D{i:90;anchors_x:12}D{i:91;anchors_x:12}D{i:88;anchors_x:10}D{i:98;anchors_height:38;anchors_width:200;anchors_x:0;anchors_y:139}
D{i:99;anchors_height:38;anchors_width:200;anchors_x:0;anchors_y:139}
}
 ##^##*/
