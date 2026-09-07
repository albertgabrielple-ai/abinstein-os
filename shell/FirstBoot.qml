import QtQuick 6.0
import QtQuick.Controls 6.0

ApplicationWindow {
    visible: true
    width: 360
    height: 740
    title: "ABINSTEIN OS - First Boot Setup"
    background: Rectangle { color: "#000000" } // Ecran complet negru la prima pornire

    Column {
        anchors.centerIn: parent
        spacing: 30
        width: parent.width * 0.85

        Label {
            text: "Bun venit în"
            font.pixelSize: 24
            color: "#888888"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Label {
            text: "ABINSTEIN OS"
            font.pixelSize: 36
            font.bold: true
            color: "#00ffcc" // Culoare verde/azuriu cibernetic
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: parent.width
            height: 180
            color: "#111111"
            radius: 10
            border.color: "#222222"

            Column {
                anchors.centerIn: parent
                spacing: 10
                
                Text { text: "✓ Nucleu Linux Independent: ACTIV"; color: "#00ffcc"; font.pixelSize: 14 }
                Text { text: "✓ Sistem Auto-Reparare: PREGĂTIT"; color: "#00ffcc"; font.pixelSize: 14 }
                Text { text: "✓ Simulator Cuantic Core: ÎNCĂRCAT"; color: "#00ffcc"; font.pixelSize: 14 }
                Text { text: "✓ FĂRĂ dependențe Google sau Android"; color: "#ffffff"; font.pixelSize: 14; font.bold: true }
            }
        }

        Label {
            text: "Sistemul tău este securizat și pregătit."
            font.pixelSize: 14
            color: "#666666"
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
        }

        Button {
            text: "Pornește ABINSTEIN OS"
            anchors.horizontalCenter: parent.horizontalCenter
            contentItem: Text { text: parent.text; color: "black"; font.pixelSize: 16; font.bold: true; horizontalAlignment: Text.AlignHCenter }
            background: Rectangle { implicitWidth: 200; implicitHeight: 50; color: "#00ffcc"; radius: 25 }
        }
    }
}
