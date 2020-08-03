import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import "FlatUI-Controls-QML-master"
Item
{
    id: window
    width: 1024
    height: 800

    visible: true
    Clock{
        x: 340
        y: 141
        width: 361
        height: 166
        z: 1

    }




    Canvas{
                id: drawingCanvas
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 1
                anchors.topMargin: 12
                anchors.fill: parent
                onPaint:
                {
                    var ctx = getContext("2d")

                    ctx.fillStyle = "white"
                    ctx.fillRect(0,0,drawingCanvas.width ,drawingCanvas.height )

                    ctx.lineWidth = 1;
                    ctx.strokeStyle = "green"
                    ctx.beginPath()
                    ctx.moveTo(335, 140)
                    ctx.lineTo(335, 700)


                    ctx.moveTo(700, 140)
                    ctx.lineTo(700, 700)

                    ctx.moveTo(400, 300)
                    ctx.lineTo(650, 300)

                    ctx.moveTo(750, 460)
                    ctx.lineTo(1000, 460)
                    //ctx.closePath()
                    ctx.stroke()
                }
            }

    Text {
            x: 109
            y: 177
            text: qsTr("Master Parameter")
            font.pointSize: 16
     }
    Text {
        x: 34
        y: 243
        text: qsTr("Port")
    }

    Dropdown {
        id: dropdownMasterPort
        model: ListModel {
        }
        x: 127
        y: 232
        z: 5
        highlightColor: "black"
    }

    Dropdown {
        id: dropdownMasterBaudrate
        dropdownTextColor: "black"

        model: ListModel {
                ListElement {item: "9600";}
                ListElement {item: "19200"; separator: true}
                ListElement {item: "38400"; separator: true}
                ListElement {item: "115200"; separator: true}
            }
        x: 127
        y: 312
        z: 4
    }

    Dropdown {
        id: dropdownMasterParity
        model: ListModel {
                ListElement {item: "None";}
                ListElement {item: "Even"; separator: true}
                ListElement {item: "Old"; separator: true}
            }
        x: 127
        y: 551
        z: 1
    }

    Dropdown {
        id: dropdownMasterStop
        model: ListModel {
                ListElement {item: "1";}
                ListElement {item: "2"; separator: true}
                ListElement {item: "None"; separator: true}
            }
        x: 127
        y: 471
        z: 2
    }

    Dropdown {
        id: dropdownMasterDatabits
        model: ListModel {
                ListElement {item: "8";}
                ListElement {item: "7"; separator: true}
                ListElement {item: "6"; separator: true}
                ListElement {item: "5"; separator: true}
            }
        x: 127
        y: 392
        z: 3
    }

    Text {
        x: 34
        y: 323
        text: qsTr("Baudrate")
    }

    Text {
        x: 34
        y: 403
        text: qsTr("Data Bits")
    }

    Text {
        x: 34
        y: 554
        text: qsTr("Parity")
    }

    Text {
        x: 34
        y: 483
        text: qsTr("Stop bits")
    }

    Dropdown {
        id: dropdownMasterFlow
        model: ListModel {
                ListElement {item: "None";}
                ListElement {item: "RTS/CTS"; separator: true}
                ListElement {item: "XON/XOFF"; separator: true}
            }
        x: 127
        y: 632
        z: 0
    }

    Text {
        x: 34
        y: 644
        text: qsTr("Flow Control")
    }


    Input {
        id: inverterAddress
        initText: "8192"
        x: 449
        y: 392
    }

    Input {
        initText: "4"
        id: inverterID
        x: 449
        y: 471
    }

    Input {
        id: inverterBaudrate
        initText: "8193"
        x: 449
        y: 551
    }

    Input {
        id: sensorAddress
        initText: "8"
        x: 824
        y: 551
    }

    Input {
        id: sensorID
        initText: "2"
        x: 824
        y: 632
    }



    Input {
        id: valveAddress1
        initText: "1"
        x: 824
        y: 232
    }

    Input {
        id: valveAddress2
        initText: "2"
        x: 824
        y: 311
    }

    Input {
        id: valveAddressID
        initText: "1"
        x: 824
        y: 392
    }

    DangerButton{
        x: 391
        y: 632
        width: 233
        height: 40
        text: "OK"
        MouseArea {
        anchors.fill: parent
        onClicked: stack.pop("MainWindow.qml")
        }
    }



    Text {
        x: 446
        y: 337
        text: qsTr("Inverter Parameter")
        font.pointSize: 16
    }

    Text {
        x: 756
        y: 487
        text: qsTr("Pressure Sensor Parameter")
        font.pointSize: 16
    }

    Text {
        x: 371
        y: 403
        text: qsTr("Address")
    }

    Text {
        x: 374
        y: 483
        text: qsTr("ID")
    }

    Text {
        x: 374
        y: 563
        text: qsTr("Baurate")
    }

    Text {
        x: 738
        y: 563
        text: qsTr("Address")
    }

    Text {
        x: 741
        y: 644
        text: qsTr("ID")
    }

    Text {
        x: 827
        y: 177
        text: qsTr("Valve Parameter")
        font.pointSize: 16
    }

    Text {
        x: 738
        y: 243
        text: qsTr("Address 1")
    }

    Text {
        x: 738
        y: 323
        text: qsTr("Address 2")
    }

    Text {
        x: 738
        y: 404
        text: qsTr("ID")
    }

    Text {
        x: 359
        y: 65
        text: qsTr("PARAMETER SETTING")
        font.pointSize: 24
    }






  }
