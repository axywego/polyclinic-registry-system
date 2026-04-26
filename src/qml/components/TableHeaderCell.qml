import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    
    property string text: ""
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: "transparent"
    
    Label {
        anchors.fill: parent
        text: root.text
        font.bold: true
        font.pixelSize: 12
        color: "#666666"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        leftPadding: 5
    }
}