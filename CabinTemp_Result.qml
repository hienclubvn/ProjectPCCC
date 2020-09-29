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
    width: 185
    height: 70
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
    Rectangle {
        id: rectangle
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
        }
    }

}


















