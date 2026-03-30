import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property string title: ""
    property string colorTitle: "#000"
    property string colorBackground: "#fff"

    Layout.fillWidth: true
    Layout.preferredHeight: 60

    color: colorBackground

    Text {
        anchors.fill: parent
        anchors.leftMargin: 20

        text: root.title
        color: root.colorTitle

        font.pixelSize: 22

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}