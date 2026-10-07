import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 720
    height: 1520
    visible: true
    color: "#0f172a"
    title: "Settings"

    Rectangle {
        anchors.fill: parent
        color: "#0f172a"

        Text {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 32
            text: "Settings"
            color: "#f8fafc"
            font.pixelSize: 36
            font.bold: true
        }

        Column {
            anchors.centerIn: parent
            width: parent.width - 64
            spacing: 18

            Rectangle {
                width: parent.width
                height: 90
                radius: 18
                color: "#111827"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Wi-Fi"
                    color: "#e2e8f0"
                    font.pixelSize: 24
                }
            }

            Rectangle {
                width: parent.width
                height: 90
                radius: 18
                color: "#111827"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Display"
                    color: "#e2e8f0"
                    font.pixelSize: 24
                }
            }

            Rectangle {
                width: parent.width
                height: 90
                radius: 18
                color: "#111827"

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Power"
                    color: "#e2e8f0"
                    font.pixelSize: 24
                }
            }
        }
    }
}
