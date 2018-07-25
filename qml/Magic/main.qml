// http://www.developer.nokia.com/Resources/Library/Design_and_UX/designing-for-nokia-phones/designing-for-series-40/series-40-iconography-guidelines/launcher-icon-templates/inkscape-launcher-icon-template-1.html

import QtQuick 1.1
import com.nokia.symbian 1.1

PageStackWindow {
    id: window
    initialPage: MainPage{}
    showStatusBar: false
    showToolBar: true

    StatusBar {
        id: sbar
        anchors.left: parent.left; anchors.right: parent.right
        anchors.top: parent.top

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.verticalCenter: parent.verticalCenter
            width: sbar.width - 140
            height: parent.height
            clip: true
            color: '#00000000'

            Text {
                id: statusPaneTitle
                anchors.verticalCenter: parent.verticalCenter
                maximumLineCount: 1
                x: 0
                font.pixelSize: 20
                color: "white"
                text: qsTr("Magic Lifecounter")
            }

            Rectangle {
                width: 25
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                rotation: -90
                gradient: Gradient {
                    GradientStop {
                        position: 0.0; color: '#00000000'
                    }
                    GradientStop {
                        position: 1.0; color: '#ff000000'
                    }
                }
            }
        }
    }

    ToolBarLayout {
        ToolButton {
            flat: true
            iconSource: "toolbar-back"
            onClicked: window.pageStack.depth <= 1 ? Qt.quit() : window.pageStack.pop()
        }
    }
}
