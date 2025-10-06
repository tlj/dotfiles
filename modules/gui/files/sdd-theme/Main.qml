import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    width: 600
    height: 400
    color: "#282828" // Gruvbox dark background

    Rectangle {
        anchors.centerIn: parent
        width: 320
        height: 200
        color: "transparent"

        Column {
            anchors.centerIn: parent
            spacing: 24

            Text {
                text: "Welcome, Thomas"
                color: "#ebdbb2" // Gruvbox light text
                font.pixelSize: 28
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

            TextField {
                id: passwordInput
                width: 280
                height: 44
                anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Password"
                echoMode: TextInput.Password
                color: "#ebdbb2"
                font.pixelSize: 18
                padding: 10
                focus: true
                onAccepted: {
                    sddm.login("thomas", passwordInput.text, 0)
                }
                background: Rectangle {
                    color: "#3c3836" // Gruvbox dark gray
                    radius: 6
                }
            }

            Item { height: 8 }
        }
    }

    Button {
        id: powerButton
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        width: 48
        height: 48
        background: Rectangle {
            color: "#cc241d" // Gruvbox red
            radius: 24
        }
        contentItem: Text {
            text: "\u23FB"
            color: "#ebdbb2"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        onClicked: sddm.powerOff()
    }
}

