import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0

Window {
    id: window
    visible: true
    title: "Polyclinics"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: "screens/MainMenuScreen.qml"

        onCurrentItemChanged: {
            if (currentItem) {
                if (currentItem.objectName === "menuScreen" || currentItem.objectName === "polyclinicSelection") {
                    Window.window.width = 800;
                    Window.window.height = 600; 

                    Window.window.x = (Screen.width - Window.window.width) / 2;
                    Window.window.y = (Screen.height - Window.window.height) / 2;   

                } 
                else if (currentItem.objectName === "mainScreen") {
                    Window.window.width = Screen.width;
                    Window.window.height = Screen.height;   

                    Window.window.x = 0;
                    Window.window.y = 0;
                }
            }
        }
    }
}