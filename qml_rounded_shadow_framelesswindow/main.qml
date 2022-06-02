import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.12

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
        gradient: "RainyAshville"
        anchors.fill: parent
        anchors.margins: 10
        width: Math.round(parent.width / 1.5)
        height: Math.round(parent.height / 2)
        radius: 10

        Text {
            anchors.centerIn: parent
            text: "Hello world!"
        }
    }
}