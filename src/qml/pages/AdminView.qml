import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Polyclinic.UI 1.0
import Doctor.Services 1.0
import Patient.Services 1.0
import MedicalCard.Services 1.0
import Schedule.Services 1.0
import ScheduleException.Services 1.0
import Room.Services 1.0
import Specialty.Services 1.0
import Department.Services 1.0
import District.Services 1.0
import Street.Services 1.0
import Registrar.Services 1.0
import DoctorFullInfoView.Services 1.0

Rectangle {
    id: root
    
    property int idPolyclinic: 0
    
    // Цветовая схема
    property color primaryColor: "#9C27B0"
    property color successColor: "#4CAF50"
    property color warningColor: "#FF9800"
    property color dangerColor: "#F44336"
    property color bgColor: "#F8F9FA"
    property color surfaceColor: "#FFFFFF"
    property color borderColor: "#DEE2E6"
    property color textPrimary: "#212529"
    property color textSecondary: "#6C757D"
    property color inputBgColor: "#FFFFFF"
    
    // Модели данных
    property var doctorsModel: []
    property var patientsModel: []
    property var schedulesModel: []
    property var specialtiesModel: []
    property var departmentsModel: []
    property var districtsModel: []
    property var roomsModel: []
    property var diseasesModel: []
    
    // Состояние загрузки
    property bool isLoading: false
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: bgColor
    
    Component.onCompleted: {
        loadSpecialties()
        loadDepartments()
        loadRooms()
        loadDistricts()
        loadDoctors()
        loadPatients()
        loadSchedules()
    }
    
    // ============================================
    // ФУНКЦИИ ЗАГРУЗКИ ДАННЫХ
    // ============================================
    
    function loadSpecialties() {
        try {
            specialtiesModel = SpecialtyService.getAll() || []
            console.log("Загружено специальностей:", specialtiesModel.length)
        } catch(e) {
            console.error("Ошибка загрузки специальностей:", e)
            specialtiesModel = []
        }
    }
    
    function loadDepartments() {
        try {
            departmentsModel = DepartmentService.getAll() || []
            console.log("Загружено отделений:", departmentsModel.length)
        } catch(e) {
            console.error("Ошибка загрузки отделений:", e)
            departmentsModel = []
        }
    }
    
    function loadRooms() {
        try {
            roomsModel = RoomService.getAll() || []
            console.log("Загружено кабинетов:", roomsModel.length)
        } catch(e) {
            console.error("Ошибка загрузки кабинетов:", e)
            roomsModel = []
        }
    }
    
    function loadDistricts() {
        try {
            districtsModel = DistrictService.getAll() || []
            console.log("Загружено участков:", districtsModel.length)
        } catch(e) {
            console.error("Ошибка загрузки участков:", e)
            districtsModel = []
        }
    }
    
    function loadDoctors() {
        try {
            isLoading = true
            doctorsModel = DoctorFullInfoViewService.search([
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ]) || []
            console.log("Загружено врачей:", doctorsModel.length)
        } catch(e) {
            console.error("Ошибка загрузки врачей:", e)
            doctorsModel = []
        } finally {
            isLoading = false
        }
    }
    
    function loadPatients() {
        try {
            isLoading = true
            var patients = PatientService.getAll() || []
            
            for (var i = 0; i < patients.length; i++) {
                try {
                    var cards = MedicalCardService.search([
                        {"field": "id_patient", "operator": "eq", "value": patients[i].id}
                    ])
                    if (cards.length > 0) {
                        patients[i].card_number = cards[0].card_number
                        patients[i].blood_group = cards[0].blood_group
                        patients[i].allergies = cards[0].allergies
                        patients[i].chronic_diseases = cards[0].chronic_diseases
                        patients[i].shelf_number = cards[0].shelf_number
                        patients[i].row_number = cards[0].row_number
                        patients[i].color_marking = cards[0].color_marking
                    } else {
                        patients[i].card_number = "—"
                    }
                } catch(e) {}
            }
            
            patientsModel = patients
            console.log("Загружено пациентов:", patientsModel.length)
        } catch(e) {
            console.error("Ошибка загрузки пациентов:", e)
            patientsModel = []
        } finally {
            isLoading = false
        }
    }
    
    function loadSchedules() {
        try {
            isLoading = true
            var schedules = ScheduleService.getAll() || []
            
            for (var i = 0; i < schedules.length; i++) {
                try {
                    var doctors = DoctorService.search([
                        {"field": "id", "operator": "eq", "value": schedules[i].id_doctor}
                    ])
                    if (doctors.length > 0) {
                        schedules[i].doctor_name = doctors[0].full_name
                    } else {
                        schedules[i].doctor_name = "—"
                    }
                } catch(e) {}
            }
            
            schedulesModel = schedules
            console.log("Загружено расписаний:", schedulesModel.length)
        } catch(e) {
            console.error("Ошибка загрузки расписаний:", e)
            schedulesModel = []
        } finally {
            isLoading = false
        }
    }
    
    function getDayName(dayNum) {
        var days = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
        return days[dayNum - 1] || "—"
    }
    
    function formatDateShort(dateValue) {
        if (!dateValue) return "—"
        
        // Если это объект Date
        if (typeof dateValue === "object" && dateValue.getDate) {
            var d = dateValue.getDate().toString().padStart(2, '0')
            var m = (dateValue.getMonth() + 1).toString().padStart(2, '0')
            var y = dateValue.getFullYear()
            return d + "." + m + "." + y
        }
        
        // Если это строка
        if (typeof dateValue === "string") {
            if (dateValue.indexOf("-") !== -1) {
                var parts = dateValue.split("-")
                return parts[2] + "." + parts[1] + "." + parts[0]
            }
            if (dateValue.indexOf(".") !== -1) {
                return dateValue
            }
        }
        
        return dateValue.toString()
    }
    
    function formatDateForDb(dateStr) {
        if (!dateStr) return ""
        
        // Если уже в формате YYYY-MM-DD
        if (dateStr.indexOf("-") !== -1 && dateStr.length === 10) {
            return dateStr
        }
        
        // Если в формате DD.MM.YYYY
        if (dateStr.indexOf(".") !== -1) {
            var parts = dateStr.split(".")
            if (parts.length === 3) {
                return parts[2] + "-" + parts[1].padStart(2, '0') + "-" + parts[0].padStart(2, '0')
            }
        }
        
        return dateStr
    }

    function showSuccess(msg) { successSnackbar.text = msg; successSnackbar.open() }
    function showError(msg) { errorSnackbar.text = msg; errorSnackbar.open() }
    
    // ============================================
    // КОМПОНЕНТ СТИЛИЗОВАННОГО ПОЛЯ ВВОДА
    // ============================================
    
    Component {
        id: styledTextField
        TextField {
            font.pixelSize: 14
            color: textPrimary
            selectionColor: primaryColor
            selectByMouse: true
            background: Rectangle {
                radius: 8
                color: inputBgColor
                border.color: parent.activeFocus ? primaryColor : borderColor
                border.width: parent.activeFocus ? 2 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }
            }
        }
    }
    
    Component {
        id: styledTextArea
        TextArea {
            font.pixelSize: 14
            color: textPrimary
            selectionColor: primaryColor
            selectByMouse: true
            wrapMode: Text.WordWrap
            background: Rectangle {
                radius: 8
                color: inputBgColor
                border.color: parent.activeFocus ? primaryColor : borderColor
                border.width: parent.activeFocus ? 2 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }
            }
        }
    }
    
    Component {
        id: styledComboBox
        ComboBox {
            font.pixelSize: 14
            background: Rectangle {
                radius: 8
                color: inputBgColor
                border.color: parent.activeFocus ? primaryColor : borderColor
                border.width: parent.activeFocus ? 2 : 1
                Behavior on border.color { ColorAnimation { duration: 150 } }
            }
            indicator: Text {
                text: "▼"
                font.pixelSize: 12
                color: textSecondary
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
            }
            contentItem: Text {
                text: parent.displayText
                font.pixelSize: 14
                color: textPrimary
                verticalAlignment: Text.AlignVCenter
                leftPadding: 12
                rightPadding: 32
                elide: Text.ElideRight
            }
        }
    }
    
    // ============================================
    // КОМПОНЕНТЫ УВЕДОМЛЕНИЙ
    // ============================================
    
    Popup {
        id: successSnackbar
        width: 300
        height: 50
        x: (root.width - width) / 2
        y: root.height - 80
        padding: 0
        closePolicy: Popup.CloseOnEscape
        property alias text: successText.text
        background: Rectangle { radius: 10; color: successColor }
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
        x: (root.width - width) / 2
        y: root.height - 80
        padding: 0
        closePolicy: Popup.CloseOnEscape
        property alias text: errorText.text
        background: Rectangle { radius: 10; color: dangerColor }
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
    
    // ============================================
    // ДИАЛОГ ПОДТВЕРЖДЕНИЯ УДАЛЕНИЯ
    // ============================================
    
    Dialog {
        id: confirmDialog
        width: 400
        height: 200
        anchors.centerIn: parent
        modal: true
        title: "Подтверждение удаления"
        property string itemType: ""
        property int itemId: -1
        
        background: Rectangle { radius: 12; color: surfaceColor; border.color: borderColor; border.width: 1 }
        
        contentItem: ColumnLayout {
            spacing: 20
            anchors.fill: parent
            anchors.margins: 20
            
            Text {
                text: "Вы уверены, что хотите удалить " + confirmDialog.itemType + "?"
                font.pixelSize: 14
                color: textPrimary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    text: "Отмена"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    onClicked: confirmDialog.close()
                    background: Rectangle {
                        radius: 8
                        color: "transparent"
                        border.color: borderColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: textSecondary
                        font.pixelSize: 13
                    }
                }
                
                Button {
                    text: "Удалить"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    background: Rectangle {
                        radius: 8
                        color: dangerColor
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: 13
                        font.weight: Font.DemiBold
                    }
                    onClicked: {
                        if (confirmDialog.itemType === "врача") {
                            deleteDoctor(confirmDialog.itemId)
                        } else if (confirmDialog.itemType === "пациента") {
                            deletePatient(confirmDialog.itemId)
                        } else if (confirmDialog.itemType === "расписания") {
                            deleteSchedule(confirmDialog.itemId)
                        }
                        confirmDialog.close()
                    }
                }
            }
        }
    }
    
    // ============================================
    // ОСНОВНОЙ ИНТЕРФЕЙС
    // ============================================
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        
        // Заголовок
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: surfaceColor
            radius: 12
            border.color: borderColor
            border.width: 1
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                
                Text {
                    text: "👑 Административная панель"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    color: textPrimary
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "🔄 Обновить"
                    Layout.preferredHeight: 36
                    onClicked: {
                        loadDoctors()
                        loadPatients()
                        loadSchedules()
                    }
                    background: Rectangle {
                        radius: 8
                        color: parent.hovered ? Qt.lighter(primaryColor, 1.1) : primaryColor
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#FFFFFF"
                        font.pixelSize: 12
                    }
                }
            }
        }
        
        // Вкладки
        TabBar {
            id: tabBar
            Layout.fillWidth: true
            background: Rectangle { color: "transparent" }
            
            TabButton {
                text: "📅 Расписания"
                width: 140
                height: 40
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: parent.checked ? primaryColor : textSecondary
                }
                background: Rectangle {
                    color: "transparent"
                    border.color: parent.checked ? primaryColor : "transparent"
                    border.width: 2
                }
            }
            TabButton {
                text: "👤 Пациенты"
                width: 140
                height: 40
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: parent.checked ? primaryColor : textSecondary
                }
                background: Rectangle {
                    color: "transparent"
                    border.color: parent.checked ? primaryColor : "transparent"
                    border.width: 2
                }
            }
            TabButton {
                text: "👨‍⚕️ Врачи"
                width: 140
                height: 40
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                    color: parent.checked ? primaryColor : textSecondary
                }
                background: Rectangle {
                    color: "transparent"
                    border.color: parent.checked ? primaryColor : "transparent"
                    border.width: 2
                }
            }
        }
        
        // Контент вкладок
        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex
            
            // ============================================
            // ВКЛАДКА 1: РАСПИСАНИЯ
            // ============================================
            Rectangle {
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "📅 Управление расписаниями"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                            Layout.fillWidth: true
                        }
                        
                        Button {
                            text: "+ Добавить расписание"
                            Layout.preferredHeight: 36
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(successColor, 1.1) : successColor
                            }
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                            }
                            onClicked: openAddScheduleDialog()
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        
                        ListView {
                            id: schedulesListView
                            width: parent.width
                            model: schedulesModel
                            spacing: 8
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 140
                                color: mouseArea.containsMouse ? "#FAFAFA" : "transparent"
                                radius: 8
                                border.color: borderColor
                                border.width: 1
                                
                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 6
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        
                                        Text {
                                            text: "👨‍⚕️ " + (modelData.doctor_name || "Врач ID: " + modelData.id_doctor)
                                            font.pixelSize: 14
                                            font.weight: Font.DemiBold
                                            color: textPrimary
                                            Layout.fillWidth: true
                                        }
                                        
                                        Text {
                                            text: "ID: " + modelData.id
                                            font.pixelSize: 10
                                            color: textSecondary
                                        }
                                    }
                                    
                                    Text {
                                        text: "📅 " + getDayName(modelData.day_of_week) + " | 🕐 " + (modelData.start_time || "—") + " - " + (modelData.end_time || "—")
                                        font.pixelSize: 12
                                        color: textSecondary
                                    }
                                    
                                    Text {
                                        text: "📆 Действует: " + formatDateShort(modelData.valid_from) + (modelData.valid_to ? " — " + formatDateShort(modelData.valid_to) : " — бессрочно")
                                        font.pixelSize: 11
                                        color: successColor
                                    }
                                    
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 8
                                        
                                        // Кнопка редактирования
                                        Rectangle {
                                            height: 32
                                            Layout.fillWidth: true
                                            radius: 6
                                            color: editBtnMouse.containsMouse ? primaryColor : "transparent"
                                            border.color: primaryColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✏️ Редактировать"
                                                font.pixelSize: 11
                                                color: editBtnMouse.containsMouse ? "#FFFFFF" : primaryColor
                                            }
                                            
                                            MouseArea {
                                                id: editBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("✏️ РЕДАКТИРОВАНИЕ РАСПИСАНИЯ ID:", modelData.id)
                                                    editSchedule(modelData)
                                                }
                                            }
                                        }
                                        
                                        // Кнопка исключения
                                        Rectangle {
                                            height: 32
                                            Layout.fillWidth: true
                                            radius: 6
                                            color: exceptionBtnMouse.containsMouse ? warningColor : "transparent"
                                            border.color: warningColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "📅 Исключение"
                                                font.pixelSize: 11
                                                color: exceptionBtnMouse.containsMouse ? "#FFFFFF" : warningColor
                                            }
                                            
                                            MouseArea {
                                                id: exceptionBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("📅 ИСКЛЮЧЕНИЕ ДЛЯ РАСПИСАНИЯ ID:", modelData.id)
                                                    openExceptionDialog(modelData)
                                                }
                                            }
                                        }
                                        
                                        // Кнопка удаления
                                        Rectangle {
                                            height: 32
                                            Layout.fillWidth: true
                                            radius: 6
                                            color: deleteBtnMouse.containsMouse ? dangerColor : "transparent"
                                            border.color: dangerColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "🗑️ Удалить"
                                                font.pixelSize: 11
                                                color: deleteBtnMouse.containsMouse ? "#FFFFFF" : dangerColor
                                            }
                                            
                                            MouseArea {
                                                id: deleteBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("🗑️ УДАЛЕНИЕ РАСПИСАНИЯ ID:", modelData.id)
                                                    confirmDialog.itemType = "расписания"
                                                    confirmDialog.itemId = modelData.id
                                                    confirmDialog.open()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onClicked: mouse.accepted = false
                                }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Нет расписаний"
                                font.pixelSize: 14
                                color: textSecondary
                                visible: schedulesModel.length === 0
                            }
                        }
                    }
                }
            }
            
            // ============================================
            // ВКЛАДКА 2: ПАЦИЕНТЫ
            // ============================================
            Rectangle {
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "👤 Управление пациентами"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                            Layout.fillWidth: true
                        }
                        
                        Button {
                            text: "+ Добавить пациента"
                            Layout.preferredHeight: 36
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(successColor, 1.1) : successColor
                            }
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                            }
                            onClicked: openAddPatientDialog()
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    TextField {
                        id: patientSearchField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        placeholderText: "🔍 Поиск пациентов по ФИО или телефону..."
                        font.pixelSize: 13
                        leftPadding: 12
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: patientSearchField.activeFocus ? primaryColor : borderColor
                            border.width: patientSearchField.activeFocus ? 2 : 1
                        }
                        onTextChanged: searchPatients()
                    }
                    
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        
                        ListView {
                            id: patientsListView
                            width: parent.width
                            model: patientsModel
                            spacing: 8
                            
                            function updateFilter() {
                                var searchText = patientSearchField.text.toLowerCase()
                                if (searchText === "") {
                                    model = patientsModel
                                } else {
                                    var temp = []
                                    for (var i = 0; i < patientsModel.length; i++) {
                                        var p = patientsModel[i]
                                        if ((p.full_name && p.full_name.toLowerCase().indexOf(searchText) !== -1) ||
                                            (p.phone && p.phone.toLowerCase().indexOf(searchText) !== -1)) {
                                            temp.push(p)
                                        }
                                    }
                                    model = temp
                                }
                            }
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 120
                                color: mouseArea.containsMouse ? "#FAFAFA" : "transparent"
                                radius: 8
                                border.color: borderColor
                                border.width: 1
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 48
                                        height: 48
                                        radius: 24
                                        color: primaryColor
                                        opacity: 0.1
                                        Text {
                                            anchors.centerIn: parent
                                            text: "👤"
                                            font.pixelSize: 22
                                        }
                                    }
                                    
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 4
                                        
                                        Text {
                                            text: modelData.full_name || "—"
                                            font.pixelSize: 14
                                            font.weight: Font.DemiBold
                                            color: textPrimary
                                        }
                                        
                                        Text {
                                            text: "📞 " + (modelData.phone || "—") + " | 📅 " + formatDateShort(modelData.birth_date) + " | 🪪 " + (modelData.card_number || "—")
                                            font.pixelSize: 11
                                            color: textSecondary
                                        }
                                        
                                        Text {
                                            text: "🏠 " + (modelData.address || "—")
                                            font.pixelSize: 11
                                            color: textSecondary
                                            elide: Text.ElideRight
                                        }
                                    }
                                    
                                    // КНОПКИ - вынесены в отдельный ColumnLayout с увеличенной зоной клика
                                    ColumnLayout {
                                        spacing: 8
                                        
                                        // Кнопка редактирования
                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: 8
                                            color: editBtnMouse.containsMouse ? primaryColor : "transparent"
                                            border.color: primaryColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✏️"
                                                font.pixelSize: 16
                                                color: editBtnMouse.containsMouse ? "#FFFFFF" : primaryColor
                                            }
                                            
                                            MouseArea {
                                                id: editBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("✏️ КНОПКА РЕДАКТИРОВАНИЯ НАЖАТА для:", modelData.full_name)
                                                    editPatient(modelData)
                                                }
                                            }
                                        }
                                        
                                        // Кнопка удаления
                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: 8
                                            color: deleteBtnMouse.containsMouse ? dangerColor : "transparent"
                                            border.color: dangerColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "🗑️"
                                                font.pixelSize: 16
                                                color: deleteBtnMouse.containsMouse ? "#FFFFFF" : dangerColor
                                            }
                                            
                                            MouseArea {
                                                id: deleteBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("🗑️ КНОПКА УДАЛЕНИЯ НАЖАТА для:", modelData.full_name)
                                                    confirmDialog.itemType = "пациента"
                                                    confirmDialog.itemId = modelData.id
                                                    confirmDialog.open()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    // Не перехватываем клики на кнопки
                                    propagateComposedEvents: true
                                    onClicked: mouse.accepted = false
                                }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Нет пациентов"
                                font.pixelSize: 14
                                color: textSecondary
                                visible: patientsListView.model.length === 0
                            }
                        }
                    }
                }
            }
            
            // ============================================
            // ВКЛАДКА 3: ВРАЧИ
            // ============================================
            Rectangle {
                color: surfaceColor
                radius: 12
                border.color: borderColor
                border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15
                    
                    RowLayout {
                        Layout.fillWidth: true
                        
                        Text {
                            text: "👨‍⚕️ Управление врачами"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                            color: textPrimary
                            Layout.fillWidth: true
                        }
                        
                        Button {
                            text: "+ Добавить врача"
                            Layout.preferredHeight: 36
                            background: Rectangle {
                                radius: 8
                                color: parent.hovered ? Qt.darker(successColor, 1.1) : successColor
                            }
                            contentItem: Text {
                                text: parent.text
                                font.pixelSize: 12
                                color: "#FFFFFF"
                            }
                            onClicked: openAddDoctorDialog()
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    TextField {
                        id: doctorSearchField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        placeholderText: "🔍 Поиск врачей по ФИО..."
                        font.pixelSize: 13
                        leftPadding: 12
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: doctorSearchField.activeFocus ? primaryColor : borderColor
                            border.width: doctorSearchField.activeFocus ? 2 : 1
                        }
                        onTextChanged: searchDoctors()
                    }
                    
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        
                        ListView {
                            id: doctorsListView
                            width: parent.width
                            model: doctorsModel
                            spacing: 8
                            
                            function updateFilter() {
                                var searchText = doctorSearchField.text.toLowerCase()
                                if (searchText === "") {
                                    model = doctorsModel
                                } else {
                                    var temp = []
                                    for (var i = 0; i < doctorsModel.length; i++) {
                                        var d = doctorsModel[i]
                                        if (d.doctor_name && d.doctor_name.toLowerCase().indexOf(searchText) !== -1) {
                                            temp.push(d)
                                        }
                                    }
                                    model = temp
                                }
                            }
                            
                            delegate: Rectangle {
                                width: ListView.view.width
                                height: 110
                                color: mouseArea.containsMouse ? "#FAFAFA" : "transparent"
                                radius: 8
                                border.color: borderColor
                                border.width: 1
                                
                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 12
                                    
                                    Rectangle {
                                        width: 48
                                        height: 48
                                        radius: 24
                                        color: successColor
                                        opacity: 0.1
                                        Text {
                                            anchors.centerIn: parent
                                            text: "👨‍⚕️"
                                            font.pixelSize: 22
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
                                        }
                                        
                                        Text {
                                            text: "🏥 " + (modelData.specialty_name || "—") + " | 📞 " + (modelData.doctor_phone || "—")
                                            font.pixelSize: 11
                                            color: textSecondary
                                        }
                                        
                                        Text {
                                            text: "🏢 " + (modelData.department_name || "—") + (modelData.room_number ? " | Каб." + modelData.room_number : "")
                                            font.pixelSize: 11
                                            color: textSecondary
                                        }
                                    }
                                    
                                    ColumnLayout {
                                        spacing: 8
                                        
                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: 8
                                            color: editBtnMouse.containsMouse ? primaryColor : "transparent"
                                            border.color: primaryColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✏️"
                                                font.pixelSize: 16
                                                color: editBtnMouse.containsMouse ? "#FFFFFF" : primaryColor
                                            }
                                            
                                            MouseArea {
                                                id: editBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("✏️ РЕДАКТИРОВАНИЕ ВРАЧА:", modelData.doctor_name)
                                                    editDoctor(modelData)
                                                }
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 36
                                            height: 36
                                            radius: 8
                                            color: deleteBtnMouse.containsMouse ? dangerColor : "transparent"
                                            border.color: dangerColor
                                            border.width: 1
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "🗑️"
                                                font.pixelSize: 16
                                                color: deleteBtnMouse.containsMouse ? "#FFFFFF" : dangerColor
                                            }
                                            
                                            MouseArea {
                                                id: deleteBtnMouse
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: {
                                                    console.log("🗑️ УДАЛЕНИЕ ВРАЧА:", modelData.doctor_name)
                                                    confirmDialog.itemType = "врача"
                                                    confirmDialog.itemId = modelData.doctor_id || modelData.id
                                                    confirmDialog.open()
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                MouseArea {
                                    id: mouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    propagateComposedEvents: true
                                    onClicked: mouse.accepted = false
                                }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: "Нет врачей"
                                font.pixelSize: 14
                                color: textSecondary
                                visible: doctorsListView.model.length === 0
                            }
                        }
                    }
                }
            }
        }
    }
    
    // ============================================
    // ФУНКЦИИ ПОИСКА
    // ============================================
    
    function searchPatients() {
        if (patientsListView && patientsListView.updateFilter) {
            patientsListView.updateFilter()
        }
    }
    
    function searchDoctors() {
        if (doctorsListView && doctorsListView.updateFilter) {
            doctorsListView.updateFilter()
        }
    }
    
    // ============================================
    // ФУНКЦИИ УДАЛЕНИЯ
    // ============================================
    
    function deleteDoctor(doctorId) {
        try {
            var result = DoctorService.remove(doctorId)
            if (result) {
                showSuccess("Врач удалён")
                loadDoctors()
            } else {
                showError("Ошибка удаления врача")
            }
        } catch(e) {
            showError("Ошибка: " + e)
        }
    }
    
    function deletePatient(patientId) {
        try {
            var result = PatientService.remove(patientId)
            if (result) {
                showSuccess("Пациент удалён")
                loadPatients()
            } else {
                showError("Ошибка удаления пациента")
            }
        } catch(e) {
            showError("Ошибка: " + e)
        }
    }
    
    function deleteSchedule(scheduleId) {
        try {
            var result = ScheduleService.remove(scheduleId)
            if (result) {
                showSuccess("Расписание удалено")
                loadSchedules()
            } else {
                showError("Ошибка удаления расписания")
            }
        } catch(e) {
            showError("Ошибка: " + e)
        }
    }
    
    // ============================================
    // ДИАЛОГ ДОБАВЛЕНИЯ/РЕДАКТИРОВАНИЯ ПАЦИЕНТА
    // ============================================
    
    Dialog {
        id: patientDialog
        width: 650
        height: 750
        anchors.centerIn: parent
        modal: true
        title: patientDialog.isEdit ? "✏️ Редактирование пациента" : "➕ Добавление пациента"
        
        property bool isEdit: false
        property var editPatientData: null
        
        background: Rectangle { radius: 16; color: surfaceColor; border.color: borderColor; border.width: 1 }
        
        contentItem: ScrollView {
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            
            ColumnLayout {
                width: parent.width - 40
                x: 20
                spacing: 20
                
                Text { 
                    text: patientDialog.isEdit ? "✏️ Редактирование данных пациента" : "📝 Добавление нового пациента"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    color: primaryColor
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                
                // ФИО
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "ФИО *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    TextField {
                        id: patientFullName
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "Иванов Иван Иванович"
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Дата рождения *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: patientBirthDate
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "ДД.ММ.ГГГГ"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Телефон"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: patientPhone
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "+7 (900) 123-45-67"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Адрес"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    TextField {
                        id: patientAddress
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "ул. Ленина, д. 10, кв. 5"
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Паспортные данные"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: patientPassport
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "4500 123456"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Участок"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: patientDistrict
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: districtsModel
                            textRole: "number"
                            valueRole: "id"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                
                Text { text: "🏥 Медицинская карта"; font.pixelSize: 14; font.weight: Font.DemiBold; color: primaryColor }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Номер карты"; font.pixelSize: 12; color: textSecondary }
                        TextField {
                            id: patientCardNumber
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "К-0001"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Группа крови"; font.pixelSize: 12; color: textSecondary }
                        TextField {
                            id: patientBloodGroup
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "I(0)Rh+"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Аллергии"; font.pixelSize: 12; color: textSecondary }
                    TextArea {
                        id: patientAllergies
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        placeholderText: "Пенициллин, цитрусовые..."
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Хронические заболевания"; font.pixelSize: 12; color: textSecondary }
                    TextArea {
                        id: patientChronicDiseases
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        placeholderText: "Гипертония, диабет..."
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "📍 Местоположение в картотеке"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text { text: "Стеллаж"; font.pixelSize: 11; color: textSecondary }
                            ComboBox {
                                id: patientShelf
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                model: ["A", "B", "C", "D", "E"]
                                font.pixelSize: 13
                                background: Rectangle {
                                    radius: 6
                                    color: inputBgColor
                                    border.color: borderColor
                                    border.width: 1
                                }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text { text: "Ряд"; font.pixelSize: 11; color: textSecondary }
                            ComboBox {
                                id: patientRow
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                model: ["1", "2", "3", "4", "5", "6"]
                                font.pixelSize: 13
                                background: Rectangle {
                                    radius: 6
                                    color: inputBgColor
                                    border.color: borderColor
                                    border.width: 1
                                }
                            }
                        }
                        
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 6
                            Text { text: "Цвет маркировки"; font.pixelSize: 11; color: textSecondary }
                            ComboBox {
                                id: patientColor
                                Layout.fillWidth: true
                                Layout.preferredHeight: 38
                                model: ["зеленый", "желтый", "красный", "синий"]
                                font.pixelSize: 13
                                background: Rectangle {
                                    radius: 6
                                    color: inputBgColor
                                    border.color: borderColor
                                    border.width: 1
                                }
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 10 }
            }
        }
        
        footer: Rectangle {
            width: parent.width
            height: 70
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Отмена"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 42
                    onClicked: patientDialog.close()
                    background: Rectangle {
                        radius: 10
                        color: "transparent"
                        border.color: borderColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: textSecondary
                        font.pixelSize: 14
                    }
                }
                
                Button {
                    text: patientDialog.isEdit ? "💾 Сохранить" : "➕ Добавить"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 42
                    onClicked: savePatient()
                    background: Rectangle {
                        radius: 10
                        color: primaryColor
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
        }
    }
    
    // ============================================
    // ДИАЛОГ ДОБАВЛЕНИЯ/РЕДАКТИРОВАНИЯ ВРАЧА
    // ============================================
    
    Dialog {
        id: doctorDialog
        width: 550
        height: 620
        anchors.centerIn: parent
        modal: true
        title: doctorDialog.isEdit ? "✏️ Редактирование врача" : "➕ Добавление врача"
        
        property bool isEdit: false
        property var editDoctorData: null
        
        background: Rectangle { radius: 16; color: surfaceColor; border.color: borderColor; border.width: 1 }
        
        contentItem: ScrollView {
            clip: true
            
            ColumnLayout {
                width: parent.width - 40
                x: 20
                spacing: 20
                
                Text { 
                    text: doctorDialog.isEdit ? "✏️ Редактирование данных врача" : "👨‍⚕️ Добавление нового врача"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    color: primaryColor
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "ФИО *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    TextField {
                        id: doctorFullName
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "Иванов Иван Иванович"
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Телефон"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: doctorPhone
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "+7 (900) 123-45-67"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Специальность *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: doctorSpecialty
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: specialtiesModel
                            textRole: "name"
                            valueRole: "id"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Отделение *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: doctorDepartment
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: departmentsModel
                            textRole: "name"
                            valueRole: "id"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Участок"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: doctorDistrict
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: districtsModel
                            textRole: "number"
                            valueRole: "id"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                
                Text { text: "👤 Учётная запись для входа"; font.pixelSize: 14; font.weight: Font.DemiBold; color: primaryColor }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Логин"; font.pixelSize: 12; color: textSecondary }
                        TextField {
                            id: doctorLogin
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "doctor.login"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Пароль"; font.pixelSize: 12; color: textSecondary }
                        TextField {
                            id: doctorPassword
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: doctorDialog.isEdit ? "Оставьте пустым, чтобы не менять" : "Введите пароль"
                            font.pixelSize: 14
                            echoMode: TextInput.Password
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 10 }
            }
        }
        
        footer: Rectangle {
            width: parent.width
            height: 70
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Отмена"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 42
                    onClicked: doctorDialog.close()
                    background: Rectangle {
                        radius: 10
                        color: "transparent"
                        border.color: borderColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: textSecondary
                        font.pixelSize: 14
                    }
                }
                
                Button {
                    text: doctorDialog.isEdit ? "💾 Сохранить" : "➕ Добавить"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 42
                    onClicked: saveDoctor()
                    background: Rectangle {
                        radius: 10
                        color: primaryColor
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
        }
    }
    
    // ============================================
    // ДИАЛОГ ДОБАВЛЕНИЯ/РЕДАКТИРОВАНИЯ РАСПИСАНИЯ
    // ============================================
    
    Dialog {
        id: scheduleDialog
        width: 550
        height: 620
        anchors.centerIn: parent
        modal: true
        title: scheduleDialog.isEdit ? "✏️ Редактирование расписания" : "➕ Добавление расписания"
        
        property bool isEdit: false
        property var editScheduleData: null
        
        background: Rectangle { radius: 16; color: surfaceColor; border.color: borderColor; border.width: 1 }
        
        contentItem: ScrollView {
            clip: true
            
            ColumnLayout {
                width: parent.width - 40
                x: 20
                spacing: 20
                
                Text { 
                    text: scheduleDialog.isEdit ? "✏️ Редактирование расписания" : "📅 Добавление нового расписания"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    color: primaryColor
                }
                
                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Врач *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    ComboBox {
                        id: scheduleDoctor
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        model: doctorsModel
                        textRole: "doctor_name"
                        valueRole: "doctor_id"
                        font.pixelSize: 14
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                        indicator: Text {
                            text: "▼"
                            font.pixelSize: 12
                            color: textSecondary
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        contentItem: Text {
                            text: parent.displayText
                            font.pixelSize: 14
                            color: textPrimary
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: 12
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "День недели *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: scheduleDayOfWeek
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Кабинет *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        ComboBox {
                            id: scheduleRoom
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            model: roomsModel
                            textRole: "number"
                            valueRole: "id"
                            font.pixelSize: 14
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            indicator: Text {
                                text: "▼"
                                font.pixelSize: 12
                                color: textSecondary
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                anchors.verticalCenter: parent.verticalCenter
                            }
                            contentItem: Text {
                                text: parent.displayText
                                font.pixelSize: 14
                                color: textPrimary
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 12
                            }
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Время начала *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: scheduleStartTime
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "09:00:00"
                            font.pixelSize: 14
                            color: textPrimary
                            inputMethodHints: Qt.ImhTime
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            onTextChanged: updateMaxPatientsInfo()
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Время окончания *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: scheduleEndTime
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "15:00:00"
                            font.pixelSize: 14
                            color: textPrimary
                            inputMethodHints: Qt.ImhTime
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                            onTextChanged: updateMaxPatientsInfo()
                        }
                    }
                }

                // Добавь эту индикацию количества пациентов
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: 8
                    color: "#E8F5E9"
                    visible: calculateMaxPatients(scheduleStartTime.text, scheduleEndTime.text) > 0
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        
                        Text {
                            text: "👥"
                            font.pixelSize: 14
                        }
                        
                        Text {
                            text: "Максимум пациентов за день: "
                            font.pixelSize: 12
                            color: textSecondary
                        }
                        
                        Text {
                            id: maxPatientsInfo
                            text: calculateMaxPatients(scheduleStartTime.text, scheduleEndTime.text)
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                            color: successColor
                        }
                    }
                }
                
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Дата начала *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: scheduleValidFrom
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "2024-01-01"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                    
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text { text: "Дата окончания"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                        TextField {
                            id: scheduleValidTo
                            Layout.fillWidth: true
                            Layout.preferredHeight: 42
                            placeholderText: "Оставьте пустым"
                            font.pixelSize: 14
                            color: textPrimary
                            background: Rectangle {
                                radius: 8
                                color: inputBgColor
                                border.color: parent.activeFocus ? primaryColor : borderColor
                                border.width: parent.activeFocus ? 2 : 1
                            }
                        }
                    }
                }
                
                Item { Layout.preferredHeight: 10 }
            }
        }
        
        footer: Rectangle {
            width: parent.width
            height: 70
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Отмена"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 42
                    onClicked: scheduleDialog.close()
                    background: Rectangle {
                        radius: 10
                        color: "transparent"
                        border.color: borderColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: textSecondary
                        font.pixelSize: 14
                    }
                }
                
                Button {
                    text: scheduleDialog.isEdit ? "💾 Сохранить" : "➕ Добавить"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 42
                    onClicked: saveSchedule()
                    background: Rectangle {
                        radius: 10
                        color: primaryColor
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
        }
    }
    
    // ============================================
    // ДИАЛОГ ОТПУСКА/ИСКЛЮЧЕНИЯ
    // ============================================
    
    Dialog {
        id: exceptionDialog
        width: 500
        height: 620
        anchors.centerIn: parent
        modal: true
        title: "📅 Добавление исключения в расписание"
        
        property var scheduleData: null
        
        background: Rectangle { radius: 16; color: surfaceColor; border.color: borderColor; border.width: 1 }
        
        contentItem: ColumnLayout {
            spacing: 20
            anchors.fill: parent
            anchors.margins: 20

            Item {
                Layout.preferredHeight: 20
            }
            
            Text { 
                text: "📅 Исключение в расписании"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                color: primaryColor
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Text { text: "Врач"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                Text {
                    id: exceptionDoctorNameText
                    Layout.fillWidth: true
                    font.pixelSize: 14
                    color: textPrimary
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Дата начала *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    TextField {
                        id: exceptionStartDateField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "ДД.ММ.ГГГГ"
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Дата окончания *"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                    TextField {
                        id: exceptionEndDateField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "ДД.ММ.ГГГГ"
                        font.pixelSize: 14
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
            }
            
            Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
            
            Text { text: "Режим работы"; font.pixelSize: 14; font.weight: Font.DemiBold; color: primaryColor }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                
                Button {
                    text: "🏖️ Полностью не работает"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    checkable: true
                    checked: true
                    id: exceptionNotWorkingBtn
                    onClicked: {
                        exceptionNotWorkingBtn.checked = true
                        exceptionSpecialHoursBtn.checked = false
                        exceptionStartTimeField.enabled = false
                        exceptionEndTimeField.enabled = false
                    }
                    background: Rectangle {
                        radius: 8
                        color: exceptionNotWorkingBtn.checked ? primaryColor : "transparent"
                        border.color: primaryColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: exceptionNotWorkingBtn.checked ? "#FFFFFF" : textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }
                }
                Button {
                    text: "⏰ Работает по особому графику"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    checkable: true
                    id: exceptionSpecialHoursBtn
                    onClicked: {
                        exceptionSpecialHoursBtn.checked = true
                        exceptionNotWorkingBtn.checked = false
                        exceptionStartTimeField.enabled = true
                        exceptionEndTimeField.enabled = true
                    }
                    background: Rectangle {
                        radius: 8
                        color: exceptionSpecialHoursBtn.checked ? primaryColor : "transparent"
                        border.color: primaryColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: exceptionSpecialHoursBtn.checked ? "#FFFFFF" : textPrimary
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }
                }
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                enabled: exceptionSpecialHoursBtn.checked
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Время начала"; font.pixelSize: 12; color: textSecondary }
                    TextField {
                        id: exceptionStartTimeField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "09:00:00"
                        font.pixelSize: 14
                        enabled: false
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
                
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 6
                    Text { text: "Время окончания"; font.pixelSize: 12; color: textSecondary }
                    TextField {
                        id: exceptionEndTimeField
                        Layout.fillWidth: true
                        Layout.preferredHeight: 42
                        placeholderText: "17:00:00"
                        font.pixelSize: 14
                        enabled: false
                        color: textPrimary
                        background: Rectangle {
                            radius: 8
                            color: inputBgColor
                            border.color: parent.activeFocus ? primaryColor : borderColor
                            border.width: parent.activeFocus ? 2 : 1
                        }
                    }
                }
            }
            
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Text { text: "Причина"; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary }
                TextField {
                    id: exceptionReasonField
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    placeholderText: "Отпуск, больничный, конференция..."
                    font.pixelSize: 14
                    color: textPrimary
                    background: Rectangle {
                        radius: 8
                        color: inputBgColor
                        border.color: parent.activeFocus ? primaryColor : borderColor
                        border.width: parent.activeFocus ? 2 : 1
                    }
                }
            }
            Item {
                Layout.fillHeight: true
            }
        }
        
        footer: Rectangle {
            width: parent.width
            height: 70
            color: "transparent"
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Отмена"
                    Layout.preferredWidth: 120
                    Layout.preferredHeight: 42
                    onClicked: exceptionDialog.close()
                    background: Rectangle {
                        radius: 10
                        color: "transparent"
                        border.color: borderColor
                        border.width: 1
                    }
                    contentItem: Text {
                        text: parent.text
                        color: textSecondary
                        font.pixelSize: 14
                    }
                }
                
                Button {
                    text: "💾 Сохранить"
                    Layout.preferredWidth: 140
                    Layout.preferredHeight: 42
                    onClicked: saveException()
                    background: Rectangle {
                        radius: 10
                        color: primaryColor
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
        }
    }
    
    // ============================================
    // ФУНКЦИИ СОХРАНЕНИЯ
    // ============================================

    function updateMaxPatientsInfo() {
        var count = calculateMaxPatients(scheduleStartTime.text, scheduleEndTime.text)
        if (count > 0) {
            maxPatientsInfo.text = count
        } else {
            maxPatientsInfo.text = "0"
        }
    }

    // Добавь эту функцию в раздел FUNCTIONS
    function calculateMaxPatients(startTimeStr, endTimeStr) {
        if (!startTimeStr || !endTimeStr) return 0
        
        // Функция для парсинга времени
        function parseTime(timeStr) {
            if (timeStr.indexOf(":") !== -1) {
                var parts = timeStr.split(":")
                var hours = parseInt(parts[0])
                var minutes = parseInt(parts[1])
                return hours * 60 + minutes
            }
            return 0
        }
        
        var startMinutes = parseTime(startTimeStr)
        var endMinutes = parseTime(endTimeStr)
        
        if (startMinutes >= endMinutes) return 0
        
        // Интервал 15 минут
        var intervalMinutes = 15
        var totalMinutes = endMinutes - startMinutes
        var maxPatients = Math.floor(totalMinutes / intervalMinutes)
        
        return maxPatients > 0 ? maxPatients : 0
    }

    function formatDateToDisplay(dateValue) {
        if (!dateValue) return ""
        
        // Если это объект Date
        if (typeof dateValue === "object" && dateValue.getDate) {
            var d = dateValue.getDate().toString().padStart(2, '0')
            var m = (dateValue.getMonth() + 1).toString().padStart(2, '0')
            var y = dateValue.getFullYear()
            return d + "." + m + "." + y
        }
        
        // Если это строка в формате "YYYY-MM-DD"
        if (typeof dateValue === "string" && dateValue.indexOf("-") !== -1) {
            var parts = dateValue.split("-")
            if (parts.length === 3) {
                return parts[2] + "." + parts[1] + "." + parts[0]
            }
        }
        
        return dateValue.toString()
    }
    
    function savePatient() {
        if (!patientFullName.text) {
            showError("Заполните ФИО пациента")
            return
        }
        
        if (!patientBirthDate.text) {
            showError("Заполните дату рождения")
            return
        }
        
        try {
            var birthDateStr = formatDateForDb(patientBirthDate.text)
            var districtId = patientDistrict.currentValue || null
            
            if (patientDialog.isEdit && patientDialog.editPatientData) {
                var updateResult = PatientService.update({
                    id: patientDialog.editPatientData.id,
                    full_name: patientFullName.text,
                    birth_date: birthDateStr,
                    phone: patientPhone.text || "",
                    address: patientAddress.text || "",
                    passport_data: patientPassport.text || "",
                    id_district: districtId
                })
                
                if (updateResult) {
                    var cards = MedicalCardService.search([
                        {"field": "id_patient", "operator": "eq", "value": patientDialog.editPatientData.id}
                    ])
                    
                    if (cards.length > 0) {
                        MedicalCardService.update({
                            id: cards[0].id,
                            card_number: patientCardNumber.text || "",
                            blood_group: patientBloodGroup.text || "",
                            allergies: patientAllergies.text || "",
                            chronic_diseases: patientChronicDiseases.text || "",
                            shelf_number: patientShelf.currentText,
                            row_number: patientRow.currentText,
                            color_marking: patientColor.currentText,
                            id_patient: patientDialog.editPatientData.id
                        })
                    } else {
                        MedicalCardService.add({
                            card_number: patientCardNumber.text || "",
                            blood_group: patientBloodGroup.text || "",
                            allergies: patientAllergies.text || "",
                            chronic_diseases: patientChronicDiseases.text || "",
                            shelf_number: patientShelf.currentText,
                            row_number: patientRow.currentText,
                            color_marking: patientColor.currentText,
                            id_patient: patientDialog.editPatientData.id
                        })
                    }
                    
                    showSuccess("Пациент обновлён")
                }
            } else {
                var addResult = PatientService.add({
                    full_name: patientFullName.text,
                    birth_date: birthDateStr,
                    phone: patientPhone.text || "",
                    address: patientAddress.text || "",
                    passport_data: patientPassport.text || "",
                    id_district: districtId
                })
                
                if (addResult && addResult.id) {
                    MedicalCardService.add({
                        card_number: patientCardNumber.text || "",
                        blood_group: patientBloodGroup.text || "",
                        allergies: patientAllergies.text || "",
                        chronic_diseases: patientChronicDiseases.text || "",
                        shelf_number: patientShelf.currentText,
                        row_number: patientRow.currentText,
                        color_marking: patientColor.currentText,
                        id_patient: addResult.id
                    })
                    
                    showSuccess("Пациент добавлен")
                }
            }
            
            patientDialog.close()
            loadPatients()
            
        } catch(e) {
            showError("Ошибка: " + e)
        }
    }
    
    function saveDoctor() {
        if (!doctorFullName.text) {
            showError("Заполните ФИО врача")
            return
        }
        
        if (!doctorSpecialty.currentValue) {
            showError("Выберите специальность")
            return
        }
        
        if (!doctorDepartment.currentValue) {
            showError("Выберите отделение")
            return
        }
        
        try {
            var districtId = doctorDistrict.currentValue || null
            
            if (doctorDialog.isEdit && doctorDialog.editDoctorData) {
                var updateResult = DoctorService.update({
                    id: doctorDialog.editDoctorData.doctor_id,
                    full_name: doctorFullName.text,
                    phone_number: doctorPhone.text || "",
                    id_specialty: doctorSpecialty.currentValue,
                    id_department: doctorDepartment.currentValue,
                    id_district: districtId
                })
                
                if (updateResult) {
                    showSuccess("Врач обновлён")
                }
            } else {
                var addResult = DoctorService.add({
                    full_name: doctorFullName.text,
                    phone_number: doctorPhone.text || "",
                    id_specialty: doctorSpecialty.currentValue,
                    id_department: doctorDepartment.currentValue,
                    id_district: districtId
                })
                
                if (addResult && addResult.id) {
                    if (doctorLogin.text && doctorPassword.text) {
                        try {
                            RegistrarService.add({
                                full_name: doctorFullName.text,
                                phone_number: doctorPhone.text || "",
                                login: doctorLogin.text,
                                password_hash: doctorPassword.text,
                                id_polyclinic: root.idPolyclinic,
                                role: "doctor"
                            })
                        } catch(e) {
                            console.log("Не удалось создать учётную запись:", e)
                        }
                    }
                    showSuccess("Врач добавлен")
                }
            }
            
            doctorDialog.close()
            loadDoctors()
            
        } catch(e) {
            showError("Ошибка: " + e)
        }
    }
    
    function saveSchedule() {
        if (!scheduleDoctor.currentValue) {
            showError("Выберите врача")
            return
        }
        
        if (!scheduleStartTime.text || !scheduleEndTime.text) {
            showError("Заполните время начала и окончания")
            return
        }
        
        if (!scheduleValidFrom.text) {
            showError("Заполните дату начала действия")
            return
        }
        
        try {
            var dayOfWeek = scheduleDayOfWeek.currentIndex + 1
            
            // Преобразуем время в правильный формат
            var startTime = scheduleStartTime.text
            if (startTime.indexOf(":") !== -1) {
                var timeParts = startTime.split(":")
                startTime = timeParts[0].padStart(2, '0') + ":" + (timeParts[1] || "00").padStart(2, '0') + ":00"
            }
            
            var endTime = scheduleEndTime.text
            if (endTime.indexOf(":") !== -1) {
                var timeParts2 = endTime.split(":")
                endTime = timeParts2[0].padStart(2, '0') + ":" + (timeParts2[1] || "00").padStart(2, '0') + ":00"
            }
            
            // АВТОМАТИЧЕСКИ РАССЧИТЫВАЕМ МАКСИМАЛЬНОЕ КОЛИЧЕСТВО ПАЦИЕНТОВ
            var maxPatients = calculateMaxPatients(scheduleStartTime.text, scheduleEndTime.text)
            
            if (maxPatients === 0) {
                showError("Некорректное время приёма (начало не может быть позже окончания или равно ему)")
                return
            }
            
            // Функция для преобразования даты из DD.MM.YYYY в YYYY-MM-DD
            function convertDateToDb(dateStr) {
                if (!dateStr) return null
                if (dateStr.indexOf(".") !== -1) {
                    var parts = dateStr.split(".")
                    if (parts.length === 3) {
                        return parts[2] + "-" + parts[1].padStart(2, '0') + "-" + parts[0].padStart(2, '0')
                    }
                }
                return dateStr
            }
            
            var validFrom = convertDateToDb(scheduleValidFrom.text)
            var validTo = scheduleValidTo.text ? convertDateToDb(scheduleValidTo.text) : null
            
            console.log("СОХРАНЕНИЕ РАСПИСАНИЯ:")
            console.log("  day_of_week:", dayOfWeek)
            console.log("  start_time:", startTime)
            console.log("  end_time:", endTime)
            console.log("  id_room:", scheduleRoom.currentValue)
            console.log("  id_doctor:", scheduleDoctor.currentValue)
            console.log("  valid_from:", validFrom)
            console.log("  valid_to:", validTo)
            console.log("  max_patients (рассчитано):", maxPatients)
            
            if (scheduleDialog.isEdit && scheduleDialog.editScheduleData) {
                var updateResult = ScheduleService.update({
                    id: scheduleDialog.editScheduleData.id,
                    day_of_week: dayOfWeek,
                    start_time: startTime,
                    end_time: endTime,
                    id_room: scheduleRoom.currentValue,
                    id_doctor: scheduleDoctor.currentValue,
                    valid_from: validFrom,
                    valid_to: validTo,
                    max_patients: maxPatients
                })
                
                if (updateResult) {
                    showSuccess("Расписание обновлено (на " + maxPatients + " пациентов)")
                    scheduleDialog.close()
                    loadSchedules()
                } else {
                    showError("Ошибка обновления расписания")
                }
            } else {
                var addResult = ScheduleService.add({
                    day_of_week: dayOfWeek,
                    start_time: startTime,
                    end_time: endTime,
                    id_room: scheduleRoom.currentValue,
                    id_doctor: scheduleDoctor.currentValue,
                    valid_from: validFrom,
                    valid_to: validTo,
                    max_patients: maxPatients
                })
                
                if (addResult && addResult.id) {
                    showSuccess("Расписание добавлено (на " + maxPatients + " пациентов)")
                    scheduleDialog.close()
                    loadSchedules()
                } else {
                    showError("Ошибка добавления расписания")
                }
            }
            
        } catch(e) {
            console.error("Ошибка сохранения расписания:", e)
            showError("Ошибка: " + e)
        }
    }
    
    function saveException() {
        if (!exceptionStartDateField.text || !exceptionEndDateField.text) {
            showError("Заполните даты")
            return
        }
        
        try {
            var isWorking = true
            var startTime = null
            var endTime = null
            
            if (exceptionNotWorkingBtn.checked) {
                isWorking = false
            } else if (exceptionSpecialHoursBtn.checked) {
                isWorking = true
                startTime = exceptionStartTimeField.text || null
                endTime = exceptionEndTimeField.text || null
            }
            
            // Преобразуем даты из DD.MM.YYYY в YYYY-MM-DD
            function convertDateToDb(dateStr) {
                if (!dateStr) return null
                if (dateStr.indexOf(".") !== -1) {
                    var parts = dateStr.split(".")
                    if (parts.length === 3) {
                        return parts[2] + "-" + parts[1].padStart(2, '0') + "-" + parts[0].padStart(2, '0')
                    }
                }
                return dateStr
            }
            
            var startDate = convertDateToDb(exceptionStartDateField.text)
            var endDate = convertDateToDb(exceptionEndDateField.text)
            
            console.log("СОХРАНЕНИЕ ИСКЛЮЧЕНИЯ:")
            console.log("  id_doctor:", exceptionDialog.scheduleData ? exceptionDialog.scheduleData.id_doctor : scheduleDoctor.currentValue)
            console.log("  exception_start_date:", startDate)
            console.log("  exception_end_date:", endDate)
            console.log("  start_time:", startTime)
            console.log("  end_time:", endTime)
            console.log("  is_working:", isWorking)
            console.log("  reason:", exceptionReasonField.text || "")
            
            var result = ScheduleExceptionService.add({
                id_doctor: exceptionDialog.scheduleData ? exceptionDialog.scheduleData.id_doctor : scheduleDoctor.currentValue,
                exception_start_date: startDate,
                exception_end_date: endDate,
                start_time: startTime,
                end_time: endTime,
                is_working: isWorking,
                reason: exceptionReasonField.text || ""
            })
            
            if (result) {
                showSuccess("Исключение добавлено")
                exceptionDialog.close()
                loadSchedules()
            } else {
                showError("Ошибка добавления исключения")
            }
        } catch(e) {
            console.error("Ошибка сохранения исключения:", e)
            showError("Ошибка: " + e)
        }
    }
    // ============================================
    // ФУНКЦИИ ОТКРЫТИЯ ДИАЛОГОВ
    // ============================================
    
    function openAddPatientDialog() {
        patientDialog.isEdit = false
        patientDialog.editPatientData = null
        
        patientFullName.text = ""
        patientBirthDate.text = ""
        patientPhone.text = ""
        patientAddress.text = ""
        patientPassport.text = ""
        patientCardNumber.text = ""
        patientBloodGroup.text = ""
        patientAllergies.text = ""
        patientChronicDiseases.text = ""
        patientShelf.currentIndex = 0
        patientRow.currentIndex = 0
        patientColor.currentIndex = 0
        patientDistrict.currentIndex = -1
        
        patientDialog.open()
    }
    
    function editPatient(patient) {
        patientDialog.isEdit = true
        patientDialog.editPatientData = patient
        
        patientFullName.text = patient.full_name || ""
        
        if (patient.birth_date) {
            var birthDate = patient.birth_date
            if (typeof birthDate === "string" && birthDate.indexOf("-") !== -1) {
                var parts = birthDate.split("-")
                patientBirthDate.text = parts[2] + "." + parts[1] + "." + parts[0]
            } else {
                patientBirthDate.text = birthDate
            }
        } else {
            patientBirthDate.text = ""
        }
        
        patientPhone.text = patient.phone || ""
        patientAddress.text = patient.address || ""
        patientPassport.text = patient.passport_data || ""
        patientCardNumber.text = patient.card_number || ""
        patientBloodGroup.text = patient.blood_group || ""
        patientAllergies.text = patient.allergies || ""
        patientChronicDiseases.text = patient.chronic_diseases || ""
        
        if (patient.shelf_number) {
            var shelfIndex = patientShelf.model.indexOf(patient.shelf_number)
            if (shelfIndex >= 0) patientShelf.currentIndex = shelfIndex
        }
        if (patient.row_number) {
            var rowIndex = patientRow.model.indexOf(patient.row_number)
            if (rowIndex >= 0) patientRow.currentIndex = rowIndex
        }
        if (patient.color_marking) {
            var colorIndex = patientColor.model.indexOf(patient.color_marking)
            if (colorIndex >= 0) patientColor.currentIndex = colorIndex
        }
        
        if (patient.id_district) {
            for (var i = 0; i < districtsModel.length; i++) {
                if (districtsModel[i].id === patient.id_district) {
                    patientDistrict.currentIndex = i
                    break
                }
            }
        }
        
        patientDialog.open()
    }
    
    function openAddDoctorDialog() {
        doctorDialog.isEdit = false
        doctorDialog.editDoctorData = null
        
        doctorFullName.text = ""
        doctorPhone.text = ""
        doctorLogin.text = ""
        doctorPassword.text = ""
        doctorSpecialty.currentIndex = -1
        doctorDepartment.currentIndex = -1
        doctorDistrict.currentIndex = -1
        
        doctorDialog.open()
    }
    
    function editDoctor(doctor) {
        doctorDialog.isEdit = true
        doctorDialog.editDoctorData = doctor
        
        doctorFullName.text = doctor.doctor_name || ""
        doctorPhone.text = doctor.doctor_phone || ""
        
        if (doctor.specialty_id) {
            for (var i = 0; i < specialtiesModel.length; i++) {
                if (specialtiesModel[i].id === doctor.specialty_id) {
                    doctorSpecialty.currentIndex = i
                    break
                }
            }
        }
        
        if (doctor.department_id) {
            for (var j = 0; j < departmentsModel.length; j++) {
                if (departmentsModel[j].id === doctor.department_id) {
                    doctorDepartment.currentIndex = j
                    break
                }
            }
        }
        
        if (doctor.district_id) {
            for (var k = 0; k < districtsModel.length; k++) {
                if (districtsModel[k].id === doctor.district_id) {
                    doctorDistrict.currentIndex = k
                    break
                }
            }
        }
        
        doctorDialog.open()
    }
    
    function openAddScheduleDialog() {
        scheduleDialog.isEdit = false
        scheduleDialog.editScheduleData = null
        
        scheduleDoctor.currentIndex = -1
        scheduleDayOfWeek.currentIndex = 0
        scheduleRoom.currentIndex = -1
        scheduleStartTime.text = "09:00:00"
        scheduleEndTime.text = "15:00:00"
        scheduleValidFrom.text = new Date().toISOString().split('T')[0]
        scheduleValidTo.text = ""
        
        scheduleDialog.open()
    }
        
    function editSchedule(schedule) {
        console.log("✏️ РЕДАКТИРОВАНИЕ РАСПИСАНИЯ:", JSON.stringify(schedule))
        
        scheduleDialog.isEdit = true
        scheduleDialog.editScheduleData = schedule
        
        // Устанавливаем врача
        if (schedule.id_doctor) {
            for (var i = 0; i < doctorsModel.length; i++) {
                if (doctorsModel[i].doctor_id === schedule.id_doctor) {
                    scheduleDoctor.currentIndex = i
                    break
                }
            }
        }
        
        scheduleDayOfWeek.currentIndex = (schedule.day_of_week || 1) - 1
        
        // ФОРМАТИРУЕМ ВРЕМЯ ПРАВИЛЬНО
        function formatTime(timeValue) {
            if (!timeValue) return "09:00:00"
            
            // Если это строка в формате "08:00:00"
            if (typeof timeValue === "string" && timeValue.indexOf(":") !== -1) {
                var timeParts = timeValue.split(":")
                if (timeParts.length >= 2) {
                    return timeParts[0].padStart(2, '0') + ":" + timeParts[1].padStart(2, '0') + ":00"
                }
                return timeValue
            }
            
            // Если это объект Date
            if (typeof timeValue === "object" && timeValue.getHours) {
                var hours = timeValue.getHours().toString().padStart(2, '0')
                var minutes = timeValue.getMinutes().toString().padStart(2, '0')
                return hours + ":" + minutes + ":00"
            }
            
            // Если это строка вида "Thu Apr 1 08:00:00 1971 GMT+0300"
            if (typeof timeValue === "string" && timeValue.indexOf("GMT") !== -1) {
                var dateObj = new Date(timeValue)
                if (!isNaN(dateObj.getTime())) {
                    var h = dateObj.getHours().toString().padStart(2, '0')
                    var m = dateObj.getMinutes().toString().padStart(2, '0')
                    return h + ":" + m + ":00"
                }
            }
            
            return "09:00:00"
        }
        
        scheduleStartTime.text = formatTime(schedule.start_time)
        scheduleEndTime.text = formatTime(schedule.end_time)
        
        // ФОРМАТИРУЕМ ДАТУ В ФОРМАТ DD.MM.YYYY ДЛЯ ПОЛЯ ВВОДА
        function formatDateForDisplay(dateValue) {
            if (!dateValue) return ""
            
            // Если это объект Date
            if (typeof dateValue === "object" && dateValue.getDate) {
                var d = dateValue.getDate().toString().padStart(2, '0')
                var m = (dateValue.getMonth() + 1).toString().padStart(2, '0')
                var y = dateValue.getFullYear()
                return d + "." + m + "." + y
            }
            
            // Если это строка в формате "YYYY-MM-DD"
            if (typeof dateValue === "string" && dateValue.indexOf("-") !== -1 && dateValue.length === 10) {
                var parts = dateValue.split("-")
                return parts[2] + "." + parts[1] + "." + parts[0]
            }
            
            // Если это строка вида "Thu Apr 1 08:00:00 1971 GMT+0300"
            if (typeof dateValue === "string") {
                var parsedDate = new Date(dateValue)
                if (!isNaN(parsedDate.getTime())) {
                    var dd = parsedDate.getDate().toString().padStart(2, '0')
                    var mm = (parsedDate.getMonth() + 1).toString().padStart(2, '0')
                    var yy = parsedDate.getFullYear()
                    return dd + "." + mm + "." + yy
                }
            }
            
            return dateValue.toString()
        }
        
        // Устанавливаем дату начала
        if (schedule.valid_from) {
            scheduleValidFrom.text = formatDateForDisplay(schedule.valid_from)
        } else {
            scheduleValidFrom.text = formatDateForDisplay(new Date())
        }
        
        // Устанавливаем дату окончания
        if (schedule.valid_to) {
            scheduleValidTo.text = formatDateForDisplay(schedule.valid_to)
        } else {
            scheduleValidTo.text = ""
        }
        
        // Устанавливаем кабинет
        if (schedule.id_room) {
            for (var j = 0; j < roomsModel.length; j++) {
                if (roomsModel[j].id === schedule.id_room) {
                    scheduleRoom.currentIndex = j
                    break
                }
            }
        }
        
        scheduleDialog.open()
    }
    
    function openExceptionDialog(schedule) {
        console.log("📅 ОТКРЫТИЕ ДИАЛОГА ИСКЛЮЧЕНИЯ для расписания ID:", schedule.id)
        
        exceptionDialog.scheduleData = schedule
        
        // Заполняем имя врача
        var doctorName = ""
        for (var i = 0; i < doctorsModel.length; i++) {
            if (doctorsModel[i].doctor_id === schedule.id_doctor) {
                doctorName = doctorsModel[i].doctor_name
                break
            }
        }
        exceptionDoctorNameText.text = doctorName || "Врач ID: " + schedule.id_doctor
        
        // Очищаем поля
        exceptionStartDateField.text = ""
        exceptionEndDateField.text = ""
        exceptionStartTimeField.text = ""
        exceptionEndTimeField.text = ""
        exceptionReasonField.text = ""
        
        // Сбрасываем кнопки
        exceptionNotWorkingBtn.checked = true
        // exceptionWorkingHoursBtn.checked = false
        exceptionSpecialHoursBtn.checked = false
        exceptionStartTimeField.enabled = false
        exceptionEndTimeField.enabled = false
        
        exceptionDialog.open()
    }
}