import QtQuick 6.0
import QtQuick.Controls 6.0

ApplicationWindow {
    visible: true
    width: 360
    height: 740
    title: "ABINSTEIN OS - Launcher"
    background: Rectangle { color: "#121212" } // Fundal negru AMOLED elegant

    Column {
        anchors.centerIn: parent
        spacing: 40
        width: parent.width * 0.8

        // Ceasul digital din partea de sus a ecranului
        Label {
            text: "12:00"
            font.pixelSize: 64
            font.bold: true
            color: "#ffffff"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Numele sistemului tău de operare
        Label {
            text: "ABINSTEIN OS"
            font.pixelSize: 18
            font.letterSpacing: 2
            color: "#888888"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Grila cu aplicațiile telefonului
        Grid {
            columns: 2
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter

            // Butonul pentru Cameră
            Button {
                text: "📷 Camera"
                contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter }
                background: Rectangle { implicitWidth: 120; implicitHeight: 60; color: "#1f1f1f"; radius: 15 }
            }

            // Butonul pentru Setări
            Button {
                text: "⚙️ Settings"
                contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter }
                background: Rectangle { implicitWidth: 120; implicitHeight: 60; color: "#1f1f1f"; radius: 15 }
            }

            // Butonul pentru Galerie
            Button {
                text: "🖼️ Gallery"
                contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 16; horizontalAlignment: Text.AlignHCenter }
                background: Rectangle { implicitWidth: 120; implicitHeight: 60; color: "#1f1f1f"; radius: 15 }
            }

            // Butonul special pentru Simulatorul Cuantic creat de tine
            Button {
                text: "⚛️ Quantum"
                contentItem: Text { text: parent.text; color: "#00ffcc"; font.pixelSize: 16; font.bold: true; horizontalAlignment: Text.AlignHCenter }
                background: Rectangle { implicitWidth: 120; implicitHeight: 60; color: "#0d2b26"; radius: 15; border.color: "#00ffcc" }
            }
        }
    }
}
