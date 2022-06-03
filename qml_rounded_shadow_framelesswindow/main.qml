import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.3

Window {
    id: window
    color: "transparent"
    flags: Qt.FramelessWindowHint
    visible: true
    width: 300
    height: 250

    DragHandler {
        onActiveChanged: if (active) { window.startSystemMove(); }
    }

    RectangularGlow {
        id: effect
        anchors.fill: rect
        glowRadius: 5
        spread: 0.2
        color: "gray"
        cornerRadius: rect.radius + glowRadius
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        anchors.margins: 10
        width: Math.round(parent.width / 1.5)
        height: Math.round(parent.height / 2)
        radius: 10

    }

    Page {
        anchors.fill: rect
        header: ToolBar {
            id: header
            background: Rectangle {
                gradient: "NightFade"
                implicitWidth: 100
                implicitHeight: 40
                opacity: enabled ? 1 : 0.3
            }
            Item {
                anchors.fill: parent
                RowLayout {
                    anchors.right: parent.right
                    spacing: 3
                    ToolButton {
                        text: qsTr("🗙")
                        font.pixelSize: Qt.application.font.pixelSize * 1.4
                        contentItem: Text {
                            text: parent.text
                            font: parent.font
                            opacity: enabled ? 1.0 : 0.3
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        onClicked: window.close()
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: "RainyAshville"
            Text {
                anchors.centerIn: parent
                text: "Hello world!"
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: rect
        }
    }
}