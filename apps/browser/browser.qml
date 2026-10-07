import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    width: 720
    height: 1520
    visible: true
    color: "#0f172a"
    title: "Browser"

    Rectangle {
        anchors.fill: parent
        color: "#0f172a"

        Rectangle {
            id: urlBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            height: 56
            radius: 18
            color: "#1e293b"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                text: "https://abinstein.local"
                color: "#e2e8f0"
                font.pixelSize: 22
            }
        }

        Rectangle {
            anchors.top: urlBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 20
            radius: 24
            color: "#111827"

            Text {
                anchors.centerIn: parent
                text: "Browser placeholder"
                color: "#f8fafc"
                font.pixelSize: 28
            }
        }
    }
}
