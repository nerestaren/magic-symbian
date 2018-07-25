import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: mainPage
    property int life: 20
    property int backId
    Image {
        id: background
        width: parent.width
        height: parent.height
        source: "qrc:///qml/images/bg_serra.png"
    }

    Item {
        id: lifeContainer
        anchors.top: parent.top; anchors.topMargin: 20
        anchors.left: parent.left; anchors.right: parent.right
        height: lifeCounter.height
        Text {
            id: lifeCounter
            anchors.centerIn: parent
            text: life
            color: "black"
            font.pointSize: 64
            style: Text.Outline; styleColor: "#EEEEEE";
        }
    }

    Item {
        anchors.top: lifeContainer.bottom; anchors.bottom: parent.bottom
        anchors.left: parent.left; anchors.right: parent.right
        anchors.margins: 16;
        ListModel {
            id: counterModel
        }
        ListView {
            id: counterView
            model: counterModel
            delegate: CounterDelegate {
                id: counterDelegate
                title: model.counterName
                count: model.counterCount
                onDeleteClicked: {
                    qdDeleteCounter.index = model.index;
                    qdDeleteCounter.open();
                }
                onPlusClicked: counterModel.setProperty(model.index, "counterCount", counterCount + 1);
                onMinusClicked: counterModel.setProperty(model.index, "counterCount", counterCount - 1);
                onRenameClicked: {
                    newCounterDialog.counterIndex = model.index;
                    newCounterDialog.open();
                }
            }
            anchors.fill: parent
            clip: true
        }
    }

    CommonDialog {
        property int counterIndex: -1
        id: newCounterDialog
        titleText: qsTr("Counter name")
        content: TextField {
            id: newCounterTextField
            anchors.margins: 12
            anchors.fill: parent
            opacity: 1
            text: "anterior"
        }
        buttonTexts: [qsTr("Okay"), qsTr("Cancel")]
        onButtonClicked: {
            if (index == 0) {
                if (counterIndex == -1) {
                    counterModel.append({"counterName": newCounterTextField.text, "counterCount": 0});
                } else {
                    counterModel.get(counterIndex).counterName = newCounterTextField.text;
                }
            }
            counterIndex = -1;
        }
        onStatusChanged: {
            if (status == Loader.Null) {
                if (counterIndex == -1) {
                    newCounterTextField.text = "";
                } else {
                    newCounterTextField.text = counterModel.get(counterIndex).counterName;
                }
            }

        }
    }

    CommonDialog {
        id: aboutDialog
        titleText: qsTr("About Magic Lifecounter")
        content: Column {
            width: parent.width
            spacing: 8
            Image {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                source: "qrc:/Magic.svg"
            }
            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "white"
                text: qsTr("(c) 2012 Antoni Oliver - Nerestaren")
            }
            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "steelblue"
                text: "http://hispared.org/extra/nerestaren"
                onLinkActivated: Qt.openUrlExternally("http://hispared.org/extra/nerestaren")
            }
            Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "steelblue"
                text: "nerestaren@hispared.org"
                onLinkActivated: Qt.openUrlExternally("mailto:nerestaren@hispared.org")
            }
        }
        buttonTexts: [qsTr("Okay")]
    }

    QueryDialog {
        id: qdDeleteCounter
        property int index
        titleText: qsTr("Delete counter")
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onStatusChanged: {
            if (status == Loader.Null) {
                message = qsTr("Are you sure you want to delete the counter '%1'?").arg(counterModel.get(index).counterName)
                          + "\n"
            }
        }
        onAccepted: {
            counterModel.remove(index);
        }
    }

    QueryDialog {
        id: qdNewGame
        message: qsTr("Are you sure you want to start a new game?") + "\n"
        titleText: qsTr("New game")
        acceptButtonText: qsTr("Yes")
        rejectButtonText: qsTr("No")
        onAccepted: {
            life = 20;
            counterModel.clear();
        }
    }



    Menu {
        id: mainMenu
        content: MenuLayout {
            MenuItem {
                text: qsTr("New game")
                onClicked: {
                    if (life != 20 || counterModel.count != 0)
                        qdNewGame.open();
                }
            }
            MenuItem {
                text: qsTr("New counter")
                onClicked: {
                    newCounterDialog.open();
                }
            }
            MenuItem {
                text: qsTr("Background change")
                platformSubItemIndicator: true
                onClicked: fonsMenu.open();
            }
            MenuItem {
                text: qsTr("About...")
                onClicked: aboutDialog.open();
            }
        }
    }

    function setBackground(id) {
        switch (id) {
        case 0:
        default:
            background.source = "qrc:///qml/images/bg_serra.png";
            break;
        case 1:
            background.source = "qrc:///qml/images/bg_bolas.png";
            break;
        case 2:
            background.source = "qrc:///qml/images/bg_ajani.png";
            break;
        }
        backId = id;
    }

    Menu {
        id: fonsMenu
        content: MenuLayout {
            MenuItem {
                text: "Serra Angel"
                onClicked: setBackground(0)
            }
            MenuItem {
                text: "Nicol Bolas"
                onClicked: setBackground(1)
            }
            MenuItem {
                text: "Ajani Goldmane"
                onClicked: setBackground(2)
            }
        }
    }

    tools: ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: {
                var db = openDatabaseSync("MagicLifeCounter", "1.0", "Life counter for Magic: The Gathering players ;)", 1000000);
                db.transaction(
                    function(tx) {
                                tx.executeSql('CREATE TABLE IF NOT EXISTS settings(setting TEXT UNIQUE, value INTEGER)');
                                tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?);', ['background', backId]);
                                tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?, ?);', ['life', life]);
                                tx.executeSql('CREATE TABLE IF NOT EXISTS counters(name TEXT, count INTEGER);');
                                tx.executeSql('DELETE FROM counters;');
                                for (var i = 0; i < counterModel.count; i++) {
                                    tx.executeSql('INSERT INTO counters VALUES (?, ?);', [counterModel.get(i).counterName, counterModel.get(i).counterCount])
                                }
                    }
                );
                // Finally quit
                Qt.quit();
            }
        }
        ToolButton {
            flat: true
            iconSource: "qrc:///qml/images/tb_plus.svg"
            onClicked: life += 1
        }
        ToolButton {
            flat: true
            iconSource: "qrc:///qml/images/tb_minus.svg"
            onClicked: life -= 1
        }
        ToolButton {
            flat: true
            iconSource: "toolbar-menu"
            //onClicked: mainMenu.open()
            onClicked: menuBo.show()
        }
    }

    orientationLock: PageOrientation.LockPortrait
    Component.onCompleted: {
        // Load previous game settings
        var db = openDatabaseSync("MagicLifeCounter", "1.0", "Life counter for Magic: The Gathering players ;)", 1000000);
        db.transaction(
            function(tx) {
                var rs = tx.executeSql('SELECT setting, value FROM settings WHERE setting IN (?, ?);', ['background', 'life']);
                for (var i = 0; i < rs.rows.length; i++) {
                    switch (rs.rows.item(i).setting) {
                    case 'background':
                        setBackground(parseInt(rs.rows.item(i).value));
                        //setBackground(rs.rows.item(i).value);
                        break;
                    case 'life':
                        //life = parseInt(rs.rows.item(i).value);
                        life = rs.rows.item(i).value;
                        break
                    }
                }
                rs = tx.executeSql('SELECT name, count FROM counters;');
                for (var i = 0; i < rs.rows.length; i++) {
                    counterModel.append({"counterName": rs.rows.item(i).name, "counterCount": rs.rows.item(i).count});
                }
            }
        );
    }
}
