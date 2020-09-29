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
    Component.onCompleted: screenLabel.text = qsTr("KIỂM ĐỊNH BẰNG TAY")
    //
    Timer { //Button Start (Running)
        interval: 500; running: true; repeat: true
        //
        onTriggered: {
            toggleButton.checked = Cabin_Smoke.q_run_system_state;
            //
            if (Cabin_Smoke.q_run_system_state) toggleButton.text = qsTr("DỪNG LẠI");
            else toggleButton.text = qsTr("BẮT ĐẦU");
            //
            if (bIsAlarm) statusBaoChay.active = !statusBaoChay.active;
        }
    }
    //
    property var x_var: 0
    property var bIsAlarm: false
    property var bIsRun: false
    property var bIsThresholdDensity: false
    //
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered:{
            x_var ++;
            lineSeries.append(x_var, Cabin_Smoke.q_density_smoke);
            //
            //axisY.max = 10.5 + 5.0;
            //axisY.min = -2;
            if (lineSeries.count > axisX.max)
            {
                axisX.min = axisX.max;
                axisX.max = axisX.min + 60;
            }
        }
    }
    //
    property int nCountTime: 0
    property bool bIsRunED: false
    property bool bTimeOut: false
    Timer {
        id: timeClock
        interval: 1000; running: true; repeat: true
        onTriggered:{
            //
            if (Cabin_Smoke.q_run_system_state) bIsRun = true;
            else bIsRun = false;
            //
            if (bIsRun) {
                //reset..
                if (bIsRunED)  {
                    nCountTime = 0; bIsRunED = false;
                    lineSeries.clear();
                    axisX.min = 0;
                    axisX.max = 60;
                    x_var = 0;
                    //
                    bTimeOut = false;
                }
                txtSeconds.text = (nCountTime % 60).toFixed(0)
                txtMinutes.text = Math.floor((nCountTime / 60)).toFixed(0)
                //if (bIsThresholdDensity & !bIsAlarm) //bIsAlarm =true, thi` dung dem time.
                nCountTime++;
                //if (nCountTime > parseInt(txtTimeOut.text)) bTimeOut = true;
                //
                if (Cabin_Smoke.q_volt_sensor_respone >= Cabin_Smoke.threshold_baokhoi) //nguong_baokhoi
                {
                    Cabin_Smoke.writeAlarm(0,true);
                    bIsAlarm = true;

                }
                else {
                    Cabin_Smoke.writeAlarm(0,false);
                    statusBaoChay.active = false;
                    bIsAlarm = false;
                }
            }
            else { //reset
                Cabin_Smoke.writeAlarm(0,false);
                if (nCountTime > 0) bIsRunED = true;
                statusBaoChay.active = false;
                bIsAlarm = false;
            }
            //
            //Cabin_Smoke.q_bIsTimeOut = bTimeOut;
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
                        text: "    Trạng thái hệ thống"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }

                    GroupBox {
                        id: grBox_TimeOut
                        x: -16
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.leftMargin: 0
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.top: parent.top
                        label: Label {
                            x: control.leftPadding
                            y: 5
                            width: control.availableWidth
                            color: "red" //"#21be2b"
                            text: "    Thời gian hoạt động"
                            font.underline: true
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideRight
                        }
                        font.weight: Font.ExtraLight
                        anchors.topMargin: -10
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "#00000000"
                            radius: 4
                            border.color: "#0000ff"
                            border.width: 1
                        }
                        anchors.left: parent.left
                        title: qsTr("Trạng thái cảm biến")

                        RowLayout {
                            x: 0
                            width: 181
                            height: 78
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter

                            Textinput {
                                id: txtMinutes
                                height: 50
                                text: "00"
                                font.pointSize: 30
                                echoMode: 0
                                readOnly: true
                                borderColor: "orange"
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 70
                            }

                            Textinput {
                                id: txtSeconds
                                height: 50
                                text: "00"
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                font.pointSize: 30
                                readOnly: true
                                borderColor: "orange"
                                echoMode: 0
                                Layout.preferredWidth: 80
                                Layout.preferredHeight: 70
                            }
                        }

                        RowLayout {
                            x: 26
                            y: 6
                            width: 145
                            height: 17
                            anchors.horizontalCenterOffset: 0
                            anchors.horizontalCenter: parent.horizontalCenter

                            Label {
                                id: label3
                                color: "#0330e6"
                                text: qsTr("Phút")
                                font.bold: true
                            }

                            Label {
                                id: label4
                                color: "#0330e6"
                                text: qsTr("Giây")
                                font.bold: true
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            }
                        }
                    }
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
                        value: Cabin_Smoke.q_temperature
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
                        value: Cabin_Smoke.q_humidity
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
                            text: Cabin_Smoke.q_temperature.toFixed(1)
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            readOnly: true
                            borderColor: "orange"
                            Layout.preferredWidth: 59
                            Layout.preferredHeight: 30
                        }

                        Textinput {
                            id: textinput5
                            text: Cabin_Smoke.q_humidity.toFixed(1)
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
                        text: "    Tính thời gian hệ thống"
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
                        //checked: Cabin_Smoke.q_run_system_state
                        //
                        onClicked:
                        {
                            Cabin_Smoke.writeStateRunSystem(!Cabin_Smoke.q_run_system_state)
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
                        onValueChanged: Cabin_Smoke.writeAngleStepMotor(parseInt(dial.value.toFixed(0)))
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
                    anchors.bottomMargin: 4
                    anchors.leftMargin: 4
                    anchors.topMargin: 4
                    //flat: false
                    anchors.rightMargin: parent.width/2
                    anchors.fill: parent
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
                        y: 6
                        width: control.availableWidth
                        color: "#21be2b"
                        text: "    Cảm biến: Đầu báo khói"
                        font.underline: true
                        horizontalAlignment: Text.AlignLeft
                        elide: Text.ElideRight
                    }


                    GroupBox {
                        id: grBox_Volt_Ample
                        anchors.top: parent.top
                        anchors.topMargin: -7
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 108
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        //title: qsTr("Điện áp & Dòng điện")

                        ColumnLayout {
                            x: 90
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: -10

                            Textinput {
                                id: textinput
                                y: -1
                                text: Cabin_Smoke.q_volt_sensor_supply.toFixed(1)
                                Layout.preferredHeight: 30
                                Layout.preferredWidth: 60
                                borderColor: "orange"
                                readOnly: true
                            }

                            Textinput {
                                id: textinput1
                                y: 32
                                text: Cabin_Smoke.q_volt_sensor_respone.toFixed(2)
                                Layout.preferredHeight: 30
                                Layout.preferredWidth: 60
                                borderColor: "orange"
                                readOnly: true
                            }
                        }

                        ColumnLayout {
                            x: 3
                            width: 75
                            anchors.top: parent.top
                            anchors.topMargin: -6
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -6

                            Text {
                                id: element
                                color: "#0534db"
                                text: "Điện áp:"
                                font.pixelSize: 14
                            }

                            Text {
                                id: element1
                                color: "#0434e0"
                                text: "Dòng điện:"
                                font.pixelSize: 14
                            }
                        }

                        ColumnLayout {
                            x: 167
                            width: 35
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -11
                            anchors.top: parent.top
                            anchors.topMargin: -10

                            Text {
                                id: element2
                                y: 7
                                color: "#052fc8"
                                text: qsTr("(Volt)")
                                font.pixelSize: 12
                            }

                            Text {
                                id: element3
                                y: 42
                                color: "#0532d5"
                                text: qsTr("(mA)")
                                font.pixelSize: 12
                            }
                        }





                    }

                    GroupBox {
                        id: grBox_CBK_Status
                        font.weight: Font.ExtraLight
                        anchors.top: grBox_Volt_Ample.bottom
                        anchors.topMargin: 10
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -6
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        title: qsTr("Trạng thái cảm biến")
                        //
                        background: Rectangle {
                            y: control.topPadding - control.bottomPadding
                            width: parent.width
                            height: parent.height - control.topPadding + control.bottomPadding
                            color: "transparent"
                            border.color: "blue" //"#21be2b"
                            radius: 4
                            border.width: 1
                        }
                        label: Label {
                            x: control.leftPadding
                            y: 4
                            width: control.availableWidth
                            color: "#fc1515"
                            text: "    Trạng thái cảm biến:"
                            font.underline: true
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideRight
                        }
                        //

                        RowLayout {
                            width: 149
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            anchors.bottomMargin: -8
                            anchors.topMargin: 8

                            StatusIndicator {
                                id: statusBaoChay
                                x: 81
                                width: 50
                                height: 50
                                color: "#00ff00"
                                active: Cabin_Smoke.q_output_alarm1_state
                                Layout.preferredHeight: 55
                                Layout.preferredWidth: 55
                            }

                            StatusIndicator {
                                id: statusNganMach
                                x: 154
                                width: 50
                                height: 50
                                color: "#ff0000"
                                active: false
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                Layout.preferredHeight: 55
                                Layout.preferredWidth: 55
                            }
                        }

                        RowLayout {
                            x: 0
                            y: -12
                            width: 170
                            height: 15
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                id: element5
                                color: "#f81ea4"
                                text: qsTr("     Báo cháy")
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 12
                            }

                            Text {
                                id: element6
                                color: "#f81ea4"
                                text: qsTr("   Ngắn mạch  ")
                                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                font.pixelSize: 12
                            }
                        }
                    }
                }

                GroupBox {
                    id: grBox_DensitySmoke
                    y: -6
                    //flat: false
                    //checkable: false
                    anchors.rightMargin: 4
                    anchors.bottomMargin: 4
                    anchors.topMargin: 4
                    anchors.leftMargin: 4
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    title: qsTr("    Cảm biến: Mật độ khói")
                    anchors.left: grBox_CBKhoi.right
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
                        text: "    Cảm biến: Mật độ khói"
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
                        anchors.top: parent.top
                        anchors.topMargin: -4
                        anchors.horizontalCenter: parent.horizontalCenter
                        minimumValue: 0
                        maximumValue: 100
                        value: Cabin_Smoke.q_density_smoke
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
                    }

                    RowLayout {
                        x: 7
                        y: 118
                        width: 200
                        height: 42
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: element7
                            color: "#0534db"
                            text: "Mật độ khói:"
                            font.pixelSize: 14
                        }

                        Textinput {
                            id: textinput2
                            height: 30
                            text: Cabin_Smoke.q_density_smoke.toFixed(1)
                            readOnly: true
                            borderColor: "orange"
                            Layout.preferredWidth: 65
                            Layout.preferredHeight: 40
                        }

                        Text {
                            id: element8
                            color: "#0534db"
                            text: "(%)"
                            Layout.preferredHeight: 19
                            Layout.preferredWidth: 26
                            font.pixelSize: 14
                        }
                    }
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
                        name: "Mật độ khói"
                        color: "#ff0000"
                        axisX: axisX
                        axisY: axisY
                    }
//                    LineSeries {
//                        id: lineSeries1
//                        name: "Ngưỡng mật độ khói"
//                        color: "blue"
//                        axisX: axisX
//                        axisY: axisY
//                    }
                }
            }
        }


    }

}




































































































































































































































































































































































































































































































































































































































/*##^## Designer {
    D{i:0;autoSize:true;height:470;width:1024}D{i:1;anchors_height:200;anchors_width:200;anchors_x:215;anchors_y:186}
D{i:36;anchors_x:176;anchors_y:112}D{i:39;anchors_x:100;anchors_y:106}D{i:42;anchors_height:59;anchors_x:16;anchors_y:112}
}
 ##^##*/
