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

    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
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
                    ToolButton {
                        text: "🗕"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.showMinimized();
                        /*
                        background: Rectangle {
                            color: "transparent"
                            MouseArea {
                                hoverEnabled: true
                                onEntered: {
                                    ColorAnimation on color {
                                        to: "red"
                                        duration: 1000
                                    }
                                }
                            }
                        }
                        */
                    }
                    ToolButton {
                        text: window.visibility == Window.Maximized ? "🗗" : "🗖"
                        font.pixelSize: Qt.application.font.pixelSize * 1.6
                        onClicked: window.toggleMaximized()
                    }
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
                            MenuItem {
                                id: newMenuItem
                                text: "&New"
                                Loader { id: newPageLoader }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: newPageLoader.source = "main.qml"
                                }
                            }
                            MenuItem {
                                text: "Settings"
                            }
                            MenuSeparator { }
                            MenuItem {
                                text: "Exit"
                                onClicked: window.close()
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