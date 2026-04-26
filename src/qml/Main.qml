import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0

Window {
    id: window
    visible: true
    title: "Поликлиника - Система управления регистратурой"
    
    property bool isFullscreen: false
    property bool isMaximized: false
    
    minimumWidth: 800
    minimumHeight: 600
    
    color: "#F5F7FA"

    StackView {
        id: stackView
        anchors.fill: parent
        
        // ============================================
        // PUSH: новый экран появляется
        // ============================================
        pushEnter: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
        
        // ============================================
        // PUSH: старый экран уходит
        // ============================================
        pushExit: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                    easing.type: Easing.InCubic
                }
            }
        }
        
        // ============================================
        // POP: возвращается предыдущий экран
        // ============================================
        popEnter: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
        
        // ============================================
        // POP: текущий экран уходит
        // ============================================
        popExit: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                    easing.type: Easing.InCubic
                }
            }
        }
        
        // ============================================
        // REPLACE: замена экрана
        // ============================================
        replaceEnter: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }
        }
        
        replaceExit: Transition {
            ParallelAnimation {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 200
                    easing.type: Easing.InCubic
                }
            }
        }

        initialItem: "screens/MainMenuScreen.qml"

        onCurrentItemChanged: {
            if (currentItem) {
                var objectName = currentItem.objectName
                
                if (objectName === "menuScreen" || objectName === "polyclinicSelection") {
                    setWindowedMode()
                } 
                else if (objectName === "mainScreen") {
                    setMaximizedMode()
                }
            }
        }
    }
    
    // Горячие клавиши
    Shortcut {
        sequence: "F11"
        onActivated: toggleFullscreen()
    }
    
    Shortcut {
        sequence: "Esc"
        onActivated: {
            if (window.isFullscreen) {
                exitFullscreen()
            }
        }
    }
    
    Shortcut {
        sequence: "Alt+Enter"
        onActivated: toggleFullscreen()
    }
    
    Shortcut {
        sequence: "Backspace"
        onActivated: {
            if (stackView.depth > 1) {
                stackView.pop()
            }
        }
    }
    
    function setWindowedMode() {
        window.visibility = Window.Windowed
        window.width = 950
        window.height = 680
        window.x = (Screen.width - window.width) / 2
        window.y = (Screen.height - window.height) / 2
        window.isFullscreen = false
        window.isMaximized = false
    }
    
    function setMaximizedMode() {
        window.visibility = Window.Maximized
        window.isMaximized = true
        window.isFullscreen = false
    }
    
    function toggleFullscreen() {
        if (window.visibility === Window.FullScreen) {
            if (stackView.currentItem && stackView.currentItem.objectName === "mainScreen") {
                window.visibility = Window.Maximized
                window.isMaximized = true
            } else {
                setWindowedMode()
            }
            window.isFullscreen = false
        } else {
            window.visibility = Window.FullScreen
            window.isFullscreen = true
            window.isMaximized = false
        }
    }
    
    function exitFullscreen() {
        if (stackView.currentItem && stackView.currentItem.objectName === "mainScreen") {
            window.visibility = Window.Maximized
            window.isMaximized = true
        } else {
            setWindowedMode()
        }
        window.isFullscreen = false
    }
}