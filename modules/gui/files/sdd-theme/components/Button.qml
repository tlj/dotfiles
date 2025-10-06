import QtQuick 2.0
import QtQuick.Controls 2.0

Button {
    font.pixelSize: 18
    padding: 10

    contentItem: Text {
        text: control.text
        font.pixelSize: 18
        color: "#282828" // Gruvbox background for text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}

