import QtQuick 2.15
import QtQuick.Controls 2.3
import QtQuick.Window 2.3
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: window
    color: "transparent"
    flags: Qt.FramelessWindowHint
    visible: true
    minimumWidth: 500
    height: 250
    property string currTime: "00:00:00"
    property QtObject backend

    function toggleMaximized() {
        if (window.visibility === Window.Maximized) {
            window.showNormal();
        } else {
            window.showMaximized();
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor
        DragHandler {
            id: resizeHandler
            onActiveChanged: if (active) {
                const p = resizeHandler.centroid.position;
                let e = 0;
                if (p.x / width < 0.10) { e |= Qt.LeftEdge }
                if (p.x / width > 0.90) { e |= Qt.RightEdge }
                if (p.y / height < 0.10) { e |= Qt.TopEdge }
                if (p.y / height > 0.90) { e |= Qt.BottomEdge }
                console.log("RESIZING", e);
                window.startSystemResize(e);
            }
        }
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
                TapHandler {
                    onTapped: if (tapCount === 2) toggleMaximized()
                    gesturePolicy: TapHandler.DragThreshold
                }
                DragHandler {
                    grabPermissions: TapHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { window.startSystemMove(); }
                }
                RowLayout {
                    anchors.centerIn: parent
                    Image {
                        source: "images/peace.svg"
                        width: 24
                        height: 24
                        sourceSize.width: 24
                        sourceSize.height: 24
                    }
                    Label {
                        text: "QML Practice"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                RowLayout {
                    anchors.right: parent.right
                    spacing: 0
                    Button {
                        id: minimizeBtn
                        text: "🗕"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.showMinimized();

                        background: Rectangle {
                            opacity: enabled ? 0.8 : 0.3
                            color: minimizeBtn.down ? "#f5f5f5" : (minimizeBtn.hovered ? "#fefefe": "transparent")
                        }
                    }
                    Button {
                        id: maximizeBtn
                        text: window.visibility == Window.Maximized ? "🗗" : "🗖"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.toggleMaximized()

                        background: Rectangle {
                            opacity: enabled ? 0.8 : 0.3
                            color: maximizeBtn.down ? "#f5f5f5" : (maximizeBtn.hovered ? "#fefefe": "transparent")
                        }
                    }
                    Button {
                        id: closeBtn
                        text: "🗙"
                        font.pixelSize: Qt.application.font.pixelSize * 1.4
                        background: Rectangle {
                            anchors.fill: parent
                            opacity: enabled ? 0.8 : 0.3
                            color: closeBtn.down ? "#f5f5f5" : (closeBtn.hovered ? "#fefefe": "transparent")
                        }
                        onClicked: window.close()
                    }
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            gradient: "RainyAshville"
            Rectangle {
                id: menuBar
                anchors.top: parent.top
                width: parent.width
                height: 30
                gradient: "MalibuBeach"
                RowLayout {
                    anchors.left: parent.left
                    spacing: 0
                    height: parent.height
                    Button {
                        id: menuButton
                        text: "File"
                        contentItem: Label {
                            text: parent.text
                            color: parent.down ? "black" : "white"
                        }
                        background: Rectangle {
                            color: "transparent"
                        }
                        onClicked: menu.open()

                        Menu {
                            id: menu
                            y: menuBar.height - 3

                            background: Rectangle {
                                implicitWidth: menuButton.width * 3
                                gradient: "FrozenDreams"
                            }
                            Action {
                                id: newAction
                                text: "New"
                                shortcut: StandardKey.New
                                onTriggered: {
                                    var component = Qt.createComponent("main.qml")
                                    var window = component.createObject("window")
                                    window.show()
                                }
                            }
                            Action {
                                text: "Settings"
                                onTriggered: {
                                    var component = Qt.createComponent("settings.qml")
                                    var settings = component.createObject("settingsWindow")
                                    settings.show()
                                }
                            }
                            MenuSeparator { }
                            Action {
                                text: "Exit"
                                onTriggered: window.close()
                            }
                        }
                    }
                }
            }
            Text {
                anchors.centerIn: parent
                text: currTime
                font.pixelSize: 60
                color: "white"

                layer.enabled: true
                layer.effect: DropShadow {
                    verticalOffset: 0
                    color: "skyblue"
                    radius: 9
                    samples: 19
                }
            }
        }

        Connections {
            target: backend

            function onUpdated(msg) {
                currTime = msg;
            }
        }

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: rect
        }
    }
}