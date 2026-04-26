import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import Utils
import Registrar.Services

Rectangle {
    objectName: "menuScreen"

    property bool isResettingPassword: false

    // Градиентный фон
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#1976D2" }
        GradientStop { position: 1.0; color: "#0D47A1" }
    }

    // Тень карточки
    Rectangle {
        width: 400
        height: 450
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 2
        anchors.verticalCenterOffset: 4
        radius: 16
        color: "#20000000"
    }

    // Центральная карточка входа
    Rectangle {
        width: 400
        height: 450
        anchors.centerIn: parent
        radius: 16
        color: "#FFFFFF"
        border.width: 1
        border.color: "#E0E6ED"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 40
            spacing: 20

            // Логотип / Заголовок
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 8
                
                Rectangle {
                    width: 70
                    height: 70
                    radius: 35
                    color: "#1976D2"
                    Layout.alignment: Qt.AlignHCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "🏥"
                        font.pixelSize: 35
                    }
                }
                
                Text {
                    text: "Поликлиника"
                    font.pixelSize: 26
                    font.bold: true
                    color: "#2C3E50"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Text {
                    text: "Система управления регистратурой"
                    font.pixelSize: 12
                    color: "#7F8C8D"
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            Item { Layout.preferredHeight: 10 }

            // Поле ввода логина
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                
                Text {
                    text: "Логин"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#2C3E50"
                    leftPadding: 4
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: "#F5F7FA"
                    border.color: loginInput.activeFocus ? "#1976D2" : "#E0E6ED"
                    border.width: loginInput.activeFocus ? 2 : 1
                    
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        Text {
                            text: "👤"
                            font.pixelSize: 16
                            opacity: 0.6
                        }
                        
                        TextField {
                            id: loginInput
                            Layout.fillWidth: true
                            font.pixelSize: 15
                            placeholderText: "Введите логин"
                            placeholderTextColor: "#B0BEC5"
                            color: "#2C3E50"
                            background: Item {}
                            focus: true
                            
                            onTextChanged: {
                                if (authErrorRect.visible) {
                                    authError.text = ""
                                    authErrorRect.visible = false
                                    loginButton.enabled = true
                                }
                            }
                            
                            onAccepted: passwordInput.forceActiveFocus()
                        }
                    }
                }
            }

            // Поле ввода пароля
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                
                Text {
                    text: "Пароль"
                    font.pixelSize: 13
                    font.bold: true
                    color: "#2C3E50"
                    leftPadding: 4
                }
                
                Rectangle {
                    Layout.fillWidth: true
                    height: 48
                    radius: 8
                    color: "#F5F7FA"
                    border.color: passwordInput.activeFocus ? "#1976D2" : "#E0E6ED"
                    border.width: passwordInput.activeFocus ? 2 : 1
                    
                    Behavior on border.color { ColorAnimation { duration: 150 } }
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        Text {
                            text: "🔒"
                            font.pixelSize: 16
                            opacity: 0.6
                        }
                        
                        TextField {
                            id: passwordInput
                            Layout.fillWidth: true
                            font.pixelSize: 15
                            placeholderText: "Введите пароль"
                            placeholderTextColor: "#B0BEC5"
                            color: "#2C3E50"
                            echoMode: TextInput.Password
                            background: Item {}
                            
                            onTextChanged: {
                                if (!isResettingPassword && authErrorRect.visible) {
                                    authError.text = ""
                                    authErrorRect.visible = false
                                    loginButton.enabled = true
                                }
                            }
                            
                            onAccepted: loginButton.clicked()
                        }
                    }
                }
            }

            // Сообщение об ошибке
            // Сообщение об ошибке
            Rectangle {
                id: authErrorRect
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                color: "#FFEBEE"
                radius: 6
                visible: false
                
                Text {
                    id: authError
                    anchors.centerIn: parent
                    text: ""
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: "#F44336"
                }

                onVisibleChanged: {
                    if (visible) {
                        console.log("🟥 ОШИБКА ПОКАЗАНА")
                    } else {
                        console.log("🟩 ОШИБКА СКРЫТА")
                    }
                }
            }

            Item { Layout.preferredHeight: 10 }

            // Кнопка входа
            Button {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                
                contentItem: Text {
                    text: loginButton.enabled ? "Войти в систему" : "Вход..."
                    font.pixelSize: 15
                    font.bold: true
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 8
                    color: loginButton.enabled ? (loginButton.hovered ? "#1565C0" : "#1976D2") : "#90CAF9"
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                }
                
                // onClicked: {
                //     console.log("=== НАЖАТА КНОПКА ВХОДА ===")
                //     console.log("Логин:", loginInput.text)
                //     console.log("Пароль:", passwordInput.text)
                    
                //     enabled = false
                    
                //     const res = checkAuth()
                //     console.log("Результат проверки:", JSON.stringify(res))
                    
                //     if (res.error === "false") {
                //         console.log("✅ УСПЕШНЫЙ ВХОД, роль:", res.role)
                //         loginInput.text = ""
                //         passwordInput.text = ""
                //         stackView.push("MainScreen.qml", {
                //             "idPolyclinic": res.id_polyclinic,
                //             "userRole": res.role,
                //             "userName": res.userName
                //         })
                //     } 
                //     else {
                //         isResettingPassword = true
                //         authError.text = "❌ Неверный логин или пароль"
                //         authErrorRect.visible = true
                //         passwordInput.text = ""
                //         isResettingPassword = false
                //     }
                    
                //     enabled = true
                // }
                onClicked: {
                    enabled = true
                    stackView.push("MainScreen.qml", {
                        "idPolyclinic": 1,
                        "userRole": "admin",
                        "userName": "Администратор системы"
                    })
                }
                
                Keys.onReturnPressed: clicked()
                Keys.onEnterPressed: clicked()
            }
        }
    }

    // function checkAuth() {
    //     console.log("--- checkAuth ---")
    //     console.log("Ищем логин:", loginInput.text)
        
    //     var registrars = []
    //     try {
    //         registrars = RegistrarService.search([
    //             {"field": "login", "operator": "eq", "value": loginInput.text}
    //         ])
    //         console.log("Найдено регистраторов:", registrars.length)
    //     } catch(e) {
    //         console.log("ОШИБКА при поиске:", e)
    //         return {"id_polyclinic": -1, "error": "true"}
    //     }
        
    //     if (registrars.length === 0) {
    //         console.log("Логин не найден")
    //         return {"id_polyclinic": -1, "error": "true"}
    //     }
            
    //     var registrar = registrars[0]
    //     console.log("Найден регистратор:", registrar.login)
    //     console.log("Хеш из БД:", registrar.password_hash)
        
    //     var hash = ""
    //     try {
    //         hash = Utils.sha256(passwordInput.text)
    //         console.log("Вычисленный хеш:", hash)
    //     } catch(e) {
    //         console.log("ОШИБКА при хешировании:", e)
    //         return {"id_polyclinic": -1, "error": "true"}
    //     }
        
    //     if (registrar.password_hash === hash) {
    //         console.log("Пароль ВЕРНЫЙ")
    //         return {"id_polyclinic": registrar.id_polyclinic, "error": "false"}
    //     } else {
    //         console.log("Пароль НЕВЕРНЫЙ")
    //         console.log("Ожидался:", registrar.password_hash)
    //         console.log("Получен:", hash)
    //         return {"id_polyclinic": -1, "error": "true"}
    //     }
    // }
    function checkAuth() {
        console.log("--- checkAuth ---")
        console.log("Ищем логин:", loginInput.text)
        
        var registrars = []
        try {
            registrars = RegistrarService.search([
                {"field": "login", "operator": "eq", "value": loginInput.text}
            ])
            console.log("Найдено регистраторов:", registrars.length)
        } catch(e) {
            console.log("ОШИБКА при поиске:", e)
            return {"id_polyclinic": -1, "error": "true"}
        }
        
        if (registrars.length === 0) {
            console.log("Логин не найден")
            return {"id_polyclinic": -1, "error": "true"}
        }
            
        var registrar = registrars[0]
        console.log("Найден:", registrar.login, "роль:", registrar.role)
        
        var hash = ""
        try {
            hash = Utils.sha256(passwordInput.text)
            console.log("Вычисленный хеш:", hash)
        } catch(e) {
            console.log("ОШИБКА при хешировании:", e)
            return {"id_polyclinic": -1, "error": "true"}
        }
        
        if (registrar.password_hash === hash) {
            console.log("Пароль ВЕРНЫЙ")
            return {
                "id_polyclinic": registrar.id_polyclinic, 
                "error": "false",
                "role": registrar.role || "registrar",
                "userName": registrar.full_name
            }
        } else {
            console.log("Пароль НЕВЕРНЫЙ")
            return {"id_polyclinic": -1, "error": "true"}
        }
    }
}