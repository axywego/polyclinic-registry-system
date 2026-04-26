// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import Polyclinic.UI 1.0

// Rectangle {
//     id: root
    
//     color: "#FFFFFF"
//     width: 260
    
//     property int currentIndex: 0
    
//     Rectangle {
//         anchors.top: parent.top
//         anchors.bottom: parent.bottom
//         anchors.right: parent.right
//         width: 1
//         color: "#E0E6ED"
//     }

//     ColumnLayout {
//         anchors.fill: parent
//         spacing: 0
        
//         Item {
//             Layout.fillWidth: true
//             Layout.preferredHeight: 20
//         }

//         // Меню - используем Item как контейнер
//         Item {
//             Layout.fillWidth: true
//             Layout.preferredHeight: menuColumn.height
            
//             Column {
//                 id: menuColumn
//                 width: parent.width
//                 spacing: 6
                
//                 Repeater {
//                     model: [
//                         { title: "Панель управления", icon: "📊" },
//                         { title: "Запись на прием", icon: "📝" },
//                         { title: "Журнал записей", icon: "📋" },
//                         { title: "Картотека", icon: "📇" },
//                         { title: "Документы", icon: "📄" },
//                     ]

//                     delegate: SidebarButton {
//                         width: parent.width - 24  // Учитываем отступы
//                         anchors.horizontalCenter: parent.horizontalCenter
//                         title: modelData.title
//                         iconText: modelData.icon
//                         isActive: root.currentIndex === index

//                         onItemClicked: (title) => {
//                             root.currentIndex = index
//                         }
//                     }
//                 }
//             }
//         }
        
//         Item {
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//         }
        
//         // Кнопка выхода
//         Item {
//             Layout.fillWidth: true
//             Layout.preferredHeight: logoutButton.height + 20
//             Layout.bottomMargin: 0
            
//             SidebarButton {
//                 id: logoutButton
//                 width: parent.width - 24  // Учитываем отступы
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 anchors.bottom: parent.bottom
//                 anchors.bottomMargin: 20
//                 title: "Выйти из системы"
//                 iconText: "🚪"
//                 isActive: false
//                 activeColor: "#F44336"
//                 hoveredColor: "#D32F2F"
//                 inactiveColor: "transparent"
//                 pressedColor: "#B71C1C"
//                 textColor: "#F44336"
                
//                 onItemClicked: (title) => {
//                     stackView.pop()
//                 }
//             }
//         }
//     }
// }
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.UI 1.0

Rectangle {
    id: root
    
    color: "#FFFFFF"
    width: 260
    
    property int currentIndex: 0
    property string userRole: "registrar"  // admin или registrar
    property string userName: ""           // имя пользователя
    
    Rectangle {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 1
        color: "#E0E6ED"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 20
        }
        // Меню - используем Item как контейнер
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: menuColumn.height
            
            Column {
                id: menuColumn
                width: parent.width
                spacing: 6
                
                // Панель управления
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Панель управления"
                    iconText: "📊"
                    isActive: root.currentIndex === 0
                    visible: true
                    
                    // activeColor: "#1976D2"
                    // hoveredColor: "#1565C0"
                    // inactiveColor: "#E8F0FE"
                    // pressedColor: "#0D47A1"
                    textColor: root.currentIndex === 0 ? "#FFFFFF" : "#1976D2"

                    onItemClicked: {
                        root.currentIndex = 0
                    }
                }

                // Запись на прием
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Запись на прием"
                    iconText: "📝"
                    isActive: root.currentIndex === 1
                    visible: true
                    
                    // activeColor: "#1976D2"
                    // hoveredColor: "#1565C0"
                    // inactiveColor: "#E8F0FE"
                    // pressedColor: "#0D47A1"
                    textColor: root.currentIndex === 1 ? "#FFFFFF" : "#1976D2"

                    onItemClicked: {
                        root.currentIndex = 1
                    }
                }

                // Журнал записей
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Журнал записей"
                    iconText: "📋"
                    isActive: root.currentIndex === 2
                    visible: true
                    
                    // activeColor: "#1976D2"
                    // hoveredColor: "#1565C0"
                    // inactiveColor: "#E8F0FE"
                    // pressedColor: "#0D47A1"
                    textColor: root.currentIndex === 2 ? "#FFFFFF" : "#1976D2"

                    onItemClicked: {
                        root.currentIndex = 2
                    }
                }

                // Картотека
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Картотека"
                    iconText: "📇"
                    isActive: root.currentIndex === 3
                    visible: true
                    
                    // activeColor: "#1976D2"
                    // hoveredColor: "#1565C0"
                    // inactiveColor: "#E8F0FE"
                    // pressedColor: "#0D47A1"
                    textColor: root.currentIndex === 3 ? "#FFFFFF" : "#1976D2"

                    onItemClicked: {
                        root.currentIndex = 3
                    }
                }

                // Документы
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Документы"
                    iconText: "📄"
                    isActive: root.currentIndex === 4
                    visible: true
                    
                    // activeColor: "#1976D2"
                    // hoveredColor: "#1565C0"
                    // inactiveColor: "#E8F0FE"
                    // pressedColor: "#0D47A1"
                    textColor: root.currentIndex === 4 ? "#FFFFFF" : "#1976D2"

                    onItemClicked: {
                        root.currentIndex = 4
                    }
                }

                // Разделитель (только для админа)
                Rectangle {
                    width: parent.width - 40
                    height: 1
                    color: "#E0E6ED"
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: userRole === "admin"
                }

                // Администрирование (ТОЛЬКО для админа)
                SidebarButton {
                    width: parent.width - 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    title: "Администрирование"
                    iconText: "👑"
                    isActive: root.currentIndex === 5
                    visible: userRole === "admin"
                    
                    // activeColor: "#9C27B0"
                    // hoveredColor: "#7B1FA2"
                    // inactiveColor: "#F3E5F5"
                    // pressedColor: "#6A1B9A"
                    textColor: root.currentIndex === 5 ? "#FFFFFF" : "#9C27B0"

                    onItemClicked: {
                        root.currentIndex = 5
                    }
                }
            }
        }
        
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        
        // Кнопка выхода
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: logoutButton.height + 20
            Layout.bottomMargin: 0
            
            SidebarButton {
                id: logoutButton
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20
                title: "Выйти из системы"
                iconText: "🚪"
                isActive: false
                
                activeColor: "#F44336"
                hoveredColor: "#E53935"
                inactiveColor: "#FFEBEE"
                pressedColor: "#B71C1C"
                textColor: "#F44336"

                onItemClicked: {
                    stackView.pop()
                }
            }
        }
    }
}