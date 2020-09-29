import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.0
import "FlatUI-Controls-QML-master"
import QtQml 2.0
import QtQuick.Layouts 1.0
Item {
    antialiasing: true
    anchors.fill: parent
    Component.onCompleted: screenLabel.text = qsTr("CÀI ĐẶT KẾT NỐI HỆ THỐNG")

    Rectangle{
        id: rectangle
        anchors.fill: parent
        color: "lightblue"

        GroupBox {
            id: groupBox
            width: 322
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 150
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
                y: 10
                width: control.availableWidth
                color: "#fb1bbd"
                text: "    Cổng COM: ModbusRTU"
                font.bold: true
                font.capitalization: Font.AllUppercase
                font.underline: true
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
            }

            RowLayout {
                y: 8
                height: 40
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    width: 75
                    text: qsTr("Port")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterPort
                    radius: 1
                    text: "ttyUSBModbus"
                    Layout.preferredWidth: 200
                    transformOrigin: Item.Center
                    dropdownTextColor: "black"
                    model:  ListModel {
                        id: listPort
                        ListElement {item: "";separator:false}
                    }
                    z: 5
                }
            }

            RowLayout {
                y: 62
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    width: 70
                    text: qsTr("Baudrate")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterBaudrate
                    radius: 1
                    text: Modbus.baudrate
                    Layout.preferredWidth: 200
                    dropdownTextColor: "black"
                    model: ListModel {
                        ListElement {item: "9600";}
                    }
                    z: 4
                }
            }

            RowLayout {
                y: 117
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    width: 75
                    text: qsTr("Databits")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterDatabits
                    radius: 1
                    text: Modbus.databits
                    Layout.preferredWidth: 200
                    dropdownTextColor: "black"
                    model: ListModel {
                        ListElement {item: "8";}
                    }
                    z: 3
                    objectName: "dropdownMasterDatabits"
                }
            }

            RowLayout {
                y: 171
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    text: qsTr("Stopbits")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterStop
                    radius: 1
                    text: Modbus.stopbits
                    Layout.preferredWidth: 200
                    dropdownTextColor: "black"
                    model: ListModel {
                        ListElement {item: "1";}
                    }
                    z: 2
                }
            }

            RowLayout {
                y: 225
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    text: qsTr("Parity")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterParity
                    radius: 1
                    text: Modbus.parity
                    Layout.preferredWidth: 200
                    dropdownTextColor: "black"
                    model: ListModel {
                        ListElement {item: "None";}
                        ListElement {item: "Even"; separator: true}
                        ListElement {item: "Odd"; separator: true}
                    }
                    z: 1
                }
            }

            RowLayout {
                y: 282
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 13

                Text {
                    width: 70
                    text: qsTr("Flow")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterFlow
                    radius: 1
                    text: Modbus.flow
                    Layout.preferredWidth: 200
                    dropdownTextColor: "black"
                    model: ListModel {
                        ListElement {item: "None";}
                    }
                }
            }

            RowLayout {
                y: 345
                height: 56
                anchors.left: parent.left
                anchors.leftMargin: 36
                anchors.right: parent.right
                anchors.rightMargin: 13
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 11

                PrimaryButton {
                    height: parent.height
                    text: "Kết nối"
                    Layout.fillHeight: true
                    Layout.fillWidth: false
                    Layout.preferredWidth: 110
                    border.color: "#00000000"
                    border.width: 1
                    transformOrigin: Item.Left
                    color: "lightgreen"
                    radius: 4
                    onButton_press: {
                        Modbus.portname = dropdownMasterPort.text
                        Modbus.baudrate = parseInt(dropdownMasterBaudrate.text)
                        Modbus.databits = parseInt(dropdownMasterDatabits.text)
                        Modbus.flow = dropdownMasterFlow.text
                        Modbus.parity = dropdownMasterParity.text
                        Modbus.stopbits = parseInt(dropdownMasterStop.text)
                        Modbus.startConnection();
                    }
                }

                DangerButton {
                    height: parent.height
                    text: "Ngắt kết nối"
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: false
                    Layout.preferredWidth: 110
                    onButton_press:  Modbus.stopConnection()
                }
            }







        }

        GroupBox {
            id: groupBox1
            x: -4
            y: 4
            width: 322
            anchors.right: parent.right
            anchors.rightMargin: 150
            anchors.top: parent.top
            anchors.bottomMargin: 10
            RowLayout {
                y: 8
                height: 40
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    width: 75
                    text: qsTr("Port")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterPort1
                    radius: 1
                    text: "ttyUSBDcon"
                    dropdownTextColor: "black"
                    transformOrigin: Item.Center
                    Layout.preferredWidth: 200
                    model: ListModel {
                        id: listPort1
                        ListElement {
                            separator: false
                            item: ""
                        }
                    }
                    z: 5
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 62
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    width: 70
                    text: qsTr("Baudrate")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterBaudrate1
                    radius: 1
                    text: RS485.baudrate
                    dropdownTextColor: "black"
                    Layout.preferredWidth: 200
                    model: ListModel {
                        ListElement {
                            item: "9600"
                        }
                    }
                    z: 4
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 117
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    width: 75
                    text: qsTr("Databits")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterDatabits1
                    radius: 1
                    text: RS485.databits
                    dropdownTextColor: "black"
                    Layout.preferredWidth: 200
                    model: ListModel {
                        ListElement {
                            item: "8"
                        }
                    }
                    z: 3
                    objectName: "dropdownMasterDatabits"
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 171
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    text: qsTr("Stopbits")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterStop1
                    radius: 1
                    text: RS485.stopbits
                    dropdownTextColor: "black"
                    Layout.preferredWidth: 200
                    model: ListModel {
                        ListElement {
                            item: "1"
                        }
                    }
                    z: 2
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 225
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    text: qsTr("Parity")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterParity1
                    radius: 1
                    text: RS485.parity
                    dropdownTextColor: "black"
                    Layout.preferredWidth: 200
                    model: ListModel {
                        ListElement {
                            item: "None"
                        }

                        ListElement {
                            separator: true
                            item: "Even"
                        }

                        ListElement {
                            separator: true
                            item: "Odd"
                        }
                    }
                    z: 1
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 282
                anchors.leftMargin: 5
                anchors.right: parent.right
                anchors.left: parent.left
                Text {
                    width: 70
                    text: qsTr("Flow")
                    Layout.preferredWidth: 75
                    horizontalAlignment: Text.AlignLeft
                }

                Dropdown {
                    id: dropdownMasterFlow1
                    radius: 1
                    text: RS485.flow
                    dropdownTextColor: "black"
                    Layout.preferredWidth: 200
                    model: ListModel {
                        ListElement {
                            item: "None"
                        }
                    }
                }
                anchors.rightMargin: 13
            }

            RowLayout {
                y: 345
                height: 56
                anchors.leftMargin: 36
                anchors.right: parent.right
                anchors.left: parent.left
                PrimaryButton {
                    height: parent.height
                    color: "lightgreen"
                    radius: 4
                    text: "Kết nối"
                    transformOrigin: Item.Left
                    Layout.fillWidth: false
                    Layout.preferredWidth: 110
                    border.color: "#00000000"
                    border.width: 1
                    Layout.fillHeight: true
                    onButton_press: {
                        RS485.portname = dropdownMasterPort1.text
                        RS485.baudrate = parseInt(dropdownMasterBaudrate1.text)
                        RS485.databits = parseInt(dropdownMasterDatabits1.text)
                        RS485.flow = dropdownMasterFlow1.text
                        RS485.parity = dropdownMasterParity1.text
                        RS485.stopbits = parseInt(dropdownMasterStop1.text)
                        RS485.openSerialPort();
                    }
                }

                DangerButton {
                    height: parent.height
                    text: "Ngắt kết nối"
                    Layout.fillWidth: false
                    Layout.preferredWidth: 110
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillHeight: true
                    onButton_press: RS485.closeSerialPort();
                }
                anchors.bottomMargin: 11
                anchors.bottom: parent.bottom
                anchors.rightMargin: 13
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
                y: 10
                width: control.availableWidth
                color: "#fb1bbd"
                text: "    Cổng COM: RS485-ICP"
                font.bold: true
                font.underline: true
                font.capitalization: Font.AllUppercase
                horizontalAlignment: Text.AlignLeft
                elide: Text.ElideRight
            }
            anchors.topMargin: 10
            anchors.bottom: parent.bottom
        }



    }
}































































































































































































































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:1024}
}
 ##^##*/
