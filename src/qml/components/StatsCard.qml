import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    
    property string iconText: "📋"
    property color iconColor: "#1976D2"
    property string title: ""
    property var value: 0
    property string subtitle: ""
    
    color: "#FFFFFF"
    radius: 12
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        
        Rectangle {
            width: 52
            height: 52
            radius: 12
            color: root.iconColor
            opacity: 0.12
            
            Text {
                anchors.centerIn: parent
                text: root.iconText
                font.pixelSize: 26
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Text {
                text: root.title
                font.pixelSize: 13
                color: "#7F8C8D"
            }
            
            Text {
                text: root.value
                font.pixelSize: 28
                font.bold: true
                color: "#2C3E50"
            }
            
            Text {
                text: root.subtitle
                font.pixelSize: 12
                color: root.iconColor
                visible: root.subtitle !== ""
            }
        }
    }
}