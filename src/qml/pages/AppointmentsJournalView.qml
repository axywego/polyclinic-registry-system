import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Polyclinic.UI 1.0
import Appointment.Services 1.0
import AppointmentFullInfoView.Services 1.0
import DoctorFullInfoView.Services 1.0
import Patient.Services 1.0

Rectangle {
    id: root

    // ============================================
    // PROPERTIES
    // ============================================
    
    property int idPolyclinic: 0
    property date selectedDate: new Date()
    property string specialtyFilter: "all"
    property string doctorFilter: "all"
    property string patientFilter: "all"
    
    property var patientSuggestionsModel: []
    property var doctorSuggestionsModel: []
    property var allPatients: []
    property var allDoctors: []

    // Цветовая схема
    property color primaryColor: "#1976D2"
    property color successColor: "#4CAF50"
    property color warningColor: "#FF9800"
    property color dangerColor: "#F44336"
    property color purpleColor: "#9C27B0"
    property color grayColor: "#607D8B"
    
    property color backgroundColor: "#F5F7FA"
    property color surfaceColor: "#FFFFFF"
    property color borderColor: "#E0E6ED"
    property color textPrimary: "#2C3E50"
    property color textSecondary: "#7F8C8D"
    property color textLight: "#95A5A6"
    property color hoverColor: "#F0F4F8"
    
    property var appointmentsModel: []
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 20
    
    color: backgroundColor
    radius: 12

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 20

        // ============================================
        // HEADER WITH FILTERS
        // ============================================
        
            // ============================================
    // HEADER WITH FILTERS
    // ============================================
    
            // ============================================
    // HEADER WITH FILTERS
    // ============================================
    
            // ============================================
    // HEADER WITH FILTERS
    // ============================================
    
            // ============================================
    // HEADER WITH FILTERS
    // ============================================
    
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: surfaceColor
            radius: 12
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12
                
                Text {
                    text: "📋 Журнал записей"
                    font.pixelSize: 20
                    font.weight: Font.DemiBold
                    color: textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                // Фильтр по пациенту
                Rectangle {
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 40
                    radius: 8
                    color: backgroundColor
                    border.color: patientInput.activeFocus ? primaryColor : borderColor
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4
                        
                        TextField {
                            id: patientInput
                            Layout.fillWidth: true
                            placeholderText: "Пациент"
                            placeholderTextColor: textLight
                            font.pixelSize: 12
                            color: textPrimary
                            background: Item {}
                            leftPadding: 8
                            
                            onTextChanged: {
                                if (text.length >= 2) {
                                    filterPatients(text)
                                } else {
                                    patientSuggestionsModel = []
                                    patientSuggestions.visible = false
                                }
                            }
                        }
                        
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 4
                            color: clearPatientMouse.containsMouse ? dangerColor : "transparent"
                            visible: patientInput.text !== ""
                            
                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                font.pixelSize: 10
                                color: clearPatientMouse.containsMouse ? "#FFFFFF" : textSecondary
                            }
                            
                            MouseArea {
                                id: clearPatientMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    patientInput.text = ""
                                    patientFilter = "all"
                                    patientSuggestionsModel = []
                                    patientSuggestions.visible = false
                                }
                            }
                        }
                    }
                    
                    Popup {
                        id: patientSuggestions
                        y: parent.height + 4
                        width: parent.width
                        implicitHeight: Math.min(200, patientList.contentHeight)
                        padding: 6
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                        
                        background: Rectangle {
                            radius: 8
                            color: surfaceColor
                            border.color: borderColor
                        }
                        
                        contentItem: ListView {
                            id: patientList
                            clip: true
                            model: patientSuggestionsModel
                            spacing: 2
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 36
                                color: psMouse.containsMouse ? hoverColor : "transparent"
                                radius: 6
                                
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: 12
                                    text: modelData
                                    font.pixelSize: 12
                                    color: textPrimary
                                }
                                
                                MouseArea {
                                    id: psMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        patientInput.text = modelData
                                        patientFilter = modelData
                                        patientSuggestions.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Фильтр по врачу (ПОИСК С ПОДСКАЗКАМИ)
                Rectangle {
                    Layout.preferredWidth: 180
                    Layout.preferredHeight: 40
                    radius: 8
                    color: backgroundColor
                    border.color: doctorInput.activeFocus ? primaryColor : borderColor
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 4
                        spacing: 4
                        
                        TextField {
                            id: doctorInput
                            Layout.fillWidth: true
                            placeholderText: "Врач"
                            placeholderTextColor: textLight
                            font.pixelSize: 12
                            color: textPrimary
                            background: Item {}
                            leftPadding: 8
                            
                            onTextChanged: {
                                if (text.length >= 2) {
                                    filterDoctors(text)
                                } else {
                                    doctorSuggestionsModel = []
                                    doctorSuggestions.visible = false
                                }
                            }
                        }
                        
                        Rectangle {
                            width: 24
                            height: 24
                            radius: 4
                            color: clearDoctorMouse.containsMouse ? dangerColor : "transparent"
                            visible: doctorInput.text !== ""
                            
                            Text {
                                anchors.centerIn: parent
                                text: "✕"
                                font.pixelSize: 10
                                color: clearDoctorMouse.containsMouse ? "#FFFFFF" : textSecondary
                            }
                            
                            MouseArea {
                                id: clearDoctorMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    doctorInput.text = ""
                                    doctorFilter = "all"
                                    doctorSuggestionsModel = []
                                    doctorSuggestions.visible = false
                                }
                            }
                        }
                    }
                    
                    Popup {
                        id: doctorSuggestions
                        y: parent.height + 4
                        width: parent.width
                        implicitHeight: Math.min(200, doctorList.contentHeight)
                        padding: 6
                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                        
                        background: Rectangle {
                            radius: 8
                            color: surfaceColor
                            border.color: borderColor
                        }
                        
                        contentItem: ListView {
                            id: doctorList
                            clip: true
                            model: doctorSuggestionsModel
                            spacing: 2
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 36
                                color: dsMouse.containsMouse ? hoverColor : "transparent"
                                radius: 6
                                
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: 12
                                    text: modelData
                                    font.pixelSize: 12
                                    color: textPrimary
                                }
                                
                                MouseArea {
                                    id: dsMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        doctorInput.text = modelData
                                        doctorFilter = modelData
                                        doctorSuggestions.visible = false
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Фильтр по специальности (КОМБОБОКС)
                ComboBox {
                    id: specialtyCombo
                    model: ["Все специальности", "Терапевт", "Хирург", "Кардиолог", "Невролог", "Офтальмолог", "Педиатр"]
                    Layout.preferredWidth: 160
                    Layout.preferredHeight: 40
                    currentIndex: 0
                    
                    background: Rectangle {
                        radius: 8
                        color: backgroundColor
                        border.color: specialtyCombo.hovered ? primaryColor : borderColor
                        border.width: 1
                    }
                    
                    contentItem: Text {
                        text: specialtyCombo.currentText
                        font.pixelSize: 12
                        color: textPrimary
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 12
                    }
                    
                    indicator: Text {
                        text: "▼"
                        font.pixelSize: 10
                        color: textSecondary
                        anchors.right: parent.right
                        anchors.rightMargin: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                
                // Выбор даты
                Rectangle {
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 40
                    radius: 8
                    color: backgroundColor
                    border.color: dateMouseArea.containsMouse ? primaryColor : borderColor
                    border.width: 1
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 6
                        
                        Text {
                            text: "📅"
                            font.pixelSize: 14
                        }
                        
                        Text {
                            text: Qt.formatDate(selectedDate, "dd.MM.yyyy")
                            font.pixelSize: 12
                            color: textPrimary
                            Layout.fillWidth: true
                        }
                    }
                    
                    MouseArea {
                        id: dateMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: calendarPopup.open()
                    }
                }
                
                Button {
                    text: "🔄"
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    onClicked: refreshAppointments()
                    
                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? Qt.darker(primaryColor, 1.1) : primaryColor
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // ============================================
        // STATS BAR
        // ============================================
        
    // ============================================
    // STATS BAR
    // ============================================
    
        RowLayout {
            Layout.fillWidth: true
            spacing: 12
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: primaryColor
                        opacity: 0.15
                        
                        Text {
                            anchors.centerIn: parent
                            text: "📋"
                            font.pixelSize: 20
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Всего"
                            font.pixelSize: 12
                            color: textSecondary
                        }
                        
                        Text {
                            text: appointmentsModel.length
                            font.pixelSize: 22
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: successColor
                        opacity: 0.15
                        
                        Text {
                            anchors.centerIn: parent
                            text: "✅"
                            font.pixelSize: 20
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Выполнено"
                            font.pixelSize: 12
                            color: textSecondary
                        }
                        
                        Text {
                            text: getCountByStatus("completed")
                            font.pixelSize: 22
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: warningColor
                        opacity: 0.15
                        
                        Text {
                            anchors.centerIn: parent
                            text: "⏳"
                            font.pixelSize: 20
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Ожидают"
                            font.pixelSize: 12
                            color: textSecondary
                        }
                        
                        Text {
                            text: getCountByStatus("scheduled")
                            font.pixelSize: 22
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10
                    
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: dangerColor
                        opacity: 0.15
                        
                        Text {
                            anchors.centerIn: parent
                            text: "✗"
                            font.pixelSize: 20
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2
                        
                        Text {
                            text: "Отменено"
                            font.pixelSize: 12
                            color: textSecondary
                        }
                        
                        Text {
                            text: getCountByStatus("cancelled")
                            font.pixelSize: 22
                            font.weight: Font.DemiBold
                            color: textPrimary
                        }
                    }
                }
            }
        }

        // ============================================
        // APPOINTMENTS TABLE
        // ============================================
        
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: surfaceColor
            radius: 12
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 1
                spacing: 0
                
                                // Table Header
                                // Table Header
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 44
                    color: backgroundColor
                    radius: 8
                    
                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 0
                        
                        Rectangle { width: 70; height: 44; color: "transparent"; Label { text: "Время"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                        Rectangle { width: 200; height: 44; color: "transparent"; Label { text: "Пациент"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                        Rectangle { width: 140; height: 44; color: "transparent"; Label { text: "Телефон"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                        Rectangle { width: 180; height: 44; color: "transparent"; Label { text: "Врач"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                        Rectangle { width: 60; height: 44; color: "transparent"; Label { text: "Каб."; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                        Rectangle { width: 40; height: 44; color: "transparent"; Label { text: ""; anchors.centerIn: parent } }
                    }
                }
                
                // Table Body
                                // Table Body
                                // Table Body
                ListView {
                    id: appointmentsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: appointmentsModel
                    spacing: 4
                    
                    ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                    
                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 52
                        color: rowMouseArea.containsMouse ? hoverColor : (index % 2 === 0 ? "#FAFAFA" : "transparent")
                        radius: 8
                        
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0
                            
                            Rectangle {
                                width: 70
                                height: 52
                                color: "transparent"
                                Text {
                                    text: Qt.formatDateTime(modelData.appointment_time, "HH:mm")
                                    anchors.centerIn: parent
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: primaryColor
                                }
                            }
                            
                            Rectangle {
                                width: 200
                                height: 52
                                color: "transparent"
                                Text {
                                    text: modelData.patient_name || "—"
                                    anchors.centerIn: parent
                                    width: parent.width - 8
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: "#1A1A1A"
                                    elide: Text.ElideRight
                                }
                            }
                            
                            Rectangle {
                                width: 140
                                height: 52
                                color: "transparent"
                                Text {
                                    text: modelData.patient_phone || "—"
                                    anchors.centerIn: parent
                                    width: parent.width - 8
                                    font.pixelSize: 12
                                    color: "#555555"
                                    elide: Text.ElideRight
                                }
                            }
                            
                            Rectangle {
                                width: 180
                                height: 52
                                color: "transparent"
                                Text {
                                    text: modelData.doctor_name || "—"
                                    anchors.centerIn: parent
                                    width: parent.width - 8
                                    font.pixelSize: 13
                                    color: "#1A1A1A"
                                    elide: Text.ElideRight
                                }
                            }
                            
                            Rectangle {
                                width: 60
                                height: 52
                                color: "transparent"
                                Text {
                                    text: modelData.room_number || "—"
                                    anchors.centerIn: parent
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: primaryColor
                                }
                            }
                            
                            // Кнопка удаления
                            Rectangle {
                                width: 40
                                height: 52
                                color: "transparent"
                                
                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 6
                                    color: deleteBtnMouse.containsMouse ? dangerColor : "transparent"
                                    border.color: dangerColor
                                    border.width: 1
                                    anchors.centerIn: parent
                                    
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "✕"
                                        font.pixelSize: 14
                                        font.weight: Font.DemiBold
                                        color: deleteBtnMouse.containsMouse ? "#FFFFFF" : dangerColor
                                    }
                                    
                                    MouseArea {
                                        id: deleteBtnMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            console.log("Delete clicked for appointment:", modelData.appointment_id)
                                            deleteAppointment(modelData.appointment_id)
                                        }
                                    }
                                }
                            }
                        }
                        
                        MouseArea {
                            id: rowMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            // Не перехватываем клики, чтобы кнопка удаления работала
                            acceptedButtons: Qt.NoButton
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Нет записей на " + Qt.formatDate(selectedDate, "dd.MM.yyyy")
                        font.pixelSize: 14
                        color: textLight
                        visible: appointmentsList.count === 0
                    }
                }
            }
        }
    }

    // ============================================
    // CALENDAR POPUP
    // ============================================
    
        // ============================================
    // CALENDAR POPUP
    // ============================================
    
        // ============================================
    // CALENDAR POPUP
    // ============================================
    
    Popup {
        id: calendarPopup
        y: 110
        x: parent.width - 320
        width: 300
        height: 340
        padding: 16
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        
        background: Rectangle {
            radius: 12
            color: surfaceColor
            border.color: borderColor
        }
        
        contentItem: ColumnLayout {
            spacing: 16
            
            // Месяц и стрелки
            RowLayout {
                Layout.fillWidth: true
                
                // Кнопка назад
                Rectangle {
                    width: 36
                    height: 36
                    radius: 10
                    color: prevMouse.containsMouse ? primaryColor : "transparent"
                    border.color: prevMouse.containsMouse ? primaryColor : borderColor
                    border.width: 1
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "←"
                        font.pixelSize: 16
                        color: prevMouse.containsMouse ? "#FFFFFF" : textSecondary
                    }
                    
                    MouseArea {
                        id: prevMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            calendarMonth--
                            if (calendarMonth < 0) {
                                calendarMonth = 11
                                calendarYear--
                            }
                            updateCalendar()
                        }
                    }
                }
                
                Label {
                    text: getMonthName(calendarMonth) + " " + calendarYear
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: textPrimary
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
                
                // Кнопка вперёд
                Rectangle {
                    width: 36
                    height: 36
                    radius: 10
                    color: nextMouse.containsMouse ? primaryColor : "transparent"
                    border.color: nextMouse.containsMouse ? primaryColor : borderColor
                    border.width: 1
                    
                    Behavior on color { ColorAnimation { duration: 150 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "→"
                        font.pixelSize: 16
                        color: nextMouse.containsMouse ? "#FFFFFF" : textSecondary
                    }
                    
                    MouseArea {
                        id: nextMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            calendarMonth++
                            if (calendarMonth > 11) {
                                calendarMonth = 0
                                calendarYear++
                            }
                            updateCalendar()
                        }
                    }
                }
            }
            
            // Дни недели
            Row {
                Layout.fillWidth: true
                spacing: 0
                
                Repeater {
                    model: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
                    
                    Label {
                        width: (calendarPopup.width - 32) / 7
                        text: modelData
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        color: textSecondary
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
            
            // Сетка дней
            Grid {
                Layout.fillWidth: true
                columns: 7
                rowSpacing: 4
                columnSpacing: 4
                
                Repeater {
                    model: calendarDays
                    
                    Rectangle {
                        width: (calendarPopup.width - 56) / 7
                        height: 34
                        radius: 17
                        color: {
                            if (!modelData.inMonth) return "transparent"
                            if (isSameDate(modelData.date, root.selectedDate)) return primaryColor
                            if (dayMouse.containsMouse) return hoverColor
                            return "transparent"
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData.day
                            font.pixelSize: 12
                            color: {
                                if (!modelData.inMonth) return textLight
                                if (isSameDate(modelData.date, root.selectedDate)) return "#FFFFFF"
                                return textPrimary
                            }
                        }
                        
                        MouseArea {
                            id: dayMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: modelData.inMonth
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.selectedDate = modelData.date
                                calendarPopup.close()
                                refreshAppointments()
                            }
                        }
                    }
                }
            }
            
            // Кнопка "Сегодня"
            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: 10
                color: todayMouse.containsMouse ? hoverColor : "transparent"
                border.color: borderColor
                border.width: 1
                
                Behavior on color { ColorAnimation { duration: 150 } }
                
                Text {
                    anchors.centerIn: parent
                    text: "Сегодня"
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: primaryColor
                }
                
                MouseArea {
                    id: todayMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.selectedDate = new Date()
                        calendarMonth = root.selectedDate.getMonth()
                        calendarYear = root.selectedDate.getFullYear()
                        updateCalendar()
                        calendarPopup.close()
                        refreshAppointments()
                    }
                }
            }
        }
    }

    // ============================================
    // CALENDAR PROPERTIES
    // ============================================
    
    property int calendarYear: selectedDate.getFullYear()
    property int calendarMonth: selectedDate.getMonth()
    property var calendarDays: []

    function deleteAppointment(id) {
        try {
            AppointmentService.remove(id)
            console.log("Appointment deleted:", id)
            refreshAppointments()
        } catch (e) {
            console.error("Error deleting appointment:", e)
        }
    }

    function loadAllPatients() {
        try {
            var patients = PatientService.search([])
            allPatients = []
            for (var i = 0; i < patients.length; i++) {
                var displayName = patients[i].full_name
                if (patients[i].card_number) {
                    displayName += " (" + patients[i].card_number + ")"
                }
                allPatients.push(displayName)
            }
            allPatients.sort()
        } catch (e) {
            console.error("Error loading patients:", e)
        }
    }

    function filterPatients(text) {
        var filtered = []
        var searchText = text.toLowerCase()
        
        for (var i = 0; i < allPatients.length; i++) {
            if (allPatients[i].toLowerCase().indexOf(searchText) !== -1) {
                filtered.push(allPatients[i])
            }
        }
        
        patientSuggestionsModel = filtered
        patientSuggestions.visible = filtered.length > 0
    }

    function applyDoctorFilter() {
        if (doctorInput.text.length > 0) {
            doctorFilter = doctorInput.text
        } else {
            doctorFilter = "all"
        }
        refreshAppointments()
    }
    
    function updateCalendar() {
        var days = []
        var firstDay = new Date(calendarYear, calendarMonth, 1)
        var startDay = new Date(firstDay)
        var firstDayOfWeek = firstDay.getDay() || 7
        startDay.setDate(1 - firstDayOfWeek + 1)
        
        for (var i = 0; i < 42; i++) {
            var date = new Date(startDay)
            date.setDate(startDay.getDate() + i)
            days.push({
                date: date,
                day: date.getDate(),
                inMonth: date.getMonth() === calendarMonth
            })
        }
        
        calendarDays = days
    }
    
    function getMonthName(month) {
        var months = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
                      "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
        return months[month]
    }
    
    // ============================================
    // FUNCTIONS
    // ============================================
    
    function getStatusColor(status) {
        switch (status) {
            case "scheduled": return primaryColor
            case "confirmed": return successColor
            case "completed": return grayColor
            case "cancelled": return dangerColor
            case "no_show": return purpleColor
            default: return grayColor
        }
    }
    
    function getStatusText(status) {
        switch (status) {
            case "scheduled": return "Записан"
            case "confirmed": return "Подтвержден"
            case "completed": return "Выполнен"
            case "cancelled": return "Отменен"
            case "no_show": return "Неявка"
            default: return status
        }
    }
    
    function getCountByStatus(status) {
        var count = 0
        for (var i = 0; i < appointmentsModel.length; i++) {
            if (appointmentsModel[i].status === status) count++
        }
        return count
    }
    
    function loadAppointments() {
        try {
            var filters = [
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ]
            
            var appointments = AppointmentFullInfoViewService.search(filters)
            
            var filtered = []
            var now = new Date()
            
            for (var i = 0; i < appointments.length; i++) {
                var appt = appointments[i]
                
                // Фильтр по дате
                if (!isSameDate(appt.appointment_time, selectedDate)) continue
                
                // Фильтр по врачу
                if (doctorFilter !== "all") {
                    var doctorName = appt.doctor_name || ""
                    if (doctorName.toLowerCase().indexOf(doctorFilter.toLowerCase()) === -1) continue
                }
                
                // Фильтр по пациенту
                if (patientFilter !== "all") {
                    var patientDisplay = appt.patient_name || ""
                    if (appt.card_number) patientDisplay += " (" + appt.card_number + ")"
                    if (patientDisplay.toLowerCase().indexOf(patientFilter.toLowerCase()) === -1) continue
                }
                
                // Автоматически определяем статус
                var apptTime = new Date(appt.appointment_time)
                appt.status = apptTime < now ? "completed" : "scheduled"
                
                filtered.push(appt)
            }
            
            filtered.sort(function(a, b) {
                return new Date(a.appointment_time) - new Date(b.appointment_time)
            })
            
            return filtered
        } catch (e) {
            console.error("Error loading appointments:", e)
            return []
        }
    }

    function loadAllDoctors() {
        try {
            var doctors = DoctorFullInfoViewService.search([
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            
            allDoctors = []
            for (var i = 0; i < doctors.length; i++) {
                if (allDoctors.indexOf(doctors[i].doctor_name) === -1) {
                    allDoctors.push(doctors[i].doctor_name)
                }
            }
            allDoctors.sort()
        } catch (e) {
            console.error("Error loading doctors:", e)
        }
    }
    
    function filterDoctors(text) {
        var filtered = []
        var searchText = text.toLowerCase()
        
        for (var i = 0; i < allDoctors.length; i++) {
            if (allDoctors[i].toLowerCase().indexOf(searchText) !== -1) {
                filtered.push(allDoctors[i])
            }
        }
        
        doctorSuggestionsModel = filtered
        doctorSuggestions.visible = filtered.length > 0
    }
    
    function isSameDate(date1, date2) {
        var d1 = new Date(date1)
        var d2 = new Date(date2)
        return d1.getDate() === d2.getDate() &&
               d1.getMonth() === d2.getMonth() &&
               d1.getFullYear() === d2.getFullYear()
    }
    
    function refreshAppointments() {
        // Применяем фильтры
        patientFilter = patientInput.text.length > 0 ? patientInput.text : "all"
        doctorFilter = doctorInput.text.length > 0 ? doctorInput.text : "all"
        
        appointmentsModel = loadAppointments()
    }
    
    function markAsCompleted(id) { console.log("Mark as completed:", id) }
    function cancelAppointment(id) { console.log("Cancel appointment:", id) }
    function printTicket(id) { console.log("Print ticket:", id) }
    
    Component.onCompleted: {
        loadAllPatients()
        loadAllDoctors()
        updateCalendar()
        refreshAppointments()
    }
}