import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    width: 720
    height: 1520
    visible: true
    title: "ABINSTEIN Shell"
    color: "#0f172a"

    Rectangle {
        anchors.fill: parent
        color: "#0f172a"

        Rectangle {
            id: statusBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 80
            color: "#111827"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                text: "09:41"
                color: "#e2e8f0"
                font.pixelSize: 28
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 24
                anchors.verticalCenter: parent.verticalCenter
                text: "5G • 87%"
                color: "#cbd5e1"
                font.pixelSize: 24
            }
        }

        Rectangle {
            id: contentCard
            anchors.top: statusBar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 24
            radius: 28
            color: "#111827"

            Text {
                id: titleText
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 28
                text: "ABINSTEIN OS"
                color: "#f8fafc"
                font.pixelSize: 38
                font.bold: true
            }

            Text {
                anchors.top: titleText.bottom
                anchors.left: parent.left
                anchors.margins: 28
                text: "System ready"
                color: "#94a3b8"
                font.pixelSize: 22
            }

            Column {
                anchors.centerIn: parent
                spacing: 18

                Rectangle {
                    width: 220
                    height: 220
                    radius: 110
                    color: "#2563eb"
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "A"
                        color: "#ffffff"
                        font.pixelSize: 64
                        font.bold: true
                    }
                }

                Text {
                    text: "Mobile shell"
                    color: "#f8fafc"
                    font.pixelSize: 28
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
