// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.symbian 1.1

MouseArea {
    id: listItem

    height: 70
    anchors.left: parent.left; anchors.right: parent.right

    property alias title: titleText.text
    property alias count: countText.text
    signal plusClicked()
    signal minusClicked()
    signal deleteClicked()
    signal renameClicked()

    Image {
        source: "qrc:///qml/images/bg_counter.png"
        anchors.fill: parent
    }
    Item {
        anchors.top: parent.top; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: counterInc.left
        anchors.rightMargin: 8
        clip: true;
        ListItemText {
            id: titleText
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 18
            font.pointSize: 20
        }

        ListItemText {
            id: countText
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 8
            anchors.left: titleText.right
            font.pointSize: 20
            color: "steelblue"
        }
    }

    Button {
        id: counterInc
        iconSource: "qrc:///qml/images/tb_plus.svg"
        onClicked: listItem.plusClicked();
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: counterDec.left
        anchors.rightMargin: 2
    }

    Button {
        id: counterDec
        iconSource: "qrc:///qml/images/tb_minus.svg"
        onClicked: listItem.minusClicked();
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: counterDel.left
        anchors.rightMargin: 4
    }

    Button {
        id: counterDel
        iconSource: "qrc:///qml/images/tb_close.svg"
        onClicked: listItem.deleteClicked();
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 18
    }

    onDoubleClicked: listItem.renameClicked();
}
