import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Polyclinic.UI 1.0

import Patient.Services 1.0
import DoctorFullInfoView.Services 1.0
import Schedule.Services 1.0
import Appointment.Services 1.0
import ScheduleException.Services 1.0
import PatientsByDistrictView.Services 1.0

Rectangle {
    id: root

    // ============================================
    // PROPERTIES
    // ============================================
    
    property int idPolyclinic: 0
    property bool presetHomeVisit: false
    
    // Цветовая схема
    property color primaryColor: "#0066FF"
    property color successColor: "#00C853"
    property color warningColor: "#FF9800"
    property color dangerColor: "#FF3B30"
    
    property color bgColor: "#F8F9FA"
    property color surfaceColor: "#FFFFFF"
    property color borderColor: "#E9ECEF"
    property color textPrimary: "#1A1A1A"
    property color textSecondary: "#6C757D"
    property color textPlaceholder: "#ADB5BD"

    property var presetPatient: null
    
    property var selectedPatient: null
    property var selectedDoctor: null
    property var selectedSchedule: null
    property string selectedTime: ""
    property date selectedDate: new Date()
    property bool canCreateAppointment: selectedPatient !== null && selectedDoctor !== null && selectedTime !== ""
    
    property var districtDoctor: null
    property var timeSlotsModel: []
    
    // Календарь
    property date currentWeekStart: {
        var today = new Date()
        var day = today.getDay()
        var diff = day === 0 ? 6 : day - 1
        today.setDate(today.getDate() - diff)
        return today
    }
    property var weekDays: []
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 24
    
    color: bgColor

    // ============================================
    // MAIN LAYOUT - ФИКСИРОВАННЫЕ КОЛОНКИ
    // ============================================
    anchors.margins: 5
    
    // Левая колонка - всегда видна
    Rectangle {
        id: leftPanel
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 360
        color: "transparent"
        
        ColumnLayout {
            anchors.fill: parent
            
            spacing: 0
            
            // Заголовок
            // Text {
            //     text: "Пациент"
            //     font.pixelSize: 20
            //     font.weight: Font.DemiBold
            //     color: textPrimary
            // }
            
            // Поиск
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 8
                    
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Поиск по ФИО, телефону или карте"
                        placeholderTextColor: textPlaceholder
                        font.pixelSize: 14
                        color: textPrimary
                        background: Item {}
                        leftPadding: 12
                        
                        onTextChanged: {
                            if (text.length >= 3) searchTimer.restart()
                        }
                    }
                    
                    Button {
                        text: "🔍"
                        Layout.preferredWidth: 44
                        Layout.preferredHeight: 44
                        flat: true
                        onClicked: performSearch()
                    }
                }
            }
            
            Timer {
                id: searchTimer
                interval: 400
                onTriggered: performSearch()
            }
            
            // Результаты поиска
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                visible: searchResults.count > 0
                
                ListView {
                    id: searchResults
                    anchors.fill: parent
                    model: []
                    spacing: 8
                    
                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 80
                        color: selectedPatient === modelData ? "#F0F7FF" : (mouseArea.containsMouse ? bgColor : surfaceColor)
                        radius: 10
                        border.color: selectedPatient === modelData ? primaryColor : borderColor
                        border.width: selectedPatient === modelData ? 2 : 1
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 12
                            
                            Rectangle {
                                width: 44
                                height: 44
                                radius: 22
                                color: primaryColor
                                opacity: 0.1
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "👤"
                                    font.pixelSize: 20
                                }
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                
                                Text {
                                    text: modelData.full_name || "—"
                                    font.pixelSize: 15
                                    font.weight: Font.DemiBold
                                    color: textPrimary
                                }
                                
                                Text {
                                    text: "📞 " + (modelData.phone || "—")
                                    font.pixelSize: 12
                                    color: textSecondary
                                }
                                
                                Text {
                                    text: "🪪 Карта " + (modelData.card_number || "—")
                                    font.pixelSize: 12
                                    color: textSecondary
                                }
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: selectPatient(modelData)
                        }
                    }
                }
            }
            
            // Сообщение "не найдено"
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                visible: searchField.text.length >= 3 && searchResults.count === 0
                
                Text {
                    anchors.centerIn: parent
                    text: "😕 Ничего не найдено"
                    font.pixelSize: 14
                    color: textPlaceholder
                }
            }
            
            // // Кнопка новый пациент
            // Button {
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 48
            //     text: "+ Новый пациент"
            //     flat: true
                
            //     background: Rectangle {
            //         radius: 10
            //         color: "transparent"
            //         border.color: borderColor
            //         border.width: 1
            //     }
                
            //     contentItem: Text {
            //         text: parent.text
            //         font.pixelSize: 14
            //         color: primaryColor
            //         horizontalAlignment: Text.AlignHCenter
            //         verticalAlignment: Text.AlignVCenter
            //     }
                
            //     onClicked: openNewPatientDialog()
            // }
        }
    }
    
    // Правая панель - всегда занимает место справа
    Rectangle {
        id: rightPanel
        anchors.left: leftPanel.right
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: surfaceColor
        radius: 16
        clip: true

        // Содержимое когда пациент выбран
        ScrollView {
            anchors.fill: parent
            anchors.margins: 20
            clip: true
            visible: selectedPatient !== null
            
            contentWidth: availableWidth

            Column {
                width: parent.width
                spacing: 20

                // ============================================
                // 1. ИНФОРМАЦИЯ О ПАЦИЕНТЕ
                // ============================================
                
                Column {
                    width: parent.width
                    spacing: 8

                    RowLayout {
                        width: parent.width
                        
                        Text {
                            text: "📋 Информация о пациенте"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "✕"
                            flat: true
                            font.pixelSize: 16
                            onClicked: resetPatient()
                        }
                    }

                    InfoRow { label: "ФИО"; value: selectedPatient ? selectedPatient.full_name : "—" }
                    InfoRow { label: "Телефон"; value: selectedPatient ? selectedPatient.phone : "—" }
                    InfoRow { label: "Адрес"; value: selectedPatient ? selectedPatient.address : "—" }
                    InfoRow { label: "Участок"; value: selectedPatient && selectedPatient.district_number ? ("№" + selectedPatient.district_number) : "—" }
                }

                Divider {}

                // ============================================
                // 2. ТИП ПРИЕМА
                // ============================================
                
                // Column {
                //     width: parent.width
                //     spacing: 12

                //     Text {
                //         text: "📌 Тип приема"
                //         font.pixelSize: 16
                //         font.weight: Font.DemiBold
                //         color: textPrimary
                //     }

                //     Flow {
                //         width: parent.width
                //         spacing: 8

                //         Repeater {
                //             model: [
                //                 { text: "🩺 Первичный", value: "primary" },
                //                 { text: "🔄 Повторный", value: "repeat" },
                //                 { text: "🚨 Неотложный", value: "emergency" },
                //                 { text: "🏠 На дому", value: "home" }
                //             ]

                //             Rectangle {
                //                 width: 140
                //                 height: 44
                //                 radius: 22
                //                 color: appointmentType === modelData.value ? primaryColor : "transparent"
                //                 border.color: appointmentType === modelData.value ? primaryColor : borderColor
                //                 border.width: 1

                //                 Text {
                //                     anchors.centerIn: parent
                //                     text: modelData.text
                //                     font.pixelSize: 13
                //                     font.weight: Font.DemiBold
                //                     color: appointmentType === modelData.value ? "#FFFFFF" : textPrimary
                //                 }

                //                 MouseArea {
                //                     anchors.fill: parent
                //                     cursorShape: Qt.PointingHandCursor
                //                     onClicked: appointmentType = modelData.value
                //                 }
                //             }
                //         }
                //     }
                // }

                // Divider {}

                // ============================================
                // 3. ВЫБОР ВРАЧА
                // ============================================
                
                Column {
                    width: parent.width
                    spacing: 12

                    Text {
                        text: "👨‍⚕️ Врач"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: textPrimary
                    }

                    ListView {
                        id: doctorsList
                        width: parent.width
                        height: Math.min(300, doctorsList.count * 72)
                        model: []
                        spacing: 8
                        clip: true
                        interactive: true
                        boundsBehavior: Flickable.StopAtBounds
                        
                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 68
                            color: isDoctorSelected(modelData) ? "#E3F2FD" : (mouseAreaDoc.containsMouse ? bgColor : surfaceColor)
                            border.color: isDoctorSelected(modelData) ? primaryColor : borderColor
                            border.width: isDoctorSelected(modelData) ? 2 : 1
                            radius: 10

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12

                                Rectangle {
                                    width: 44
                                    height: 44
                                    radius: 22
                                    color: modelData.is_available ? successColor : textPlaceholder
                                    opacity: 0.15

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.is_available ? "✓" : "✗"
                                        font.pixelSize: 18
                                        color: modelData.is_available ? successColor : textPlaceholder
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData.doctor_name || "—"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                        color: textPrimary
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: (modelData.specialty_name || "—") + " · Каб. " + (modelData.room_number || "—")
                                        font.pixelSize: 12
                                        color: textSecondary
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }
                                }

                                Rectangle {
                                    width: 70
                                    height: 32
                                    radius: 16
                                    color: modelData.free_slots > 0 ? "#E8F5E9" : "#FFEBEE"
                                    visible: !isDoctorSelected(modelData)
                                    border.color: modelData.free_slots > 0 ? successColor : dangerColor
                                    border.width: 1

                                    RowLayout {
                                        anchors.centerIn: parent
                                        spacing: 4
                                        
                                        Text {
                                            text: "🎫"
                                            font.pixelSize: 13
                                        }
                                        
                                        Text {
                                            text: modelData.free_slots || 0
                                            font.pixelSize: 14
                                            font.weight: Font.DemiBold
                                            color: modelData.free_slots > 0 ? "#2E7D32" : "#C62828"
                                        }
                                    }
                                }
                            }

                            MouseArea {
                                id: mouseAreaDoc
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                enabled: modelData.is_available
                                onClicked: selectDoctor(modelData)
                            }
                        }
                    }
                }

                Divider { visible: selectedDoctor !== null }

                // ============================================
                // 4. ВЫБОР ВРЕМЕНИ С КАЛЕНДАРЁМ
                // ============================================
                
                Column {
                    width: parent.width
                    spacing: 16
                    visible: selectedDoctor !== null

                    Text {
                        text: "⏰ Время приёма"
                        font.pixelSize: 16
                        font.weight: Font.DemiBold
                        color: textPrimary
                    }

                    // Календарь
                    Rectangle {
                        width: parent.width
                        height: 80
                        color: "transparent"
                        
                        Row {
                            anchors.fill: parent
                            spacing: 8
                            
                            // Кнопка предыдущей недели
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: navLeftMouse.containsMouse ? primaryColor : "transparent"
                                border.color: navLeftMouse.containsMouse ? primaryColor : borderColor
                                border.width: 1
                                
                                Behavior on color { ColorAnimation { duration: 150 } }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "←"
                                    font.pixelSize: 16
                                    color: navLeftMouse.containsMouse ? "#FFFFFF" : textSecondary
                                }
                                
                                MouseArea {
                                    id: navLeftMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: changeWeek(-1)
                                }
                            }
                            
                            // Дни недели
                            Row {
                                width: parent.width - 88
                                height: parent.height
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 4
                                
                                Repeater {
                                    model: weekDays
                                    
                                    Rectangle {
                                        width: parent.width / 7 - 4
                                        height: 80
                                        color: {
                                            if (!modelData.isWorking) return bgColor
                                            if (isToday(modelData.date)) return primaryColor
                                            if (isSelected(modelData.date)) return "#E3F2FD"
                                            return "transparent"
                                        }
                                        opacity: modelData.isWorking ? 1 : 0.5
                                        radius: 12
                                        
                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 4
                                            
                                            Text {
                                                text: modelData.dayName
                                                font.pixelSize: 11
                                                color: {
                                                    if (!modelData.isWorking) return textPlaceholder
                                                    if (isToday(modelData.date)) return "#FFFFFF"
                                                    return textSecondary
                                                }
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                            
                                            Text {
                                                text: modelData.day
                                                font.pixelSize: 20
                                                font.weight: Font.DemiBold
                                                color: {
                                                    if (!modelData.isWorking) return textPlaceholder
                                                    if (isToday(modelData.date)) return "#FFFFFF"
                                                    if (isSelected(modelData.date)) return primaryColor
                                                    return textPrimary
                                                }
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                            
                                            Text {
                                                text: modelData.month
                                                font.pixelSize: 10
                                                color: {
                                                    if (!modelData.isWorking) return textPlaceholder
                                                    if (isToday(modelData.date)) return "#FFFFFF"
                                                    return textSecondary
                                                }
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                            
                                            Text {
                                                text: "✕"
                                                font.pixelSize: 12
                                                color: dangerColor
                                                visible: !modelData.isWorking
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }
                                        
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: modelData.isWorking ? Qt.PointingHandCursor : Qt.ArrowCursor
                                            onClicked: {
                                                if (modelData.isWorking) {
                                                    selectedDate = modelData.date
                                                    generateTimeSlots()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            // Кнопка следующей недели
                            Rectangle {
                                width: 36
                                height: 36
                                radius: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: navRightMouse.containsMouse ? primaryColor : "transparent"
                                border.color: navRightMouse.containsMouse ? primaryColor : borderColor
                                border.width: 1
                                
                                Behavior on color { ColorAnimation { duration: 150 } }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "→"
                                    font.pixelSize: 16
                                    color: navRightMouse.containsMouse ? "#FFFFFF" : textSecondary
                                }
                                
                                MouseArea {
                                    id: navRightMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: changeWeek(1)
                                }
                            }
                        }
                    }
                    
                    // Выбранная дата
                    Text {
                        text: "📅 " + Qt.formatDate(selectedDate, "dd MMMM yyyy, dddd")
                        font.pixelSize: 14
                        color: primaryColor
                        font.weight: Font.DemiBold
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Divider {}

                    // Сетка времени
                    Text {
                        text: "🕐 Доступное время"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                        color: textPrimary
                        visible: timeSlotsModel.length > 0
                    }

                    GridView {
                        width: parent.width
                        height: Math.ceil(timeSlotsModel.length / 3) * 52
                        cellWidth: width / 3
                        cellHeight: 52
                        model: timeSlotsModel
                        clip: true
                        interactive: false

                        delegate: Rectangle {
                            width: GridView.view.cellWidth - 8
                            height: GridView.view.cellHeight - 8
                            radius: 10
                            color: {
                                if (selectedTime === modelData.time) return primaryColor
                                if (!modelData.available) return "transparent"
                                return bgColor
                            }
                            border.color: {
                                if (selectedTime === modelData.time) return primaryColor
                                if (modelData.isPast) return "#E0E0E0"
                                if (modelData.available) return borderColor
                                return "#E0E0E0"
                            }
                            border.width: selectedTime === modelData.time ? 2 : 1
                            opacity: modelData.isPast ? 0.4 : (modelData.available ? 1 : 0.5)

                            Text {
                                anchors.centerIn: parent
                                text: modelData.time
                                font.pixelSize: 14
                                font.weight: selectedTime === modelData.time ? Font.DemiBold : Font.Normal
                                color: {
                                    if (selectedTime === modelData.time) return "#FFFFFF"
                                    if (modelData.isPast) return textPlaceholder
                                    if (modelData.available) return textPrimary
                                    return textPlaceholder
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                enabled: modelData.available && !modelData.isPast
                                cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: selectTimeSlot(modelData.time)
                            }
                        }
                    }
                    
                    Text {
                        text: "😕 Нет доступных слотов на выбранную дату"
                        font.pixelSize: 14
                        color: textPlaceholder
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: timeSlotsModel.length === 0
                    }
                }

                Divider { visible: selectedDoctor !== null && canCreateAppointment }

                // ============================================
                // 5. КНОПКИ ДЕЙСТВИЙ
                // ============================================
                
                RowLayout {
                    width: parent.width
                    spacing: 12
                    
                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        text: "Отмена"
                        flat: true
                        onClicked: resetForm()
                        
                        background: Rectangle {
                            radius: 10
                            color: "transparent"
                            border.color: borderColor
                            border.width: 1
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: textSecondary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    
                    Button {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48
                        text: "✅ Записать"
                        enabled: canCreateAppointment
                        onClicked: createAppointment()
                        
                        background: Rectangle {
                            radius: 10
                            color: parent.enabled ? primaryColor : textPlaceholder
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            color: "#FFFFFF"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Item { width: 1; height: 10 }
            }
        }

        // Пустое состояние
        Column {
            anchors.centerIn: parent
            spacing: 16
            visible: selectedPatient === null

            Text {
                text: "👈"
                font.pixelSize: 48
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Выберите пациента"
                font.pixelSize: 18
                font.weight: Font.DemiBold
                color: textPrimary
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: "Найдите пациента в списке слева\nили создайте нового"
                font.pixelSize: 14
                color: textSecondary
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // ============================================
    // COMPONENTS
    // ============================================
    
    component Divider: Rectangle {
        width: parent.width
        height: 1
        color: borderColor
    }
    
    component InfoRow: RowLayout {
        property string label: ""
        property string value: ""
        
        width: parent.width
        spacing: 8
        
        Text {
            text: label + ":"
            font.pixelSize: 13
            color: textSecondary
            Layout.preferredWidth: 80
        }
        
        Text {
            text: value || "—"
            font.pixelSize: 13
            color: textPrimary
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }
    }

        // ============================================
    // SUCCESS DIALOG
    // ============================================
    
    Dialog {
        id: successDialog
        width: 400
        height: 180
        anchors.centerIn: parent
        modal: true
        title: "✅ Успешно"
        standardButtons: Dialog.Ok
        
        property alias text: successText.text
        
        background: Rectangle {
            radius: 12
            color: surfaceColor
            border.color: successColor
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 20
            anchors.fill: parent
            anchors.margins: 20
            
            Text {
                id: successText
                font.pixelSize: 14
                color: textPrimary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
    
    // ============================================
    // ERROR DIALOG
    // ============================================
    
    Dialog {
        id: errorDialog
        width: 400
        height: 180
        anchors.centerIn: parent
        modal: true
        title: "❌ Ошибка"
        standardButtons: Dialog.Ok
        
        property alias text: errorText.text
        
        background: Rectangle {
            radius: 12
            color: surfaceColor
            border.color: dangerColor
            border.width: 2
        }
        
        contentItem: ColumnLayout {
            spacing: 20
            anchors.fill: parent
            anchors.margins: 20
            
            Text {
                id: errorText
                font.pixelSize: 14
                color: textPrimary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // ============================================
    // INTERNAL STATE
    // ============================================


    // ============================================
    // FUNCTIONS
    // ============================================
    
        // ============================================
    // FUNCTIONS (ВСЕ ФУНКЦИИ ДОЛЖНЫ БЫТЬ ЗДЕСЬ)
    // ============================================
    
    function performSearch() {
        if (searchField.text.length < 3) {
            searchResults.model = []
            return
        }
        
        try {
            var patients = PatientsByDistrictViewService.search([
                {"field": "full_name", "operator": "like", "value": "%" + searchField.text + "%"}
            ])
            
            if (patients.length === 0) {
                patients = PatientsByDistrictViewService.search([
                    {"field": "phone", "operator": "like", "value": "%" + searchField.text + "%"}
                ])
            }
            
            // Если и так не нашли, попробуем по номеру карты
            if (patients.length === 0) {
                patients = PatientsByDistrictViewService.search([
                    {"field": "card_number", "operator": "like", "value": "%" + searchField.text + "%"}
                ])
            }
            
            searchResults.model = patients
        } catch (e) {
            console.error("Search error:", e)
            searchResults.model = []
        }
    }
    
    function selectPatient(patient) {
        console.log("selectPatient called with:", patient.full_name)
        selectedPatient = patient
        
        if (patient.district_number) {
            loadDistrictDoctor(patient.district_number)
        }
        loadDoctors()
    }
    
    function loadDistrictDoctor(districtNumber) {
        try {
            var doctors = DoctorFullInfoViewService.search([
                {"field": "district_number", "operator": "eq", "value": districtNumber},
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            if (doctors.length > 0) {
                districtDoctor = doctors[0]
            }
        } catch (e) {
            console.error("Error loading district doctor:", e)
        }
    }
    
    function loadDoctors() {
        try {
            var doctors = DoctorFullInfoViewService.search([
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            
            for (var i = 0; i < doctors.length; i++) {
                doctors[i].is_available = true
                doctors[i].free_slots = 0  // Изначально 0, обновится при выборе врача
            }
            
            doctorsList.model = doctors
            
            if (districtDoctor && !presetHomeVisit) {
                selectDoctor(districtDoctor)
            }
        } catch (e) {
            console.error("Error loading doctors:", e)
        }
    }
    
    function selectDoctor(doctor) {
        console.log("selectDoctor called with:", doctor.doctor_name)
        console.log("Doctor object:", JSON.stringify(doctor))
        
        selectedDoctor = doctor
        selectedTime = ""
        
        var today = new Date()
        var day = today.getDay()
        var diff = day === 0 ? 6 : day - 1
        today.setDate(today.getDate() - diff)
        currentWeekStart = today
        
        updateWeekDays()
        
        selectedDate = new Date()
        generateTimeSlots()
    }
    
    function changeWeek(delta) {
        var newDate = new Date(currentWeekStart)
        newDate.setDate(newDate.getDate() + (delta * 7))
        currentWeekStart = newDate
        updateWeekDays()
    }
    
    function updateWeekDays() {
        if (!selectedDoctor) {
            weekDays = []
            return
        }
        
        var doctorId = selectedDoctor.doctor_id || selectedDoctor.id
        console.log("Updating week days for doctor ID:", doctorId)
        
        var days = []
        var start = new Date(currentWeekStart)
        var dayNames = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        var monthNames = ["Янв", "Фев", "Мар", "Апр", "Май", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
        
        for (var i = 0; i < 7; i++) {
            var date = new Date(start)
            date.setDate(start.getDate() + i)
            
            var isWorking = checkDoctorWorkingDay(date, doctorId)
            var dateStr = date.toISOString().split('T')[0]
            
            console.log("Date:", dateStr, "Day:", dayNames[i], "Working:", isWorking)
            
            days.push({
                date: date,
                day: date.getDate(),
                dayName: dayNames[i],
                month: monthNames[date.getMonth()],
                isWorking: isWorking
            })
        }
        
        weekDays = days
        console.log("Week days updated, working days:", days.filter(function(d) { return d.isWorking }).length)
    }
    
    function checkDoctorWorkingDay(date, doctorId) {
        try {
            var checkDate = new Date(date)
            checkDate.setHours(0, 0, 0, 0)
            
            var today = new Date()
            today.setHours(0, 0, 0, 0)
            
            var dateStr = checkDate.toISOString().split('T')[0]
            
            // 1. ПРОШЕДШИЕ ДНИ ВСЕГДА НЕРАБОЧИЕ (нельзя записаться в прошлое)
            if (checkDate < today) {
                console.log("Date", dateStr, "is in the past - NOT WORKING")
                return false
            }
            
            var dayOfWeek = checkDate.getDay() === 0 ? 7 : checkDate.getDay()
            
            // 2. Проверяем расписание
            var schedules = ScheduleService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctorId},
                {"field": "day_of_week", "operator": "eq", "value": dayOfWeek}
            ])
            
            if (schedules.length === 0) {
                console.log("No schedule for day:", dayOfWeek)
                return false
            }
            
            var schedule = schedules[0]
            
            // 3. Проверяем valid_from и valid_to
            var validFrom = new Date(schedule.valid_from)
            validFrom.setHours(0, 0, 0, 0)
            
            if (checkDate < validFrom) {
                console.log("Date", dateStr, "before valid_from")
                return false
            }
            
            if (schedule.valid_to) {
                var validTo = new Date(schedule.valid_to)
                validTo.setHours(0, 0, 0, 0)
                if (checkDate > validTo) {
                    console.log("Date after valid_to")
                    return false
                }
            }
            
            // 4. Проверяем исключения
            var exceptions = ScheduleExceptionService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctorId}
            ])
            
            for (var i = 0; i < exceptions.length; i++) {
                var ex = exceptions[i]
                var exStart = new Date(ex.exception_start_date)
                var exEnd = new Date(ex.exception_end_date)
                exStart.setHours(0, 0, 0, 0)
                exEnd.setHours(0, 0, 0, 0)
                
                if (checkDate >= exStart && checkDate <= exEnd) {
                    console.log("Exception active for", dateStr, "is_working:", ex.is_working)
                    return ex.is_working
                }
            }
            
            console.log("Date", dateStr, "is WORKING!")
            return true
            
        } catch (e) {
            console.error("Error checking doctor working day:", e)
            return false
        }
    }
    
    // function generateTimeSlots() {
    //     console.log("========== GENERATE TIME SLOTS ==========")
    //     console.log("1. selectedDoctor:", selectedDoctor ? selectedDoctor.doctor_name : "NULL")
    //     console.log("2. selectedDate:", selectedDate)
        
    //     var slots = []
        
    //     if (!selectedDoctor || !selectedDate) {
    //         console.log("❌ No doctor or date selected")
    //         timeSlotsModel = []
    //         return
    //     }
        
    //     try {
    //         var dayOfWeek = selectedDate.getDay() === 0 ? 7 : selectedDate.getDay()
    //         var doctorId = selectedDoctor.doctor_id || selectedDoctor.id
    //         var dateStr = selectedDate.toISOString().split('T')[0]
            
    //         // Текущее время
    //         var now = new Date()
    //         var todayStr = now.toISOString().split('T')[0]
    //         var isToday = (dateStr === todayStr)
    //         var currentMinutes = now.getHours() * 60 + now.getMinutes()

    //         console.log("3. Day of week:", dayOfWeek)
            
    //         // ВАЖНО: поле называется id, а не doctor_id!
    //         var doctorId = selectedDoctor.doctor_id || selectedDoctor.id
    //         console.log("4. Doctor ID:", doctorId)
            
    //         // 1. Получаем расписание врача на этот день
    //         var schedules = ScheduleService.search([
    //             {"field": "id_doctor", "operator": "eq", "value": doctorId},
    //             {"field": "day_of_week", "operator": "eq", "value": dayOfWeek}
    //         ])
            
    //         console.log("5. Found schedules:", schedules.length)
            
    //         if (schedules.length === 0) {
    //             console.log("❌ No schedule for this day")
    //             timeSlotsModel = []
    //             return
    //         }
            
    //         var schedule = schedules[0]
    //         selectedSchedule = schedule
    //         console.log("6. Schedule ID:", schedule.id)
    //         console.log("   start_time:", schedule.start_time)
    //         console.log("   end_time:", schedule.end_time)
    //         console.log("   valid_from:", schedule.valid_from)
    //         console.log("   valid_to:", schedule.valid_to)
            
    //         // 2. Проверяем валидность расписания по датам
    //         var checkDate = new Date(selectedDate)
    //         var validFrom = new Date(schedule.valid_from)
    //         var validTo = schedule.valid_to ? new Date(schedule.valid_to) : null
            
    //         console.log("7. Checking date validity:")
    //         console.log("   checkDate:", checkDate.toISOString().split('T')[0])
    //         console.log("   validFrom:", validFrom.toISOString().split('T')[0])
    //         console.log("   validTo:", validTo ? validTo.toISOString().split('T')[0] : "NULL")
            
    //         if (checkDate < validFrom) {
    //             console.log("❌ Date before valid_from")
    //             timeSlotsModel = []
    //             return
    //         }
            
    //         if (validTo && checkDate > validTo) {
    //             console.log("❌ Date after valid_to")
    //             timeSlotsModel = []
    //             return
    //         }
            
    //         console.log("✅ Date is within valid range")
            
    //         // 3. Проверяем исключения на эту дату
    //         console.log("8. Checking exceptions for doctor_id:", selectedDoctor.doctor_id || selectedDoctor.id)
        
    //         var exceptions = ScheduleExceptionService.search([
    //             {"field": "id_doctor", "operator": "eq", "value": selectedDoctor.doctor_id || selectedDoctor.id}
    //         ])
            
    //         console.log("9. Found exceptions:", exceptions.length)
        
    //         var activeException = null
    //         var dateStr = selectedDate.toISOString().split('T')[0]
            
    //         for (var i = 0; i < exceptions.length; i++) {
    //             var ex = exceptions[i]
                
    //             // ПРАВИЛЬНОЕ ПРЕОБРАЗОВАНИЕ ДАТЫ
    //             var exStart = new Date(ex.exception_start_date)
    //             var exEnd = new Date(ex.exception_end_date)
    //             var exStartStr = exStart.toISOString().split('T')[0]
    //             var exEndStr = exEnd.toISOString().split('T')[0]
                
    //             console.log("   Exception", i+1, ":", exStartStr, "-", exEndStr, "is_working:", ex.is_working, ex.reason)
                
    //             if (dateStr >= exStartStr && dateStr <= exEndStr) {
    //                 activeException = ex
    //                 console.log("   ✅ ACTIVE EXCEPTION:", ex.reason)
    //                 break
    //             }
    //         }
            
    //         // 4. Если есть исключение и врач не работает - слоты пустые
    //         if (activeException && !activeException.is_working) {
    //             console.log("❌ Doctor not working due to exception")
    //             timeSlotsModel = []
    //             return
    //         }
            
    //         // 5. Определяем время работы
    //         var startTime, endTime
            
    //         if (activeException && activeException.start_time) {
    //             startTime = new Date(dateStr + 'T' + activeException.start_time)
    //             endTime = new Date(dateStr + 'T' + activeException.end_time)
    //             console.log("10. Using exception times:", activeException.start_time, "-", activeException.end_time)
    //         } else {
    //             startTime = new Date(dateStr + 'T' + schedule.start_time)
    //             endTime = new Date(dateStr + 'T' + schedule.end_time)
    //             console.log("10. Using schedule times:", schedule.start_time, "-", schedule.end_time)
    //         }
            
    //         var startMinutes = startTime.getHours() * 60 + startTime.getMinutes()
    //         var endMinutes = endTime.getHours() * 60 + endTime.getMinutes()
            
    //         console.log("11. Time range in minutes:", startMinutes, "-", endMinutes)
    //         console.log("    Total minutes:", endMinutes - startMinutes)
    //         console.log("    Expected slots (15min):", Math.floor((endMinutes - startMinutes) / 15))
            
    //         // 6. Получаем существующие записи на этот день
    //         console.log("12. Searching appointments for schedule_id:", schedule.id)
            
    //         var appointments = AppointmentService.search([
    //             {"field": "id_schedule", "operator": "eq", "value": schedule.id}
    //         ])
            
    //         console.log("13. Found appointments:", appointments.length)
            
    //         // Создаём карту занятых слотов
    //         var bookedSlots = {}
            
    //         for (var j = 0; j < appointments.length; j++) {
    //             var appt = appointments[j]
    //             var apptDate = new Date(appt.appointment_time)
    //             var apptDateStr = apptDate.toISOString().split('T')[0]
                
    //             if (apptDateStr === dateStr && appt.status !== "cancelled") {
    //                 var timeStr = apptDate.getHours().toString().padStart(2, '0') + ":" + 
    //                               apptDate.getMinutes().toString().padStart(2, '0')
    //                 bookedSlots[timeStr] = true
    //                 console.log("   Booked slot:", timeStr, "status:", appt.status)
    //             }
    //         }
            
    //         console.log("14. Booked slots count:", Object.keys(bookedSlots).length)
            
    //         // 7. Генерируем слоты с интервалом 15 минут
    //         for (var minutes = startMinutes; minutes < endMinutes; minutes += 15) {
    //             var hours = Math.floor(minutes / 60)
    //             var mins = minutes % 60
    //             var timeStr = hours.toString().padStart(2, '0') + ":" + mins.toString().padStart(2, '0')
    //             var available = !bookedSlots[timeStr]
                
    //             slots.push({
    //                 time: timeStr,
    //                 available: available
    //             })
    //         }
            
    //         console.log("15. Generated slots:", slots.length)
    //         console.log("    Available slots:", slots.filter(function(s) { return s.available }).length)
    //         console.log("==========================================")
            
    //         timeSlotsModel = slots
            
    //     } catch (e) {
    //         console.error("❌ ERROR generating time slots:", e)
    //         timeSlotsModel = []
    //     }
    // }

    function generateTimeSlots() {
        console.log("========== GENERATE TIME SLOTS ==========")
        console.log("1. selectedDoctor:", selectedDoctor ? selectedDoctor.doctor_name : "NULL")
        console.log("2. selectedDate:", selectedDate)
        
        var slots = []
        
        if (!selectedDoctor || !selectedDate) {
            console.log("❌ No doctor or date selected")
            timeSlotsModel = []
            return
        }
        
        try {
            var dayOfWeek = selectedDate.getDay() === 0 ? 7 : selectedDate.getDay()
            console.log("3. Day of week:", dayOfWeek)
            
            var doctorId = selectedDoctor.doctor_id || selectedDoctor.id
            console.log("4. Doctor ID:", doctorId)
            
            // Получаем расписание врача на этот день
            var schedules = ScheduleService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctorId},
                {"field": "day_of_week", "operator": "eq", "value": dayOfWeek}
            ])
            
            console.log("5. Found schedules:", schedules.length)
            
            if (schedules.length === 0) {
                console.log("❌ No schedule for this day")
                timeSlotsModel = []
                return
            }
            
            var schedule = schedules[0]
            selectedSchedule = schedule
            
            // Проверяем валидность расписания по датам
            var checkDate = new Date(selectedDate)
            var validFrom = new Date(schedule.valid_from)
            var validTo = schedule.valid_to ? new Date(schedule.valid_to) : null
            
            if (checkDate < validFrom) {
                timeSlotsModel = []
                return
            }
            
            if (validTo && checkDate > validTo) {
                timeSlotsModel = []
                return
            }
            
            // Проверяем исключения
            var exceptions = ScheduleExceptionService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctorId}
            ])
            
            var dateStr = selectedDate.toISOString().split('T')[0]
            var activeException = null
            
            for (var i = 0; i < exceptions.length; i++) {
                var ex = exceptions[i]
                var exStart = new Date(ex.exception_start_date)
                var exEnd = new Date(ex.exception_end_date)
                var exStartStr = exStart.toISOString().split('T')[0]
                var exEndStr = exEnd.toISOString().split('T')[0]
                
                if (dateStr >= exStartStr && dateStr <= exEndStr) {
                    activeException = ex
                    break
                }
            }
            
            // Если исключение и врач не работает
            if (activeException && !activeException.is_working) {
                timeSlotsModel = []
                return
            }
            
            // Определяем время работы
            var startTime, endTime
            
            if (activeException && activeException.start_time) {
                startTime = new Date(dateStr + 'T' + activeException.start_time)
                endTime = new Date(dateStr + 'T' + activeException.end_time)
            } else {
                startTime = new Date(dateStr + 'T' + schedule.start_time)
                endTime = new Date(dateStr + 'T' + schedule.end_time)
            }
            
            var startMinutes = startTime.getHours() * 60 + startTime.getMinutes()
            var endMinutes = endTime.getHours() * 60 + endTime.getMinutes()
            
            // Текущее время (для проверки прошедших слотов)
            var now = new Date()
            var todayStr = now.toISOString().split('T')[0]
            var isToday = (dateStr === todayStr)
            var currentMinutes = now.getHours() * 60 + now.getMinutes()
            
            // Получаем существующие записи
            var appointments = AppointmentService.search([
                {"field": "id_schedule", "operator": "eq", "value": schedule.id}
            ])
            
            // Создаём карту занятых слотов
            var bookedSlots = {}
            
            for (var j = 0; j < appointments.length; j++) {
                var appt = appointments[j]
                var apptDate = new Date(appt.appointment_time)
                var apptDateStr = apptDate.toISOString().split('T')[0]
                
                if (apptDateStr === dateStr && appt.status !== "cancelled") {
                    var timeStr = apptDate.getHours().toString().padStart(2, '0') + ":" + 
                                apptDate.getMinutes().toString().padStart(2, '0')
                    bookedSlots[timeStr] = true
                }
            }
            
            // Генерируем слоты
            var totalSlots = 0
            var availableSlots = 0
            
            for (var minutes = startMinutes; minutes < endMinutes; minutes += 15) {
                var hours = Math.floor(minutes / 60)
                var mins = minutes % 60
                var timeStr = hours.toString().padStart(2, '0') + ":" + mins.toString().padStart(2, '0')
                
                totalSlots++
                
                // Проверяем, не прошло ли время (только для сегодня)
                var isPast = false
                if (isToday && minutes <= currentMinutes) {
                    isPast = true
                }
                
                var isBooked = bookedSlots[timeStr] || false
                var available = !isPast && !isBooked
                
                if (available) availableSlots++
                
                slots.push({
                    time: timeStr,
                    available: available,
                    isPast: isPast
                })
            }
            
            // Обновляем free_slots у выбранного врача
            if (selectedDoctor) {
                selectedDoctor.free_slots = availableSlots
            }
            
            console.log("Total:", totalSlots, "Available:", availableSlots)
            timeSlotsModel = slots
            
        } catch (e) {
            console.error("❌ ERROR:", e)
            timeSlotsModel = []
        }
    }
        
    function selectTimeSlot(time) {
        selectedTime = time
    }
    
    function isToday(date) {
        var today = new Date()
        var d = new Date(date)
        return d.getDate() === today.getDate() &&
               d.getMonth() === today.getMonth() &&
               d.getFullYear() === today.getFullYear()
    }
    
    function isSelected(date) {
        var d1 = new Date(date)
        var d2 = new Date(selectedDate)
        return d1.getDate() === d2.getDate() &&
               d1.getMonth() === d2.getMonth() &&
               d1.getFullYear() === d2.getFullYear()
    }
    
        // ============================================
    // FUNCTIONS
    // ============================================
    
    function createAppointment() {
        if (!canCreateAppointment) {
            console.log("Cannot create appointment: missing data")
            return
        }
        
        try {
            var dateStr = selectedDate.toISOString().split('T')[0]
            var appointmentDateTime = dateStr + 'T' + selectedTime + ':00'
            
            var appointment = {
                appointment_time: appointmentDateTime,
                status: "scheduled",
                id_patient: selectedPatient.id,
                id_schedule: selectedSchedule.id
            }
            
            console.log("Creating appointment:", JSON.stringify(appointment))
            
            var result = AppointmentService.add(appointment)
            
            if (result) {
                console.log("✅ Appointment created! ID:", result.id)
                successDialog.text = "Запись успешно создана!\nВремя: " + selectedTime + "\nВрач: " + selectedDoctor.doctor_name
                successDialog.open()
                resetForm()
            } else {
                errorDialog.text = "Не удалось создать запись"
                errorDialog.open()
            }
            
        } catch (e) {
            console.error("Error creating appointment:", e)
            errorDialog.text = "Ошибка: " + e
            errorDialog.open()
        }
    }
    
    function resetPatient() {
        selectedPatient = null
        selectedDoctor = null
        selectedTime = ""
        doctorsList.model = []
        timeSlotsModel = []
    }
    
    function resetForm() {
        searchField.text = ""
        searchResults.model = []
        resetPatient()
    }
    
    function openNewPatientDialog() {
        console.log("Open new patient dialog")
    }

    function isDoctorSelected(doctor) {
        if (!selectedDoctor || !doctor) return false
        
        var selId = selectedDoctor.doctor_id || selectedDoctor.id
        var docId = doctor.doctor_id || doctor.id
        
        return selId === docId
    }
    
    // ============================================
    // INITIALIZATION
    // ============================================
    
    Component.onCompleted: {
        selectedDate = new Date()
        
        if (presetPatient) {
            // Загружаем предустановленного пациента
            selectPatient(presetPatient)
        }
    }
}