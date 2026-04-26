// import QtQuick
// import QtQuick.Window
// import QtQuick.Controls
// import QtQuick.Layouts
// import Polyclinic.Services 1.0
// import Polyclinic.UI 1.0

// Rectangle {
//     id: root

//     objectName: "mainScreen"

//     property int idPolyclinic: 0
//     property string namePolyclinic: ""

//     color: "#F5F7FA"

//     property var polyclinicNameCache: ({})

//     function getPolyclinicName(id) {
//         if (id <= 0) {
//             return ""
//         }

//         if (polyclinicNameCache[id] !== undefined) {
//             return polyclinicNameCache[id]
//         }

//         try {
//             const polyclinics = PolyclinicService.search([
//                 {"field": "id", "operator": "eq", "value": id}
//             ])
            
//             if (polyclinics.length > 0) {
//                 const name = polyclinics[0].name || ""
//                 polyclinicNameCache[id] = name
//                 return name
//             }
//         } 
//         catch (error) {
//             console.error("Ошибка получения названия поликлиники:", error)
//         }
//         return "Поликлиника не найдена"
//     }

//     onIdPolyclinicChanged: {
//         namePolyclinic = getPolyclinicName(idPolyclinic)
//     }

//     Component.onCompleted: {
//         if (idPolyclinic > 0) {
//             namePolyclinic = getPolyclinicName(idPolyclinic)
//         }
//     }

//     RowLayout {
//         anchors.fill: parent
//         spacing: 0

//         // Боковое меню
//         Sidebar {
//             id: sidebar
//             Layout.fillHeight: true
//             Layout.preferredWidth: 280
//         }

//         // Основной контент
//         ColumnLayout {
//             Layout.fillWidth: true
//             Layout.fillHeight: true
//             spacing: 0

//             // Верхняя панель
//             Rectangle {
//                 Layout.fillWidth: true
//                 Layout.preferredHeight: 70
//                 color: "#FFFFFF"
                
//                 // Граница снизу
//                 Rectangle {
//                     anchors.left: parent.left
//                     anchors.right: parent.right
//                     anchors.bottom: parent.bottom
//                     height: 1
//                     color: "#E0E6ED"
//                 }
                
//                 RowLayout {
//                     anchors.fill: parent
//                     anchors.leftMargin: 25
//                     anchors.rightMargin: 25
                    
//                     // Название поликлиники
//                     RowLayout {
//                         spacing: 12
                        
//                         Rectangle {
//                             width: 40
//                             height: 40
//                             radius: 10
//                             color: "#1976D2"
                            
//                             Text {
//                                 anchors.centerIn: parent
//                                 text: "🏥"
//                                 font.pixelSize: 22
//                             }
//                         }
                        
//                         ColumnLayout {
//                             spacing: 2
                            
//                             Text {
//                                 text: namePolyclinic || "Загрузка..."
//                                 font.pixelSize: 18
//                                 font.bold: true
//                                 color: "#2C3E50"
//                             }
                            
//                             Text {
//                                 text: "Панель управления регистратора"
//                                 font.pixelSize: 12
//                                 color: "#7F8C8D"
//                             }
//                         }
//                     }
                    
//                     Item { Layout.fillWidth: true }
                    
//                     // Текущее время
//                     Rectangle {
//                         width: timeText.implicitWidth + 40
//                         height: 36
//                         radius: 18
//                         color: "#F5F7FA"
                        
//                         Text {
//                             id: timeText
//                             anchors.centerIn: parent
//                             text: Qt.formatDateTime(new Date(), "dd.MM.yyyy  |  hh:mm")
//                             font.pixelSize: 13
//                             color: "#2C3E50"
//                         }
                        
//                         Timer {
//                             interval: 1000
//                             running: true
//                             repeat: true
//                             onTriggered: timeText.text = Qt.formatDateTime(new Date(), "dd.MM.yyyy  |  hh:mm")
//                         }
//                     }
//                 }
//             }

//             // Контент страниц
//             StackLayout {
//                 Layout.fillWidth: true
//                 Layout.fillHeight: true
//                 currentIndex: sidebar.currentIndex

