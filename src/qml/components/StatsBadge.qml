import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    
    property string label: ""
    property string value: ""
    property color badgeColor: "#2196F3"
    
    Layout.preferredWidth: 120
    height: 60
    radius: 8
    color: root.badgeColor
    opacity: 0.1
    border.color: root.badgeColor
    border.width: 1
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2
        
        Text {
            text: root.value
            font.pixelSize: 20
            font.bold: true
            color: root.badgeColor
            Layout.alignment: Qt.AlignHCenter
        }
        
        Text {
            text: root.label
            font.pixelSize: 11
            color: "#666666"
            Layout.alignment: Qt.AlignHCenter
        }
    }
}