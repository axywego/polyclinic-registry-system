import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Button {
    id: root
    property string title: ""
    property bool isActive: false
    property string activeColor: '#008cdd'
    property string hoveredColor: '#007cc3'
    property string inactiveColor: '#0069a6'
    property string pressedColor: '#02659f'
    property string textColor: "#fff"
    
    signal itemClicked(int index, string title)

    text: title

    Layout.fillWidth: true
    Layout.preferredHeight: 50

    background: Rectangle {
        color: {
            if(root.isActive) return root.activeColor
            if(root.pressed) return root.pressedColor
            if(root.hovered) return root.hoveredColor
            return root.inactiveColor
        }

        border.width: 1
        border.color: "#000"

        Behavior on color {
            ColorAnimation {
                duration: 50
            }
        }
    }

    contentItem: Text {
        text: root.text
        color: root.textColor
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    onClicked: {
        itemClicked(index, title)
    }
}