import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Polyclinic.UI 1.0
import Patient.Services 1.0
import MedicalCard.Services 1.0
import PatientsByDistrictView.Services 1.0
import District.Services 1.0

Rectangle {
    id: root

    property int idPolyclinic: 0
    
    // Цветовая схема
    property color primaryColor: "#1976D2"
    property color successColor: "#4CAF50"
    property color warningColor: "#FF9800"
    property color dangerColor: "#F44336"
    
    property color bgColor: "#F5F7FA"
    property color surfaceColor: "#FFFFFF"
    property color borderColor: "#E0E6ED"
    property color textPrimary: "#2C3E50"
    property color textSecondary: "#7F8C8D"
    property color textLight: "#95A5A6"
    property color hoverColor: "#F0F4F8"
    
    property var selectedCard: null
    property string searchQuery: ""
    property string searchField: "full_name"
    property var searchResults: []
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 20
    
    color: bgColor

    // ============================================
    // SIGNALS
    // ============================================

        // ============================================
    // SIGNALS
    // ============================================
    
    signal switchToPage(int index)
    signal switchToPageWithPatient(int index, var patient)

    onSelectedCardChanged: {
        console.log("selectedCard changed:", selectedCard ? selectedCard.full_name : "null")
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10
        anchors.margins: 5
        
        Rectangle {
            Layout.preferredWidth: 360
            Layout.fillHeight: true
            color: "transparent"
            
            ColumnLayout {
                anchors.fill: parent
                spacing: 10
                
                // Заголовок
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    color: surfaceColor
                    border.color: borderColor
                    border.width: 1
                    radius: 12
                    
                    Text {
                        anchors.centerIn: parent
                        text: "🔍 Поиск медкарты"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: textPrimary
                    }
                }
                
                // Панель поиска
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 140
                    color: surfaceColor
                    border.color: borderColor
                    border.width: 1
                    radius: 12
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 10
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            ComboBox {
                                id: searchTypeCombo
                                Layout.preferredWidth: 120
                                Layout.preferredHeight: 42
                                model: ["ФИО", "Номер карты", "Улица", "Телефон"]
                                currentIndex: 0
                                
                                background: Rectangle {
                                    radius: 10
                                    color: bgColor
                                    border.color: borderColor
                                    border.width: 1
                                }
                                
                                contentItem: Text {
                                    text: searchTypeCombo.currentText
                                    font.pixelSize: 14
                                    color: textPrimary
                                    verticalAlignment: Text.AlignVCenter
                                    leftPadding: 14
                                }
                                
                                indicator: Text {
                                    text: "▼"
                                    font.pixelSize: 12
                                    color: textSecondary
                                    anchors.right: parent.right
                                    anchors.rightMargin: 14
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                                
                                popup: Popup {
                                    y: searchTypeCombo.height + 4
                                    width: searchTypeCombo.width
                                    padding: 6
                                    
                                    background: Rectangle {
                                        radius: 10
                                        color: surfaceColor
                                        border.color: borderColor
                                    }
                                    
                                    contentItem: ListView {
                                        clip: true
                                        implicitHeight: contentHeight
                                        model: searchTypeCombo.popup.visible ? searchTypeCombo.delegateModel : null
                                        spacing: 2
                                        ScrollBar.vertical: ScrollBar {}
                                    }
                                }
                                
                                delegate: ItemDelegate {
                                    width: searchTypeCombo.width
                                    height: 40
                                    
                                    contentItem: Text {
                                        text: modelData
                                        font.pixelSize: 14
                                        color: textPrimary
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 14
                                    }
                                    
                                    background: Rectangle {
                                        radius: 8
                                        color: parent.hovered ? hoverColor : "transparent"
                                    }
                                }
                                
                                onCurrentTextChanged: {
                                    switch(currentText) {
                                        case "ФИО": searchField = "full_name"; break
                                        case "Номер карты": searchField = "card_number"; break
                                        case "Улица": searchField = "address"; break
                                        case "Телефон": searchField = "phone"; break
                                    }
                                    if (searchFieldInput.text.length >= 2) {
                                        performSearch()
                                    }
                                }
                            }
                            
                            TextField {
                                id: searchFieldInput
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "Введите запрос для поиска..."
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 14
                                rightPadding: 14
                                
                                background: Rectangle {
                                    radius: 10
                                    color: bgColor
                                    border.color: searchFieldInput.activeFocus ? primaryColor : borderColor
                                    border.width: searchFieldInput.activeFocus ? 2 : 1
                                    
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                onTextChanged: {
                                    searchQuery = text
                                    if (text.length >= 2) {
                                        searchTimer.restart()
                                    } else {
                                        searchTimer.stop()
                                        searchResults = []
                                    }
                                }
                                
                                onAccepted: {
                                    searchTimer.stop()
                                    performSearch()
                                }
                            }
                        }
                        
                        Timer {
                            id: searchTimer
                            interval: 400
                            onTriggered: performSearch()
                        }
                        
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Button {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                text: "🔍 Найти"
                                
                                background: Rectangle {
                                    radius: 10
                                    color: parent.hovered ? Qt.darker(primaryColor, 1.1) : primaryColor
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    font.pixelSize: 14
                                    font.weight: Font.DemiBold
                                    color: "#FFFFFF"
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                onClicked: {
                                    searchTimer.stop()
                                    performSearch()
                                }
                            }
                            
                            Button {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                text: "🗑️ Сбросить"
                                
                                background: Rectangle {
                                    radius: 10
                                    color: parent.hovered ? hoverColor : "transparent"
                                    border.color: borderColor
                                    border.width: 1
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }
                                
                                contentItem: Text {
                                    text: parent.text
                                    font.pixelSize: 14
                                    color: textSecondary
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                }
                                
                                onClicked: {
                                    searchTimer.stop()
                                    searchFieldInput.text = ""
                                    searchResults = []
                                    selectedCard = null
                                }
                            }
                        }
                    }
                }
                
                // Список результатов
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: surfaceColor
                    border.color: borderColor
                    border.width: 1
                    radius: 12
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 5
                        
                        Text {
                            text: "Найдено: " + searchResults.length
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: textPrimary
                            visible: searchResults.length > 0
                        }
                        
                        ListView {
                            id: cardListView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: searchResults
                            spacing: 5
                            
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 70
                                color: selectedCard === modelData ? "#E3F2FD" : (cardMouse.containsMouse ? hoverColor : surfaceColor)
                                border.color: selectedCard === modelData ? primaryColor : borderColor
                                border.width: selectedCard === modelData ? 2 : 1
                                radius: 10
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 10
                                    
                                    Rectangle {
                                        width: 45
                                        height: 45
                                        radius: 23
                                        color: primaryColor
                                        opacity: 0.12
                                        
                                        Text {
                                            anchors.centerIn: parent
                                            text: "👤"
                                            font.pixelSize: 22
                                        }
                                    }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 3
                                        
                                        Text {
                                            Layout.fillWidth: true
                                            text: modelData.full_name || "—"
                                            font.pixelSize: 14
                                            font.weight: Font.DemiBold
                                            color: textPrimary
                                            elide: Text.ElideRight
                                        }
                                        
                                        Text {
                                            Layout.fillWidth: true
                                            text: "🪪 " + (modelData.card_number || "—")
                                            font.pixelSize: 11
                                            color: textSecondary
                                            elide: Text.ElideRight
                                        }
                                        
                                        Text {
                                            Layout.fillWidth: true
                                            text: "📍 " + (modelData.shelf_number || "—") + "-" + (modelData.row_number || "—") + " | " + (modelData.color_marking || "—")
                                            font.pixelSize: 11
                                            color: primaryColor
                                            elide: Text.ElideRight
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    id: cardMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        console.log("CLICKED ON CARD:", modelData.full_name)
                                        loadFullCardData(modelData.id)
                                    }
                                }
                            }
                        }
                        
                        Text {
                            Layout.alignment: Qt.AlignCenter
                            text: searchQuery.length >= 2 ? "😕 Ничего не найдено" : "Введите запрос для поиска"
                            font.pixelSize: 13
                            color: textLight
                            visible: searchResults.length === 0
                        }
                    }
                }
            }
        }

        // ============================================
        // RIGHT PANEL - CARD INFO
        // ============================================
        
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: surfaceColor
            border.color: borderColor
            border.width: 1
            radius: 12
            
            // Информация о карте
            ScrollView {
                anchors.fill: parent
                clip: true
                visible: selectedCard !== null
                contentWidth: availableWidth
                
                ColumnLayout {
                    width: parent.width - 20
                    x: 10
                    spacing: 15
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "📇 Информация о карте"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                            Layout.fillWidth: true
                        }
                        
                        // Button {
                        //     text: "✕"
                        //     flat: true
                        //     onClicked: selectedCard = null
                            
                        //     contentItem: Text {
                        //         text: parent.text
                        //         font.pixelSize: 16
                        //         color: textSecondary
                        //     }
                        // }
                    }
                    
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 2
                        rowSpacing: 10
                        columnSpacing: 15
                        
                        Text { text: "ФИО:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.full_name : "—"; font.pixelSize: 13; color: textPrimary; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        
                        Text { text: "Дата рождения:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? formatDate(selectedCard.birth_date) : "—"; font.pixelSize: 13; color: textPrimary }
                        
                        Text { text: "Телефон:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.phone : "—"; font.pixelSize: 13; color: textPrimary }
                        
                        Text { text: "Адрес:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.address : "—"; font.pixelSize: 13; color: textPrimary; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        
                        Text { text: "Участок:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? ("№" + selectedCard.district_number) : "—"; font.pixelSize: 13; color: textPrimary }
                        
                        Text { text: "Номер карты:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.card_number : "—"; font.pixelSize: 13; color: textPrimary }
                        
                        Text { text: "Группа крови:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.blood_group : "—"; font.pixelSize: 13; color: textPrimary }
                        
                        Text { text: "Аллергии:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.allergies : "—"; font.pixelSize: 13; color: textPrimary; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                        
                        Text { text: "Хр. заболевания:"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        Text { text: selectedCard ? selectedCard.chronic_diseases : "—"; font.pixelSize: 13; color: textPrimary; Layout.fillWidth: true; wrapMode: Text.WordWrap }
                    }
                    
                    Rectangle { 
                        Layout.fillWidth: true
                        height: 1
                        color: borderColor
                    }
                    
                    Text {
                        text: "📍 Местоположение"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: textPrimary
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            
                            Text { 
                                text: "Стеллаж"
                                font.pixelSize: 12
                                color: textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text { 
                                text: selectedCard ? selectedCard.shelf_number : "—"
                                font.pixelSize: 24
                                font.weight: Font.DemiBold
                                color: primaryColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            
                            Text { 
                                text: "Ряд"
                                font.pixelSize: 12
                                color: textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text { 
                                text: selectedCard ? selectedCard.row_number : "—"
                                font.pixelSize: 24
                                font.weight: Font.DemiBold
                                color: warningColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            
                            Text { 
                                text: "Цвет"
                                font.pixelSize: 12
                                color: textSecondary
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text { 
                                text: selectedCard ? selectedCard.color_marking : "—"
                                font.pixelSize: 24
                                font.weight: Font.DemiBold
                                color: successColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                    
                    Rectangle { 
                        Layout.fillWidth: true
                        height: 1
                        color: borderColor
                    }
                    
                    Text {
                        text: "⚡ Быстрые действия"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: textPrimary
                    }
                    
                    GridLayout {
                        Layout.fillWidth: true
                        columns: 3
                        rowSpacing: 12
                        columnSpacing: 12
                        
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50

                            text: "📝 Записать"
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(primaryColor, 1.1) : primaryColor
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                if (selectedCard) {
                                    switchToPageWithPatient(1, selectedCard)
                                }
                            }
                        }
                        
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            
                            text: "📄 Больничный"
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(warningColor, 1.1) : warningColor
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                if (selectedCard) {
                                    switchToPageWithPatient(4, selectedCard)
                                }
                            }
                        }
                        
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            
                            text: "📋 Справка"
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(successColor, 1.1) : successColor
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: {
                                switchToPageWithPatient(5, selectedCard)
                            }
                        }
                        
                        Button {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            
                            text: "✏️ Изменить"
                            
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? hoverColor : "transparent"
                                border.color: borderColor
                                border.width: 1
                            }
                            
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: textSecondary
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            
                            onClicked: openEditDialog()
                        }
                        
                        // Button {
                        //     Layout.fillWidth: true
                        //     Layout.preferredHeight: 50
                            
                        //     text: "📍 Переместить"
                            
                        //     background: Rectangle {
                        //         radius: 8
                        //         color: parent.hovered ? Qt.darker("#9C27B0", 1.1) : "#9C27B0"
                        //     }
                            
                        //     contentItem: Text {
                        //         text: parent.text
                        //         font.pixelSize: 12
                        //         color: "#FFFFFF"
                        //         horizontalAlignment: Text.AlignHCenter
                        //         verticalAlignment: Text.AlignVCenter
                        //     }
                            
                        //     onClicked: openLocationDialog()
                        // }
                        
                        // Button {
                        //     Layout.fillWidth: true
                        //     Layout.preferredHeight: 50
                            
                        //     text: "📜 История"
                            
                        //     background: Rectangle {
                        //         radius: 8
                        //         color: parent.hovered ? hoverColor : "transparent"
                        //         border.color: borderColor
                        //         border.width: 1
                        //     }
                            
                        //     contentItem: Text {
                        //         text: parent.text
                        //         font.pixelSize: 12
                        //         color: textSecondary
                        //         horizontalAlignment: Text.AlignHCenter
                        //         verticalAlignment: Text.AlignVCenter
                        //     }
                            
                        //     onClicked: showHistory()
                        // }
                    }
                    
                    Item { Layout.preferredHeight: 15 }
                }
            }
            
            // Пустое состояние
            Column {
                anchors.centerIn: parent
                spacing: 10
                visible: selectedCard === null
                
                Text {
                    text: "📇"
                    font.pixelSize: 48
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                
                Text {
                    text: "Выберите карту"
                    font.pixelSize: 14
                    color: textLight
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    // ============================================
    // EDIT DIALOG
    // ============================================
    
        // ============================================
    // EDIT DIALOG
    // ============================================
    
        // ============================================
    // EDIT DIALOG
    // ============================================
    
        // ============================================
    // EDIT DIALOG
    // ============================================
    
    Dialog {
        id: editDialog
        width: 580
        height: 640
        anchors.centerIn: parent
        modal: true

        
        background: Rectangle {
            radius: 16
            color: surfaceColor
            border.color: borderColor
            border.width: 1
        }

        footer: Rectangle {
            width: parent.width
            height: 70
            color: "transparent"
            radius: 16
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Отмена"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 42
                    
                    background: Rectangle {
                        radius: 10
                        color: parent.hovered ? hoverColor : "transparent"
                        border.color: borderColor
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        color: textSecondary
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        editDialog.reject()
                    }
                }
                
                Button {
                    text: "💾 Сохранить"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 42
                    
                    background: Rectangle {
                        radius: 10
                        color: parent.hovered ? Qt.darker(primaryColor, 1.1) : primaryColor
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: "#FFFFFF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    
                    onClicked: {
                        if (savePatientData()) {
                            editDialog.accept()  // Закрываем сразу
                        }
                    }
                }
            }
        }
        
        contentItem: ScrollView {
            anchors.fill: parent
            anchors.margins:5
            // anchors.leftMargin: -24
            // anchors.rightMargin: -24
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            
            ColumnLayout {
                width: parent.width - 48
                x: 24
                spacing: 20
                
                // ============================================
                // ОСНОВНЫЕ ДАННЫЕ
                // ============================================
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 10
                            color: primaryColor
                            opacity: 0.12
                            
                            Text {
                                anchors.centerIn: parent
                                text: "👤"
                                font.pixelSize: 18
                            }
                        }
                        
                        Text {
                            text: "Основные данные"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: primaryColor
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: borderColor
                    }
                    
                    // Фамилия Имя Отчество в ряд
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "Фамилия"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editLastName
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "Иванов"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editLastName.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.full_name.split(" ")[0] || "" : ""
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "Имя"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editFirstName
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "Иван"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editFirstName.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.full_name.split(" ")[1] || "" : ""
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "Отчество"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editMiddleName
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "Иванович"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editMiddleName.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.full_name.split(" ")[2] || "" : ""
                            }
                        }
                    }
                    
                    // Телефон и Дата рождения
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "Телефон"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editPhone
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "+7 (900) 123-45-67"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editPhone.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.phone || "" : ""
                            }
                        }
                        
                        ColumnLayout {
                            Layout.preferredWidth: 180
                            spacing: 6
                            
                            Text { text: "Дата рождения"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editBirthDate
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "ДД.ММ.ГГГГ"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editBirthDate.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: formatDate(editDialog.patient ? editDialog.patient.birth_date : null)
                            }
                        }
                    }
                    
                    // Адрес
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Text { text: "Адрес"; font.pixelSize: 12; color: textSecondary }
                        
                        TextField {
                            id: editAddress
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "ул. Ленина, д. 10, кв. 5"
                            placeholderTextColor: textLight
                            font.pixelSize: 14
                            color: textPrimary
                            leftPadding: 12
                            
                            background: Rectangle {
                                radius: 8
                                color: bgColor
                                border.color: editAddress.activeFocus ? primaryColor : borderColor
                                border.width: 1
                                Behavior on border.color { ColorAnimation { duration: 150 } }
                            }
                            
                            text: editDialog.patient ? editDialog.patient.address || "" : ""
                        }
                    }
                }
                
                // ============================================
                // МЕДИЦИНСКИЕ ДАННЫЕ
                // ============================================
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 16
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10
                        
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 10
                            color: successColor
                            opacity: 0.12
                            
                            Text {
                                anchors.centerIn: parent
                                text: "🏥"
                                font.pixelSize: 18
                            }
                        }
                        
                        Text {
                            text: "Медицинские данные"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: successColor
                        }
                    }
                    
                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: borderColor
                    }
                    
                    // Номер карты и Группа крови
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            
                            Text { text: "Номер карты"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editCardNumber
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "К-0001"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editCardNumber.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.card_number || "" : ""
                            }
                        }
                        
                        ColumnLayout {
                            Layout.preferredWidth: 180
                            spacing: 6
                            
                            Text { text: "Группа крови"; font.pixelSize: 12; color: textSecondary }
                            
                            TextField {
                                id: editBloodGroup
                                Layout.fillWidth: true
                                Layout.preferredHeight: 42
                                placeholderText: "I(0)Rh+"
                                placeholderTextColor: textLight
                                font.pixelSize: 14
                                color: textPrimary
                                leftPadding: 12
                                
                                background: Rectangle {
                                    radius: 8
                                    color: bgColor
                                    border.color: editBloodGroup.activeFocus ? primaryColor : borderColor
                                    border.width: 1
                                    Behavior on border.color { ColorAnimation { duration: 150 } }
                                }
                                
                                text: editDialog.patient ? editDialog.patient.blood_group || "" : ""
                            }
                        }
                    }
                    
                    // Аллергии
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Text { text: "Аллергии"; font.pixelSize: 12; color: textSecondary }
                        
                        TextArea {
                            id: editAllergies
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            placeholderText: "Пенициллин, цитрусовые..."
                            placeholderTextColor: textLight
                            font.pixelSize: 14
                            color: textPrimary
                            
                            background: Rectangle {
                                radius: 8
                                color: bgColor
                                border.color: editAllergies.activeFocus ? primaryColor : borderColor
                                border.width: 1
                                Behavior on border.color { ColorAnimation { duration: 150 } }
                            }
                            
                            text: editDialog.patient ? editDialog.patient.allergies || "" : ""
                        }
                    }
                    
                    // Хронические заболевания
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        
                        Text { text: "Хронические заболевания"; font.pixelSize: 12; color: textSecondary }
                        
                        TextArea {
                            id: editChronicDiseases
                            Layout.fillWidth: true
                            Layout.preferredHeight: 70
                            placeholderText: "Гипертония, диабет..."
                            placeholderTextColor: textLight
                            font.pixelSize: 14
                            color: textPrimary
                            
                            background: Rectangle {
                                radius: 8
                                color: bgColor
                                border.color: editChronicDiseases.activeFocus ? primaryColor : borderColor
                                border.width: 1
                                Behavior on border.color { ColorAnimation { duration: 150 } }
                            }
                            
                            text: editDialog.patient ? editDialog.patient.chronic_diseases || "" : ""
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 5 }
            }
        }
        
        property var patient: null
        
        onOpened: {
            patient = selectedCard
        }
    }
    
    // ============================================
    // LOCATION DIALOG
    // ============================================
    
    Dialog {
        id: locationDialog
        width: 400
        height: 350
        anchors.centerIn: parent
        modal: true
        title: "📍 Изменить местоположение"
        standardButtons: Dialog.Ok | Dialog.Cancel
        
        background: Rectangle {
            radius: 12
            color: surfaceColor
            border.color: borderColor
        }
        
        contentItem: ColumnLayout {
            spacing: 20
            
            Text {
                text: "🏥 " + (locationDialog.patient ? locationDialog.patient.full_name : "—")
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: textPrimary
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
            
            Text {
                text: "Текущее: " + (locationDialog.patient ? 
                    "Стеллаж " + locationDialog.patient.shelf_number + 
                    ", Ряд " + locationDialog.patient.row_number + 
                    ", " + locationDialog.patient.color_marking : "—")
                font.pixelSize: 13
                color: textSecondary
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Text { text: "Стеллаж"; font.pixelSize: 12; color: textSecondary; Layout.alignment: Qt.AlignHCenter }
                    
                    ComboBox {
                        id: shelfCombo
                        Layout.fillWidth: true
                        model: ["A", "B", "C", "D", "E"]
                        currentIndex: locationDialog.patient ? 
                            ["A","B","C","D","E"].indexOf(locationDialog.patient.shelf_number) : 0
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Text { text: "Ряд"; font.pixelSize: 12; color: textSecondary; Layout.alignment: Qt.AlignHCenter }
                    
                    ComboBox {
                        id: rowCombo
                        Layout.fillWidth: true
                        model: ["1", "2", "3", "4", "5", "6"]
                        currentIndex: locationDialog.patient ? 
                            ["1","2","3","4","5","6"].indexOf(locationDialog.patient.row_number) : 0
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    
                    Text { text: "Цвет"; font.pixelSize: 12; color: textSecondary; Layout.alignment: Qt.AlignHCenter }
                    
                    ComboBox {
                        id: colorCombo
                        Layout.fillWidth: true
                        model: ["Зеленый", "Желтый", "Красный", "Синий"]
                        currentIndex: locationDialog.patient ? 
                            ["Зеленый","Желтый","Красный","Синий"].indexOf(locationDialog.patient.color_marking) : 0
                    }
                }
            }
        }
        
        property var patient: null
        
        onOpened: {
            patient = selectedCard
        }
        
        onAccepted: {
            updateLocation()
        }
    }

    // ============================================
    // FUNCTIONS
    // ============================================

    function formatDate(dateValue) {
        if (!dateValue) return "—"
        
        // Если это объект Date
        if (typeof dateValue === "object" && dateValue.getDate) {
            var day = dateValue.getDate().toString().padStart(2, '0')
            var month = (dateValue.getMonth() + 1).toString().padStart(2, '0')
            var year = dateValue.getFullYear()
            return day + "." + month + "." + year
        }
        
        // Если это строка
        var dateStr = dateValue.toString()
        if (dateStr.indexOf("-") !== -1) {
            var parts = dateStr.split("-")
            if (parts.length === 3) {
                return parts[2] + "." + parts[1] + "." + parts[0]
            }
        }
        
        // Если уже в формате dd.MM.yyyy
        if (dateStr.indexOf(".") !== -1) {
            return dateStr
        }
        
        return dateStr
    }
    
    
    function performSearch() {
        if (searchQuery.length < 2) {
            searchResults = []
            return
        }
        
        console.log("Search:", searchField, "=", searchQuery)
        
        try {
            if (searchField === "full_name") {
                var patients = PatientService.search([
                    {"field": "full_name", "operator": "like", "value": "%" + searchQuery + "%"}
                ])
                enrichPatientsWithCardData(patients)
            } else if (searchField === "card_number") {
                var cards = MedicalCardService.search([
                    {"field": "card_number", "operator": "like", "value": "%" + searchQuery + "%"}
                ])
                enrichCardsWithPatientData(cards)
            } else if (searchField === "phone") {
                var patientsByPhone = PatientService.search([
                    {"field": "phone", "operator": "like", "value": "%" + searchQuery + "%"}
                ])
                enrichPatientsWithCardData(patientsByPhone)
            } else {
                loadMockData()
            }
        } catch (e) {
            console.error("Search error:", e)
            loadMockData()
        }
    }
    
    function enrichPatientsWithCardData(patients) {
        var results = []
        for (var i = 0; i < patients.length; i++) {
            var patient = patients[i]
            try {
                var cards = MedicalCardService.search([
                    {"field": "id_patient", "operator": "eq", "value": patient.id}
                ])
                if (cards.length > 0) {
                    patient.card_number = cards[0].card_number
                    patient.shelf_number = cards[0].shelf_number
                    patient.row_number = cards[0].row_number
                    patient.color_marking = cards[0].color_marking
                    patient.blood_group = cards[0].blood_group
                    patient.allergies = cards[0].allergies
                    patient.chronic_diseases = cards[0].chronic_diseases
                }
                
                if (patient.id_district) {
                    var districts = DistrictService.search([
                        {"field": "id", "operator": "eq", "value": patient.id_district}
                    ])
                    if (districts.length > 0) {
                        patient.district_number = districts[0].number
                    }
                }
                
                results.push(patient)
            } catch (e) {
                results.push(patient)
            }
        }
        searchResults = results
    }
    
    function enrichCardsWithPatientData(cards) {
        var results = []
        for (var i = 0; i < cards.length; i++) {
            var card = cards[i]
            try {
                var patients = PatientService.search([
                    {"field": "id", "operator": "eq", "value": card.id_patient}
                ])
                if (patients.length > 0) {
                    var patient = patients[0]
                    patient.card_number = card.card_number
                    patient.shelf_number = card.shelf_number
                    patient.row_number = card.row_number
                    patient.color_marking = card.color_marking
                    patient.blood_group = card.blood_group
                    patient.allergies = card.allergies
                    patient.chronic_diseases = card.chronic_diseases
                    
                    if (patient.id_district) {
                        var districts = DistrictService.search([
                            {"field": "id", "operator": "eq", "value": patient.id_district}
                        ])
                        if (districts.length > 0) {
                            patient.district_number = districts[0].number
                        }
                    }
                    
                    results.push(patient)
                }
            } catch (e) {
                results.push(card)
            }
        }
        searchResults = results
    }
    
    function loadMockData() {
        var allCards = [
            {
                id: 1, full_name: "Иванов Иван Иванович", card_number: "К-0001",
                shelf_number: "A", row_number: "1", district_number: 3,
                phone: "+7 (900) 111-22-33", address: "ул. Ленина, 10, кв. 5",
                birth_date: "15.05.1985", blood_group: "I(0)Rh+",
                allergies: "Нет", chronic_diseases: "Нет", color_marking: "Зеленый"
            },
            {
                id: 2, full_name: "Петрова Анна Сергеевна", card_number: "К-0002",
                shelf_number: "B", row_number: "2", district_number: 5,
                phone: "+7 (900) 222-33-44", address: "пр. Мира, 25, кв. 12",
                birth_date: "20.08.1990", blood_group: "II(A)Rh+",
                allergies: "Пенициллин", chronic_diseases: "Гастрит", color_marking: "Красный"
            },
            {
                id: 3, full_name: "Сидоров Петр Ильич", card_number: "К-0003",
                shelf_number: "C", row_number: "1", district_number: 1,
                phone: "+7 (900) 333-44-55", address: "ул. Гагарина, 15",
                birth_date: "10.03.1978", blood_group: "III(B)Rh-",
                allergies: "Нет", chronic_diseases: "Гипертония", color_marking: "Желтый"
            }
        ]
        
        searchResults = allCards.filter(card => {
            var value = card[searchField] || ""
            return value.toString().toLowerCase().includes(searchQuery.toLowerCase())
        })
    }
    
    function loadFullCardData(cardId) {
        try {
            var patients = PatientService.search([
                {"field": "id", "operator": "eq", "value": cardId}
            ])
            
            if (patients.length > 0) {
                var patient = patients[0]
                
                var cards = MedicalCardService.search([
                    {"field": "id_patient", "operator": "eq", "value": cardId}
                ])
                
                if (cards.length > 0) {
                    patient.card_number = cards[0].card_number
                    patient.shelf_number = cards[0].shelf_number
                    patient.row_number = cards[0].row_number
                    patient.color_marking = cards[0].color_marking
                    patient.blood_group = cards[0].blood_group
                    patient.allergies = cards[0].allergies
                    patient.chronic_diseases = cards[0].chronic_diseases
                }
                
                if (patient.id_district) {
                    var districts = DistrictService.search([
                        {"field": "id", "operator": "eq", "value": patient.id_district}
                    ])
                    if (districts.length > 0) {
                        patient.district_number = districts[0].number
                    }
                }
                
                selectedCard = patient
                console.log("Loaded card data:", patient.full_name)
            }
        } catch (e) {
            console.error("Error loading full card data:", e)
            var found = searchResults.find(c => c.id === cardId)
            if (found) selectedCard = found
        }
    }
    
    function openEditDialog() {
        if (!selectedCard) return
        editDialog.patient = selectedCard
        editDialog.open()
    }
    
    function savePatientData() {
        if (!selectedCard) {
            showError("Карта не выбрана")
            return false
        }
        
        try {
            // ============================================
            // ВАЛИДАЦИЯ ВСЕХ ПОЛЕЙ
            // ============================================
            
            // ФИО
            var lastName = editLastName.text.trim()
            var firstName = editFirstName.text.trim()
            var middleName = editMiddleName.text.trim()
            
            if (!lastName && !firstName && !middleName) {
                showError("Заполните хотя бы фамилию или имя")
                return
            }
            
            var fullName = [lastName, firstName, middleName].filter(s => s !== "").join(" ")
            
            if (!fullName || fullName.length < 2) {
                showError("ФИО должно содержать минимум 2 символа")
                return
            }
            
            // Дата рождения
            var birthDate = editBirthDate.text.trim()
            
            if (birthDate) {
                // Проверяем формат dd.MM.yyyy
                if (birthDate.indexOf(".") !== -1) {
                    var parts = birthDate.split(".")
                    if (parts.length !== 3) {
                        showError("Неверный формат даты. Используйте ДД.ММ.ГГГГ")
                        return
                    }
                    
                    var day = parseInt(parts[0])
                    var month = parseInt(parts[1])
                    var year = parseInt(parts[2])
                    
                    if (isNaN(day) || isNaN(month) || isNaN(year)) {
                        showError("Дата содержит буквы. Введите цифры")
                        return
                    }
                    
                    if (day < 1 || day > 31) {
                        showError("День должен быть от 1 до 31")
                        return
                    }
                    
                    if (month < 1 || month > 12) {
                        showError("Месяц должен быть от 1 до 12")
                        return
                    }
                    
                    if (year < 1900 || year > 2026) {
                        showError("Год должен быть от 1900 до 2026")
                        return
                    }
                    
                    birthDate = parts[2] + "-" + parts[1].padStart(2, '0') + "-" + parts[0].padStart(2, '0')
                } else if (birthDate.indexOf("-") !== -1) {
                    // Уже в формате yyyy-MM-dd
                    var isoParts = birthDate.split("-")
                    if (isoParts.length !== 3) {
                        showError("Неверный формат даты")
                        return
                    }
                } else {
                    showError("Неверный формат даты. Используйте ДД.ММ.ГГГГ")
                    return
                }
            } else {
                // Берём текущую дату
                var currentDate = selectedCard.birth_date
                if (typeof currentDate === "object" && currentDate.getDate) {
                    var d = currentDate.getDate().toString().padStart(2, '0')
                    var m = (currentDate.getMonth() + 1).toString().padStart(2, '0')
                    var y = currentDate.getFullYear()
                    birthDate = y + "-" + m + "-" + d
                } else if (typeof currentDate === "string" && currentDate.length >= 8) {
                    birthDate = currentDate
                } else {
                    birthDate = "1980-01-01"
                }
            }
            
            // Телефон
            var phone = editPhone.text.trim()
            if (phone) {
                // Убираем всё кроме цифр и +
                var cleanPhone = phone.replace(/[^\d+]/g, '')
                if (cleanPhone.length < 10) {
                    showError("Телефон слишком короткий (минимум 10 цифр)")
                    return
                }
                if (cleanPhone.length > 15) {
                    showError("Телефон слишком длинный (максимум 15 символов)")
                    return
                }
                phone = cleanPhone
            } else {
                phone = selectedCard.phone || ""
            }
            
            // Адрес
            var address = editAddress.text.trim()
            if (address.length > 500) {
                showError("Адрес слишком длинный (максимум 500 символов)")
                return
            }
            if (!address) {
                address = selectedCard.address || ""
            }
            
            // Номер карты
            var cardNumber = editCardNumber.text.trim()
            if (cardNumber && cardNumber.length > 20) {
                showError("Номер карты слишком длинный (максимум 20 символов)")
                return
            }
            
            // Группа крови
            var bloodGroup = editBloodGroup.text.trim()
            if (bloodGroup && bloodGroup.length > 10) {
                showError("Группа крови слишком длинная (максимум 10 символов)")
                return
            }
            
            // Аллергии
            var allergies = editAllergies.text.trim()
            if (allergies && allergies.length > 500) {
                showError("Поле 'Аллергии' слишком длинное (максимум 500 символов)")
                return
            }
            
            // Хронические заболевания
            var chronicDiseases = editChronicDiseases.text.trim()
            if (chronicDiseases && chronicDiseases.length > 500) {
                showError("Поле 'Хр. заболевания' слишком длинное (максимум 500 символов)")
                return
            }
            
            console.log("All validations passed")
            
            // ============================================
            // СОХРАНЕНИЕ
            // ============================================
            
            // 1. Обновляем пациента
            var patientResult = PatientService.update({
                id: selectedCard.id,
                full_name: fullName,
                birth_date: birthDate,
                address: address,
                phone: phone,
                passport_data: selectedCard.passport_data || "",
                id_district: selectedCard.id_district || null
            })
            
            if (!patientResult) {
                showError("Не удалось обновить данные пациента")
                return
            }
            
            // 2. Обновляем медкарту
            var cards = MedicalCardService.search([
                {"field": "id_patient", "operator": "eq", "value": selectedCard.id}
            ])
            
            if (cards.length === 0) {
                showError("Медицинская карта не найдена")
                return
            }
            
            var existingCard = cards[0]
            var cardResult = MedicalCardService.update({
                id: existingCard.id,
                card_number: cardNumber || existingCard.card_number || "",
                blood_group: bloodGroup || existingCard.blood_group || "",
                allergies: allergies || existingCard.allergies || "",
                chronic_diseases: chronicDiseases || existingCard.chronic_diseases || "",
                shelf_number: existingCard.shelf_number || "",
                row_number: existingCard.row_number || "",
                color_marking: existingCard.color_marking || "",
                id_patient: selectedCard.id,
                created_at: existingCard.created_at || new Date().toISOString()
            })
            
            if (!cardResult) {
                showError("Не удалось обновить медкарту")
                return
            }
            
            showSuccess("Данные сохранены")
            loadFullCardData(selectedCard.id)

            if (searchQuery.length >= 2) {
                performSearch()
            }

            return true
            
        } catch (e) {
            console.error("Error saving data:", e.message || e)
            showError("Ошибка сохранения: " + (e.message || "неизвестная ошибка"))
            return false
        }
    }
    
    function updateLocation() {
        if (!selectedCard) return
        
        try {
            var cards = MedicalCardService.search([
                {"field": "id_patient", "operator": "eq", "value": selectedCard.id}
            ])
            
            if (cards.length > 0) {
                var existingCard = cards[0]
                if(!MedicalCardService.update({
                    id: existingCard.id,
                    card_number: existingCard.card_number || "",
                    blood_group: existingCard.blood_group || "",
                    allergies: existingCard.allergies || "",
                    chronic_diseases: existingCard.chronic_diseases || "",
                    shelf_number: shelfCombo.currentText || existingCard.shelf_number || "",
                    row_number: rowCombo.currentText || existingCard.row_number || "",
                    color_marking: colorCombo.currentText || existingCard.color_marking || "",
                    id_patient: selectedCard.id
                })) {
                    throw "medcard update location not success"
                }
                
                showSuccess("Местоположение обновлено")
                loadFullCardData(selectedCard.id)
            }
            
        } catch (e) {
            console.error("Error updating location:", e)
            showError("Ошибка обновления")
        }
    }
    
    function openLocationDialog() {
        if (!selectedCard) return
        locationDialog.patient = selectedCard
        locationDialog.open()
    }
    
    // function updateLocation() {
    //     try {
    //         MedicalCardService.update({
    //             id_patient: selectedCard.id,
    //             shelf_number: shelfCombo.currentText,
    //             row_number: rowCombo.currentText,
    //             color_marking: colorCombo.currentText
    //         })
            
    //         console.log("Location updated")
    //         showSuccess("Местоположение обновлено")
    //         loadFullCardData(selectedCard.id)
    //     } catch (e) {
    //         console.error("Error updating location:", e)
    //         showError("Ошибка обновления")
    //     }
    // }
    
    function showHistory() {
        if (!selectedCard) return
        console.log("Show history for:", selectedCard.card_number)
        showSuccess("История перемещений пока недоступна")
    }
    
    function showSuccess(message) {
        successSnackbar.text = message
        successSnackbar.open()
    }
    
    function showError(message) {
        errorSnackbar.text = message
        errorSnackbar.open()
    }
    
    // ============================================
    // SNACKBARS
    // ============================================
    
        // ============================================
    // SNACKBARS
    // ============================================
    
    Popup {
        id: successSnackbar
        width: 300
        height: 50
        x: parent.width / 2 - 150
        y: parent.height - 80
        closePolicy: Popup.CloseOnEscape
        padding: 0
        
        property alias text: successText.text
        
        background: Rectangle {
            radius: 10
            color: successColor
        }
        
        contentItem: Text {
            id: successText
            text: ""
            font.pixelSize: 14
            font.weight: Font.DemiBold
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
        
        Timer {
            interval: 2000
            running: successSnackbar.visible
            onTriggered: successSnackbar.close()
        }
    }
    
    Popup {
        id: errorSnackbar
        width: 300
        height: 50
        x: parent.width / 2 - 150
        y: parent.height - 80
        closePolicy: Popup.CloseOnEscape
        padding: 0
        
        property alias text: errorText.text
        
        background: Rectangle {
            radius: 10
            color: dangerColor
        }
        
        contentItem: Text {
            id: errorText
            text: ""
            font.pixelSize: 14
            font.weight: Font.DemiBold
            color: "#FFFFFF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
        }
        
        Timer {
            interval: 2000
            running: errorSnackbar.visible
            onTriggered: errorSnackbar.close()
        }
    }
}