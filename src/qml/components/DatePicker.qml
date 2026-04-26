import QtQuick
import QtQuick.Controls

TextField {
    id: root
    
    property string placeholder: "ДД.ММ.ГГГГ"
    
    placeholderText: root.placeholder
    
    MouseArea {
        anchors.fill: parent
        onClicked: {
            // TODO: Открыть календарь
            console.log("Open date picker")
        }
    }
}