//                 DashboardView {
//                     idPolyclinic: root.idPolyclinic

//                     onSwitchToPage: (index) => {
//                         sidebar.currentIndex = index
//                     }
//                 }

//                 AppointmentView {
//                     id: appointmentView
//                     property var pendingPatient: null

//                     idPolyclinic: root.idPolyclinic

//                     onPendingPatientChanged: {
//                         if (pendingPatient) {
//                             selectPatient(pendingPatient)
//                             pendingPatient = null
//                         }
//                     }
//                 }

//                 AppointmentsJournalView {
//                     idPolyclinic: root.idPolyclinic
//                 }
                
//                 CardIndexView {
//                     idPolyclinic: root.idPolyclinic
                    
//                     onSwitchToPageWithPatient: (index, patient) => {
//                         console.log("🔔 Получен сигнал:", index, patient?.full_name)
                        
//                         if (index === 1) {
//                             // Запись к врачу
//                             appointmentView.pendingPatient = patient
//                             sidebar.currentIndex = 1
//                         } else if (index === 4) {
//                             // Больничный - открываем DocumentsView на вкладке больничных
//                             documentsView.pendingPatientData = { patient: patient, tabIndex: 1 }
//                             sidebar.currentIndex = 4  // индекс DocumentsView
//                         } else if (index === 5) {
//                             // СПРАВКА - открываем DocumentsView на вкладке справок
//                             documentsView.pendingPatientData = { patient: patient, tabIndex: 0 }
//                             sidebar.currentIndex = 4  // индекс DocumentsView
//                         }
                        
//                         // Переключаем страницу
//                         // sidebar.currentIndex = index
//                     }
//                 }
                                
//                 // SickLeavesView {
//                 //     id: sickLeavesView
//                 //     property var pendingPatient: null
//                 //     property int pendingTab: 1
                    
//                 //     idPolyclinic: root.idPolyclinic
                    
//                 //     onPendingPatientChanged: {
//                 //         if (pendingPatient) {
//                 //             selectedPatientForSickLeave = pendingPatient
//                 //             slPatientName.text = pendingPatient.full_name || "—"
//                 //             tabBar.currentIndex = 1
//                 //             pendingPatient = null
//                 //         }
//                 //     }
//                 // }
//                 DocumentsView {
//                     id: documentsView
//                     idPolyclinic: root.idPolyclinic
//                 }
//             }
//         }
//     }
// }

import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0
import Polyclinic.UI 1.0

