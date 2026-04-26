import QtQuick
import QtQuick.Controls

Button {
    id: root
    
    property string iconText: "📝"
    property color buttonColor: "#1976D2"
    
    implicitHeight: 56
    
    background: Rectangle {
        radius: 10
        color: root.down ? Qt.darker(root.buttonColor, 1.1) : 
               (root.hovered ? Qt.lighter(root.buttonColor, 1.05) : root.buttonColor)
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    contentItem: Item {
        implicitWidth: rowLayout.implicitWidth
        implicitHeight: rowLayout.implicitHeight
        
        Row {
            id: rowLayout
            spacing: 10
            anchors.centerIn: parent
            
            Text {
                text: root.iconText
                font.pixelSize: 20
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: root.text
                font.pixelSize: 13
                font.bold: true
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}