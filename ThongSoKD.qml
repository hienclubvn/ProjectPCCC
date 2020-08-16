import QtQuick 2.0
import "FlatUI-Controls-QML-master"
Item {
    width: 1024
    height: 800
    visible: true
    Rectangle{
        anchors.fill: parent
        color: "lightblue"
        Text {
            y: 100
            text: qsTr("THÔNG SỐ KIỂM ĐỊNH")
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 26
        }
    Image {

        source: "qrc:/Icon/account.png"
        scale: 0.8
        anchors.right: parent.right
        anchors.top: parent.top
    }

    Rectangle {
        color: "palegoldenrod"
        width: 175
        height: 64
        anchors.right: parent.right
        anchors.bottom:  parent.bottom
        Image {
            id: state_icon
            source: Modbus.q_connectionState ? "qrc:/Icon/tick.png" : "qrc:/Icon/close.png"
            anchors.right: parent.right
            scale: 0.8
        }

        Text {
            anchors.left:  parent.left
            anchors.verticalCenter: state_icon.verticalCenter
            text: qsTr("     Trang thai \n     ket noi")
            font.pixelSize: 18
        }
    }
    DangerButton {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 175
        height: 64
        text: "      HOME"
        color: "palegoldenrod"
        Image {
             source: "qrc:/Icon/home2.png"
             anchors.left: parent.left
             scale: 0.7
        }
        MouseArea {
        anchors.fill: parent
        onClicked: stack.pop("ThongSoKD.qml")
        }

    }

    Text {
        x: 165
        y: 265
        text: qsTr("MÃ THIẾT BỊ")
    }

    Text {
        x: 165
        y: 348
        text: qsTr("KHỐI LƯỢNG")
    }

    Text {
        x: 165
        y: 428
        text: qsTr("CHIỀU DÀI")
    }
    Text {
        x: 165
        y: 508
        text: qsTr("KIỂU ĐẦU NỐI")
    }
    Text {
        x: 165
        y: 590
        text: qsTr("ÁP SUÂT LÀM VIỆC")
    }
    Text {
        x: 560
        y: 271
        text: qsTr("ÁP SUẤT THỬ")
    }
    Text {
        x: 559
        y: 348
        text: qsTr("LỚP BỘT TAN")
    }
    Text {
        x: 559
        y: 428
        text: qsTr("ĐƯỜNG KÍNH TRONG")
    }
    Text {
        x: 560
        y: 500
        text: qsTr("CHIỀU DÀI LỚP\nTRÁNG CAO SU")
    }
    Text {
        x: 553
        y: 581
        text: qsTr("SỐ KHUYẾT TẬP\n TRÊN BỀ MẶT NGOÀI")
    }

    Grid {
        x: 290
        y: 257
        columns: 2
        rows: 5
        rowSpacing: 40
        columnSpacing: 250
        Input {
        id: mathietbi
        }
        Input {
        id: apsuatthu
        }
        Input {
        id: khoiluong
        }
        Input {
        id: lopbottan
        }
        Input {
        id: chieudai
        }

        Input {
        id: duongkinhtrong
        }
        Input {
        id: kieudaunoi
        }
        Input {
        id: chieudaycaosu
        }
        Input {
        id: apsuatlamviec
        }
        Input {
        id: sokhuyettat
        }
    }

    }
    scale: 0.7
}