Rectangle {
    id: root

    objectName: "mainScreen"

    property int idPolyclinic: 0
    property string namePolyclinic: ""
    property string userRole: "registrar"  // ДОБАВИТЬ: роль пользователя
    property string userName: ""           // ДОБАВИТЬ: имя пользователя

    color: "#F5F7FA"

    property var polyclinicNameCache: ({})

    function getPolyclinicName(id) {
        if (id <= 0) {
            return ""
        }

        if (polyclinicNameCache[id] !== undefined) {
            return polyclinicNameCache[id]
        }

        try {
            const polyclinics = PolyclinicService.search([
                {"field": "id", "operator": "eq", "value": id}
            ])
            
            if (polyclinics.length > 0) {
                const name = polyclinics[0].name || ""
                polyclinicNameCache[id] = name
                return name
            }
        } 
        catch (error) {
            console.error("Ошибка получения названия поликлиники:", error)
        }
        return "Поликлиника не найдена"
    }

    onIdPolyclinicChanged: {
        namePolyclinic = getPolyclinicName(idPolyclinic)
    }

    Component.onCompleted: {
        if (idPolyclinic > 0) {
            namePolyclinic = getPolyclinicName(idPolyclinic)
        }
        // Изменяем заголовок в зависимости от роли
        if (userRole === "admin") {
            headerText.text = "Панель управления администратора"
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Боковое меню
        Sidebar {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 280
            userRole: root.userRole      // ПЕРЕДАЁМ РОЛЬ
            userName: root.userName      // ПЕРЕДАЁМ ИМЯ
        }

        // Основной контент
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Верхняя панель
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: "#FFFFFF"
                
                // Граница снизу
                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: "#E0E6ED"
                }
                
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 25
                    anchors.rightMargin: 25
                    
                    // Название поликлиники
                    RowLayout {
                        spacing: 12
                        
                        Rectangle {
                            width: 40
                            height: 40
                            radius: 10
                            color: userRole === "admin" ? "#9C27B0" : "#1976D2"  // Фиолетовый для админа
                            
                            Text {
                                anchors.centerIn: parent
                                text: userRole === "admin" ? "👑" : "🏥"
                                font.pixelSize: 22
                            }
                        }
                        
                        ColumnLayout {
                            spacing: 2
                            
                            Text {
                                text: namePolyclinic || "Загрузка..."
                                font.pixelSize: 18
                                font.bold: true
                                color: "#2C3E50"
                            }
                            
                            Text {
                                id: headerText
                                text: userRole === "admin" ? "Панель управления администратора" : "Панель управления регистратора"
                                font.pixelSize: 12
                                color: userRole === "admin" ? "#9C27B0" : "#7F8C8D"
                            }
                        }
                    }
                    
                    Item { Layout.fillWidth: true }
                    
                    // Имя пользователя и роль
                    RowLayout {
                        spacing: 12
                        
                        Rectangle {
                            height: 36
                            width: roleText.implicitWidth + 24
                            radius: 18
                            color: userRole === "admin" ? "#F3E5F5" : "#E3F2FD"
                            
                            Text {
                                id: roleText
                                anchors.centerIn: parent
                                text: userRole === "admin" ? "👑 Администратор" : "📋 Регистратор"
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                color: userRole === "admin" ? "#9C27B0" : "#1976D2"
                            }
                        }
                        
                        Text {
                            text: userName || "Пользователь"
                            font.pixelSize: 13
                            color: "#2C3E50"
                        }
                    }
                    
                    Item { Layout.preferredWidth: 20 }
                    
                    // Текущее время
                    Rectangle {
                        width: timeText.implicitWidth + 40
                        height: 36
                        radius: 18
                        color: "#F5F7FA"
                        
                        Text {
                            id: timeText
                            anchors.centerIn: parent
                            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy  |  hh:mm")
                            font.pixelSize: 13
                            color: "#2C3E50"
                        }
                        
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: timeText.text = Qt.formatDateTime(new Date(), "dd.MM.yyyy  |  hh:mm")
                        }
                    }
                }
            }

            // Контент страниц
            StackLayout {
                id: mainStack
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: sidebar.currentIndex

                DashboardView {
                    idPolyclinic: root.idPolyclinic

                    onSwitchToPage: (index) => {
                        sidebar.currentIndex = index
                    }
                }

                AppointmentView {
                    id: appointmentView
                    property var pendingPatient: null

                    idPolyclinic: root.idPolyclinic

                    onPendingPatientChanged: {
                        if (pendingPatient) {
                            selectPatient(pendingPatient)
                            pendingPatient = null
                        }
                    }
                }

                AppointmentsJournalView {
                    idPolyclinic: root.idPolyclinic
                }
                
                CardIndexView {
                    idPolyclinic: root.idPolyclinic
                    
                    onSwitchToPageWithPatient: (index, patient) => {
                        console.log("🔔 Получен сигнал:", index, patient?.full_name)
                        
                        if (index === 1) {
                            appointmentView.pendingPatient = patient
                            sidebar.currentIndex = 1
                        } else if (index === 4) {
                            documentsView.pendingPatientData = { patient: patient, tabIndex: 1 }
                            sidebar.currentIndex = 4
                        } else if (index === 5) {
                            documentsView.pendingPatientData = { patient: patient, tabIndex: 0 }
                            sidebar.currentIndex = 4
                        }
                    }
                }
                
                DocumentsView {
                    id: documentsView
                    idPolyclinic: root.idPolyclinic
                }
                
                // ДОБАВИТЬ: Админ панель (только для админа)
                AdminView {
                    visible: root.userRole === "admin"
                    idPolyclinic: root.idPolyclinic
                }
            }
        }
    }
}