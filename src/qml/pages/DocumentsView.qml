import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import Polyclinic.UI 1.0
import Patient.Services 1.0
import DoctorFullInfoView.Services 1.0
import Disease.Services 1.0
import SickLeave.Services 1.0
import SickLeaveRegister.Services 1.0
import MedicalDocument.Services 1.0
import MedicalCard.Services 1.0
import District.Services 1.0

import MedicalDocumentFullInfoView.Services 1.0
import SickLeaveFullInfoView.Services 1.0
import SickLeaveRegisterFullView.Services 1.0

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
    property color grayColor: "#607D8B"
    
    // Выбранные сущности
    property var selectedPatient: null
    property var selectedDoctor: null
    property string docType: "certificate"
    
    // Модели
    property var patientSuggestions: []
    property var doctorSuggestions: []
    property var documentsJournal: []
    property var sickLeavesJournal: []
    property var blankRegister: []

    ListModel { id: patientListModel }
    ListModel { id: doctorListModel }
    
    property var activePatientPopup: null
    property var activeDoctorPopup: null

    // Добавьте это свойство в начало файла (после остальных property)
    property bool switchToSickLeaveTab: false

    // Добавьте обработчик для этого свойства
    onSwitchToSickLeaveTabChanged: {
        if (switchToSickLeaveTab) {
            console.log("🔄 Переключаю на вкладку больничных")
            tabBar.currentIndex = 1  // Переключаем на больничные
            switchToSickLeaveTab = false  // Сбрасываем флаг
        }
    }

    // Добавьте в начало DocumentsView, после всех property
    // property var pendingPatient: null
    property var pendingPatientData: ({ patient: null, tabIndex: 0 })

    onPendingPatientDataChanged: {
        if (pendingPatientData.patient) {
            var patient = pendingPatientData.patient
            var targetTab = pendingPatientData.tabIndex  // 0 - справки, 1 - больничные
            
            console.log("📋 Получен пациент для вкладки", targetTab, ":", patient.full_name)
            
            // Переключаем вкладку
            tabBar.currentIndex = targetTab
            
            // Таймер для установки пациента
            universalTimer.patient = patient
            universalTimer.targetTab = targetTab
            universalTimer.start()
            
            pendingPatientData = { patient: null, tabIndex: 0 }
        }
    }

    Timer {
        id: universalTimer
        interval: 100
        property var patient: null
        property int targetTab: 0
        onTriggered: {
            if (patient) {
                console.log("✅ Устанавливаю пациента для вкладки", targetTab, ":", patient.full_name)
                selectedPatient = patient
                
                if (targetTab === 0) {
                    // Вкладка справок
                    docPatientSearch.text = patient.full_name
                    if (docPatientSuggestions.visible) docPatientSuggestions.close()
                    showSuccess("Пациент выбран для справки: " + patient.full_name)
                } else {
                    // Вкладка больничных
                    slPatientSearch.text = patient.full_name
                    if (slPatientSuggestions.visible) slPatientSuggestions.close()
                    showSuccess("Пациент выбран для больничного: " + patient.full_name)
                }
                
                patient = null
            }
        }
    }

    // ============================================
    // СИГНАЛЫ ДЛЯ СВЯЗИ С ДРУГИМИ КОМПОНЕНТАМИ
    // ============================================

    signal switchToPage(int index)
    signal switchToPageWithPatient(int index, var patient)

    onSwitchToPageWithPatient: {
        console.log("🔔 Получен пациент из поиска:", patient ? patient.full_name : "null")
        
        // Сбрасываем врача
        selectedDoctor = null
        
        // Определяем вкладку (1 - справки/запись, 4 - больничный)
        var targetTabIndex = 0  // по умолчанию справки (индекс 0)
        
        if (index === 1) {
            targetTabIndex = 0  // Вкладка "Справки"
        } else if (index === 4) {
            targetTabIndex = 1  // Вкладка "Больничные"
        }
        
        // Переключаем вкладку
        tabBar.currentIndex = targetTabIndex
        
        // Устанавливаем пациента
        selectedPatient = patient
        
        // Заполняем поле поиска в зависимости от вкладки
        if (targetTabIndex === 0) {
            docPatientSearch.text = patient.full_name
            if (docPatientSuggestions.visible) docPatientSuggestions.close()
        } else {
            slPatientSearch.text = patient.full_name
            if (slPatientSuggestions.visible) slPatientSuggestions.close()
        }
        
        showSuccess("Пациент выбран: " + patient.full_name)
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 20
    color: bgColor

    // ============================================
    // SNACKBARS
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
        x: (root.width - width) / 2
        y: root.height - 80
        padding: 0
        closePolicy: Popup.CloseOnEscape
        
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

    // ============================================
    // DIALOG: ВЫДАЧА БЛАНКОВ
    // ============================================

    // ============================================
// DIALOG: ПРОСМОТР БОЛЬНИЧНОГО
// ============================================
    Dialog {
        id: sickLeaveViewDialog
        width: 500
        height: implicitHeight
        anchors.centerIn: parent; modal: true
        title: "📄 Просмотр больничного листа"
        padding: 24
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle { 
            radius: 16; color: surfaceColor
            border.color: borderColor; border.width: 1
        }
        
        property string docTypeText: ""
        property string docNumber: ""
        property string patientName: ""
        property string doctorName: ""
        property string docDate: ""
        property string docContent: ""
        property string status: ""
        property string closedDate: ""
        
        contentItem: ColumnLayout {
            spacing: 20
            
            // Заголовок с иконкой
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: sickLeaveViewDialog.status === "open" ? successColor : grayColor
                    opacity: 0.15
                    
                    Text {
                        anchors.centerIn: parent
                        text: sickLeaveViewDialog.status === "open" ? "🏥" : "✅"
                        font.pixelSize: 24
                    }
                }
                
                Text {
                    text: "Больничный лист"
                    font.pixelSize: 18; font.weight: Font.DemiBold
                    color: textPrimary
                }
            }
            
            // Статус
            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                height: 28; radius: 14
                color: sickLeaveViewDialog.status === "open" ? successColor : grayColor
                Layout.preferredWidth: statusText.implicitWidth + 24
                
                Text {
                    id: statusText
                    anchors.centerIn: parent
                    text: sickLeaveViewDialog.status === "open" ? "Открыт" : "Закрыт"
                    font.pixelSize: 12; font.weight: Font.DemiBold
                    color: "#FFFFFF"
                }
            }
            
            // Карточка с данными
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: sickLeaveViewDialog.closedDate !== "" ? 240 : 200
                radius: 12
                color: bgColor
                border.color: borderColor; border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10
                    
                    // Номер бланка
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "📄"; font.pixelSize: 16 }
                        Text { 
                            text: "Бланк №" + sickLeaveViewDialog.docNumber
                            font.pixelSize: 14; font.weight: Font.DemiBold
                            color: primaryColor
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    // Пациент
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Пациент:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: sickLeaveViewDialog.patientName
                            font.pixelSize: 13; font.weight: Font.DemiBold
                            color: textPrimary; elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Врач
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Врач:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: sickLeaveViewDialog.doctorName
                            font.pixelSize: 13; color: textPrimary
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Дата открытия
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Открыт:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: sickLeaveViewDialog.docDate
                            font.pixelSize: 13; color: textPrimary
                        }
                    }
                    
                    // Дата закрытия (если есть)
                    Rectangle { 
                        Layout.fillWidth: true; height: 1; color: borderColor
                        visible: sickLeaveViewDialog.closedDate !== ""
                    }
                    // Даты
                    
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        visible: sickLeaveViewDialog.closedDate !== ""
                        Text { text: "Закрыт:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: sickLeaveViewDialog.closedDate
                            font.pixelSize: 13; color: dangerColor; font.weight: Font.DemiBold
                        }
                    }
                    
                    // Диагноз
                    Rectangle { 
                        Layout.fillWidth: true; height: 1; color: borderColor
                        visible: sickLeaveViewDialog.docContent !== ""
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        visible: sickLeaveViewDialog.docContent !== ""
                        Text { text: "Диагноз:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80; Layout.alignment: Qt.AlignTop }
                        Text { 
                            text: sickLeaveViewDialog.docContent
                            font.pixelSize: 12; color: textPrimary
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }
                    }
                }
            }
            
            // Кнопка закрыть
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                text: "✓ Закрыть"
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14; font.weight: Font.DemiBold
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 10
                    color: parent.hovered ? "#1565C0" : primaryColor
                }
                
                onClicked: sickLeaveViewDialog.close()
            }
        }
    }

    // ============================================
// DIALOG: ПРОСМОТР СУЩЕСТВУЮЩЕГО ДОКУМЕНТА
// ============================================
    Dialog {
        id: documentViewDialog
        width: 500; height: 400; anchors.centerIn: parent; modal: true
        title: "📄 Просмотр документа"
        padding: 24
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle { 
            radius: 16; color: surfaceColor
            border.color: borderColor; border.width: 1
        }
        
        property string docTypeText: ""
        property string docNumber: ""
        property string patientName: ""
        property string doctorName: ""
        property string docDate: ""
        property string docContent: ""
        
        contentItem: ColumnLayout {
            spacing: 20
            
            // Заголовок
            Text {
                text: documentViewDialog.docTypeText
                font.pixelSize: 18; font.weight: Font.DemiBold
                color: textPrimary
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Карточка с данными
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: documentViewDialog.docContent !== "" ? 220 : 180
                radius: 12
                color: bgColor
                border.color: borderColor; border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10
                    
                    // Номер документа
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "📋"; font.pixelSize: 16 }
                        Text { 
                            text: "Документ №" + documentViewDialog.docNumber
                            font.pixelSize: 14; font.weight: Font.DemiBold
                            color: primaryColor
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    // Пациент
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Пациент:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentViewDialog.patientName
                            font.pixelSize: 13; font.weight: Font.DemiBold
                            color: textPrimary; elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Врач
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Врач:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentViewDialog.doctorName
                            font.pixelSize: 13; color: textPrimary
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Дата
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Дата:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentViewDialog.docDate
                            font.pixelSize: 13; color: textPrimary
                        }
                    }
                    
                    Rectangle { 
                        Layout.fillWidth: true; height: 1; color: borderColor
                        visible: documentViewDialog.docContent !== ""
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        visible: documentViewDialog.docContent !== ""
                        Text { text: "Дополнительно:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80; Layout.alignment: Qt.AlignTop }
                        Text { 
                            text: documentViewDialog.docContent
                            font.pixelSize: 12; color: textPrimary
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }
                    }
                }
            }
            
            // Кнопка закрыть
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                text: "✓ Закрыть"
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14; font.weight: Font.DemiBold
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 10
                    color: parent.hovered ? "#1565C0" : primaryColor
                }
                
                onClicked: documentViewDialog.close()
            }
        }
    }

    // ============================================
// DIALOG: ПРОСМОТР ДОКУМЕНТА
// ============================================

    Dialog {
        id: documentPreviewDialog
        width: 500; height: 400; anchors.centerIn: parent; modal: true
        title: "📄 Документ оформлен"
        padding: 24
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        
        background: Rectangle { 
            radius: 16; color: surfaceColor
            border.color: borderColor; border.width: 1
        }
        
        property string docTypeText: ""
        property string docNumber: ""
        property string patientName: ""
        property string doctorName: ""
        property string docDate: ""
        property string docContent: ""
        
        contentItem: ColumnLayout {
            spacing: 20
            
            // Иконка успеха
            Rectangle {
                width: 64; height: 64; radius: 32
                color: successColor; opacity: 0.12
                Layout.alignment: Qt.AlignHCenter
                
                Text {
                    anchors.centerIn: parent
                    text: "✅"
                    font.pixelSize: 30
                }
            }
            
            Text {
                text: "Документ успешно оформлен!"
                font.pixelSize: 18; font.weight: Font.DemiBold
                color: textPrimary
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Карточка с данными
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: documentPreviewDialog.docContent !== "" ? 220 : 180
                radius: 12
                color: bgColor
                border.color: borderColor; border.width: 1
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10
                    
                    // Номер документа
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "📋"; font.pixelSize: 16 }
                        Text { 
                            text: "Документ №" + documentPreviewDialog.docNumber
                            font.pixelSize: 14; font.weight: Font.DemiBold
                            color: primaryColor
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                    
                    // Тип документа
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Тип:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Rectangle {
                            height: 24; radius: 12; color: primaryColor; opacity: 0.1
                            Layout.preferredWidth: typeText.implicitWidth + 20
                            Text {
                                id: typeText
                                anchors.centerIn: parent
                                text: documentPreviewDialog.docTypeText
                                font.pixelSize: 12; font.weight: Font.DemiBold
                                color: primaryColor
                            }
                        }
                    }
                    
                    // Пациент
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Пациент:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentPreviewDialog.patientName
                            font.pixelSize: 13; font.weight: Font.DemiBold
                            color: textPrimary; elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Врач
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Врач:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentPreviewDialog.doctorName
                            font.pixelSize: 13; color: textPrimary
                            Layout.fillWidth: true
                        }
                    }
                    
                    // Дата
                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        Text { text: "Дата:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80 }
                        Text { 
                            text: documentPreviewDialog.docDate
                            font.pixelSize: 13; color: textPrimary
                        }
                    }
                    Rectangle { 
                        Layout.fillWidth: true; height: 1; color: borderColor
                        visible: documentPreviewDialog.docContent !== ""
                    }

                    RowLayout {
                        Layout.fillWidth: true; spacing: 8
                        visible: documentPreviewDialog.docContent !== ""
                        Text { text: "Дополнительно:"; font.pixelSize: 12; color: textSecondary; Layout.preferredWidth: 80; Layout.alignment: Qt.AlignTop }
                        Text { 
                            text: documentPreviewDialog.docContent
                            font.pixelSize: 12; color: textPrimary
                            Layout.fillWidth: true
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                        }
                    }
                }
            }
            
            // Кнопка ОК
            Button {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                text: "✓ Хорошо"
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 14; font.weight: Font.DemiBold
                    color: "#FFFFFF"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                background: Rectangle {
                    radius: 10
                    color: parent.hovered ? "#43A047" : successColor
                }
                
                onClicked: documentPreviewDialog.close()
            }
        }
        onVisibleChanged: {
            console.log(`visible: ${documentPreviewDialog.visible}`)
        }
    }
    
    // Dialog {
    //     id: issueBlanksDialog
    //     width: 400; height: 300; anchors.centerIn: parent; modal: true
    //     title: "📋 Выдать бланки врачу"; standardButtons: Dialog.Ok | Dialog.Cancel; padding: 20
    //     background: Rectangle { radius: 12; color: surfaceColor; border.color: borderColor }
        
    //     property var selectedBlanksDoctor: null
        
    //     contentItem: ColumnLayout {
    //         spacing: 20
            
    //         Text { text: "Врач"; font.pixelSize: 12; color: textSecondary }
            
    //         Rectangle {
    //             Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8
    //             color: bgColor; border.color: borderColor; border.width: 1
                
    //             RowLayout {
    //                 anchors.fill: parent; anchors.margins: 4; spacing: 4
                    
    //                 TextField {
    //                     id: blanksDoctorSearch
    //                     Layout.fillWidth: true; placeholderText: "Поиск врача..."; placeholderTextColor: textLight
    //                     font.pixelSize: 13; color: textPrimary
    //                     background: Item {}
    //                     leftPadding: 8
    //                     onTextChanged: {
    //                         if (text.length >= 2) {
    //                             filterDoctors(text, blanksDoctorSuggestions)
    //                         } else {
    //                             doctorSuggestions = []
    //                             if (blanksDoctorSuggestions.visible) blanksDoctorSuggestions.close()
    //                         }
    //                     }
    //                 }
                    
    //                 Text { 
    //                     text: issueBlanksDialog.selectedBlanksDoctor ? "✅" : "🔍"
    //                     font.pixelSize: 14
    //                     color: issueBlanksDialog.selectedBlanksDoctor ? successColor : textSecondary 
    //                 }
    //             }
                
    //             Popup {
    //                 id: blanksDoctorSuggestions
    //                 y: parent.height + 4; width: parent.width
    //                 implicitHeight: Math.min(200, blanksDoctorList.contentHeight)
    //                 padding: 6; closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    //                 background: Rectangle { radius: 8; color: surfaceColor; border.color: borderColor }
                    
    //                 contentItem: ListView {
    //                     id: blanksDoctorList; clip: true; model: doctorSuggestions; spacing: 2
    //                     ScrollBar.vertical: ScrollBar {}
    //                     delegate: Rectangle {
    //                         width: ListView.view.width; height: 48
    //                         color: mouse.containsMouse ? hoverColor : "transparent"; radius: 6
                            
    //                         RowLayout {
    //                             anchors.fill: parent; anchors.margins: 10; spacing: 10
                                
    //                             Rectangle { width: 32; height: 32; radius: 16; color: successColor; opacity: 0.12
    //                                 Text { anchors.centerIn: parent; text: "👨‍⚕️"; font.pixelSize: 14 }
    //                             }
                                
    //                             ColumnLayout {
    //                                 Layout.fillWidth: true; spacing: 2
    //                                 Text { text: modelData.doctor_name || "—"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textPrimary; elide: Text.ElideRight }
    //                                 Text { text: (modelData.specialty_name || "—") + " · Каб. " + (modelData.room_number || "—"); font.pixelSize: 11; color: textSecondary }
    //                             }
    //                         }
                            
    //                         MouseArea {
    //                             id: mouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
    //                             onClicked: {
    //                                 issueBlanksDialog.selectedBlanksDoctor = modelData
    //                                 doctorSuggestions = []
    //                                 blanksDoctorSuggestions.close()
    //                             }
    //                         }
    //                     }
    //                 }
    //             }
    //         }
            
    //         Rectangle {
    //             Layout.fillWidth: true; height: 44; color: successColor; opacity: 0.08; radius: 8
    //             visible: issueBlanksDialog.selectedBlanksDoctor !== null
                
    //             RowLayout {
    //                 anchors.fill: parent; anchors.margins: 10; spacing: 8
    //                 Text { text: "✅"; font.pixelSize: 16 }
    //                 ColumnLayout {
    //                     Layout.fillWidth: true
    //                     Text { 
    //                         text: issueBlanksDialog.selectedBlanksDoctor ? issueBlanksDialog.selectedBlanksDoctor.doctor_name : ""
    //                         font.pixelSize: 14; font.weight: Font.DemiBold; color: successColor
    //                     }
    //                     Text { 
    //                         text: issueBlanksDialog.selectedBlanksDoctor ? (issueBlanksDialog.selectedBlanksDoctor.specialty_name || "—") : ""
    //                         font.pixelSize: 11; color: textSecondary
    //                     }
    //                 }
    //                 Button { 
    //                     text: "✕"; flat: true
    //                     onClicked: { 
    //                         issueBlanksDialog.selectedBlanksDoctor = null
    //                         blanksDoctorSearch.text = ""
    //                     }
    //                 }
    //             }
    //         }
            
    //         TextField {
    //             id: blanksCount; Layout.fillWidth: true; Layout.preferredHeight: 42
    //             placeholderText: "Количество бланков"; placeholderTextColor: textLight; font.pixelSize: 14; color: textPrimary
    //             background: Rectangle { radius: 8; color: bgColor; border.color: borderColor }
    //             validator: IntValidator { bottom: 1; top: blanksRemaining }
    //         }
            
    //         Text { text: "Доступно бланков: " + blanksRemaining; font.pixelSize: 13; color: textSecondary }
    //     }
        
    //     onAccepted: {
    //         if (!selectedBlanksDoctor) {
    //             showError("Выберите врача")
    //             return
    //         }
    //         issueBlanks()
    //     }
    // }

    // ============================================
    // MAIN LAYOUT
    // ============================================
    
    ColumnLayout {
        anchors.fill: parent; spacing: 20

        // Header
        Rectangle {
            Layout.fillWidth: true; Layout.preferredHeight: 64; color: surfaceColor; radius: 12
            
            RowLayout {
                anchors.fill: parent; anchors.margins: 16; spacing: 16
                
                Text { text: "📄 Документы"; font.pixelSize: 22; font.weight: Font.DemiBold; color: textPrimary }
                Item { Layout.fillWidth: true }
                
                TabBar {
                    id: tabBar
                    background: Rectangle { radius: 10; color: bgColor }
                    
                    TabButton {
                        text: "📋 Справки"; width: 140; height: 40
                        contentItem: Text { text: parent.text; font.pixelSize: 13; font.weight: Font.DemiBold; color: parent.checked ? primaryColor : textSecondary; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { radius: 8; color: parent.checked ? surfaceColor : "transparent" }
                    }
                    TabButton {
                        text: "📄 Больничные"; width: 150; height: 40
                        contentItem: Text { text: parent.text; font.pixelSize: 13; font.weight: Font.DemiBold; color: parent.checked ? primaryColor : textSecondary; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                        background: Rectangle { radius: 8; color: parent.checked ? surfaceColor : "transparent" }
                    }
                }
            }
        }

        StackLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; currentIndex: tabBar.currentIndex

            onCurrentIndexChanged: {
                // Сбрасываем выбранные сущности при переключении вкладок
                selectedPatient = null
                selectedDoctor = null
                
                // Очищаем поля поиска
                docPatientSearch.text = ""
                docDoctorSearch.text = ""
                slPatientSearch.text = ""
                slDoctorSearch.text = ""
                
                // Очищаем модели
                patientListModel.clear()
                doctorListModel.clear()
                
                // Закрываем все открытые попапы
                if (docPatientSuggestions.visible) docPatientSuggestions.close()
                if (docDoctorSuggestions.visible) docDoctorSuggestions.close()
                if (slPatientSuggestions.visible) slPatientSuggestions.close()
                if (slDoctorSuggestions.visible) slDoctorSuggestions.close()
            }
            // ============================================
            // TAB 1: СПРАВКИ
            // ============================================
            Rectangle { 
                color: "transparent"
                RowLayout { anchors.fill: parent; spacing: 20
                    
                    Rectangle { Layout.preferredWidth: parent.width * 0.45; Layout.fillHeight: true; color: surfaceColor; radius: 12
                        ScrollView {
                            anchors.fill: parent; anchors.margins: 20; clip: true
                            contentWidth: availableWidth
                            ColumnLayout { 
                                width: parent.width; spacing: 20
                                
                                Text { text: "📋 Оформление документа"; font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary }
                                
                                Flow { Layout.fillWidth: true; spacing: 8
                                    Repeater {
                                        model: [
                                            { text: "📋 Справка", value: "certificate" },
                                            { text: "📄 Направление", value: "referral" },
                                            { text: "💊 Рецепт", value: "prescription" },
                                            { text: "📑 Выписка", value: "extract" }
                                        ]
                                        Rectangle { width: 130; height: 40; radius: 20
                                            color: docType === modelData.value ? primaryColor : "transparent"
                                            border.color: docType === modelData.value ? primaryColor : borderColor; border.width: 1
                                            Text { anchors.centerIn: parent; text: modelData.text; font.pixelSize: 12; color: docType === modelData.value ? "#FFFFFF" : textPrimary }
                                            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: docType = modelData.value }
                                        }
                                    }
                                }
                                
                                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                                
                                // === ПОИСК ПАЦИЕНТА ===
                                Text { text: "Пациент"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                
                                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8; color: bgColor; border.color: borderColor
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 4
                                        TextField {
                                            id: docPatientSearch
                                            Layout.fillWidth: true; placeholderText: "Поиск пациента..."; placeholderTextColor: textLight
                                            font.pixelSize: 13; color: textPrimary; background: Item {}
                                            leftPadding: 8
                                            
                                            onTextChanged: {
                                                if (text.length < 2) {
                                                    patientListModel.clear()
                                                    if (docPatientSuggestions.visible) docPatientSuggestions.close()
                                                } else {
                                                    filterPatients(text, docPatientSuggestions)
                                                }
                                            }
                                        }
                                        Text { text: selectedPatient ? "✅" : "🔍"; font.pixelSize: 14; color: selectedPatient ? successColor : textSecondary }
                                    }
                                    
                                    Popup {
                                        id: docPatientSuggestions
                                        y: parent.height + 4
                                        width: parent.width
                                        height: Math.min(250, patientListModel.count * 56 + 12)
                                        padding: 6
                                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                                        background: Rectangle { radius: 8; color: surfaceColor; border.color: borderColor }
                                        
                                        contentItem: ListView {
                                            id: docPatientList
                                            anchors.fill: parent
                                            clip: true
                                            model: patientListModel
                                            spacing: 2
                                            ScrollBar.vertical: ScrollBar {}
                                            
                                            delegate: Rectangle {
                                                width: ListView.view.width
                                                height: 56
                                                color: mouseArea.containsMouse ? hoverColor : "transparent"
                                                radius: 6
                                                
                                                property var patientData: model.patientData
                                                property var popupRef: model.popupRef
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    spacing: 10
                                                    
                                                    Rectangle {
                                                        width: 36; height: 36; radius: 18
                                                        color: primaryColor; opacity: 0.12
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: "👤"
                                                            font.pixelSize: 16
                                                        }
                                                    }
                                                    
                                                    ColumnLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 2
                                                        Text {
                                                            text: patientData ? (patientData.full_name || "—") : "—"
                                                            font.pixelSize: 13
                                                            font.weight: Font.DemiBold
                                                            color: textPrimary
                                                            elide: Text.ElideRight
                                                        }
                                                        Text {
                                                            text: {
                                                                if (!patientData) return "—"
                                                                var dateStr = "—"
                                                                var d = patientData.birth_date
                                                                if (d) {
                                                                    if (typeof d === "string" && d.indexOf("-") !== -1) {
                                                                        var p = d.split("-")
                                                                        dateStr = p[2] + "." + p[1] + "." + p[0]
                                                                    } else if (d.getDate) {
                                                                        dateStr = d.getDate().toString().padStart(2,'0') + "." + (d.getMonth()+1).toString().padStart(2,'0') + "." + d.getFullYear()
                                                                    }
                                                                }
                                                                return "📅 " + dateStr + "  📞 " + (patientData.phone || "—")
                                                            }
                                                            font.pixelSize: 11
                                                            color: textSecondary
                                                            elide: Text.ElideRight
                                                        }
                                                    }
                                                }
                                                
                                                MouseArea {
                                                    id: mouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (patientData) {
                                                            selectedPatient = patientData
                                                        }
                                                        if (popupRef) {
                                                            docPatientSearch.text = patientData.full_name
                                                            popupRef.close()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle { 
                                    Layout.fillWidth: true; height: 56; radius: 10
                                    color: "#FFFFFF"
                                    border.color: successColor; border.width: 2
                                    visible: selectedPatient !== null
                                    
                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0; verticalOffset: 2; radius: 8
                                        samples: 17; color: "#00000015"
                                    }
                                    
                                    RowLayout { 
                                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                                        
                                        Rectangle {
                                            width: 40; height: 40; radius: 20
                                            color: successColor; opacity: 0.15
                                            Text {
                                                anchors.centerIn: parent
                                                text: "👤"
                                                font.pixelSize: 20
                                            }
                                        }
                                        
                                        ColumnLayout { 
                                            Layout.fillWidth: true; spacing: 2
                                            Text { 
                                                text: selectedPatient ? selectedPatient.full_name : ""
                                                font.pixelSize: 14; font.weight: Font.DemiBold; color: textPrimary
                                            }
                                            Text { 
                                                text: selectedPatient ? "📅 " + (formatDate(selectedPatient.birth_date) || "—") + "  📞 " + (selectedPatient.phone || "—") : ""
                                                font.pixelSize: 11; color: textSecondary
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 32; height: 32; radius: 16
                                            color: mouseArea.containsMouse ? "#E53935" : "#F44336"
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: 14; font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                            }
                                            
                                            MouseArea {
                                                id: mouseArea
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: { 
                                                    selectedPatient = null
                                                    docPatientSearch.text = ""
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                // === ПОИСК ВРАЧА ===
                                Text { text: "Врач"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                
                                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8; color: bgColor; border.color: borderColor
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 4
                                        TextField {
                                            id: docDoctorSearch
                                            Layout.fillWidth: true; placeholderText: "Поиск врача..."; placeholderTextColor: textLight
                                            font.pixelSize: 13; color: textPrimary; background: Item {}
                                            leftPadding: 8
                                            
                                            onTextChanged: {
                                                if (text.length < 2) {
                                                    doctorListModel.clear()
                                                    if (docDoctorSuggestions.visible) docDoctorSuggestions.close()
                                                } else {
                                                    filterDoctors(text, docDoctorSuggestions)
                                                }
                                            }
                                        }
                                        Text { text: selectedDoctor ? "✅" : "🔍"; font.pixelSize: 14; color: selectedDoctor ? successColor : textSecondary }
                                    }
                                    
                                    Popup {
                                        id: docDoctorSuggestions
                                        y: parent.height + 4
                                        width: parent.width
                                        height: Math.min(200, doctorListModel.count * 48 + 12)
                                        padding: 6
                                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                                        background: Rectangle { radius: 8; color: surfaceColor; border.color: borderColor }
                                        
                                        contentItem: ListView {
                                            id: docDoctorList
                                            anchors.fill: parent
                                            clip: true
                                            model: doctorListModel
                                            spacing: 2
                                            ScrollBar.vertical: ScrollBar {}
                                            
                                            delegate: Rectangle {
                                                width: ListView.view.width
                                                height: 48
                                                color: mouseArea.containsMouse ? hoverColor : "transparent"
                                                radius: 6
                                                
                                                property var doctorData: model.doctorData
                                                property var popupRef: model.popupRef
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    spacing: 10
                                                    
                                                    Rectangle {
                                                        width: 32; height: 32; radius: 16
                                                        color: successColor; opacity: 0.12
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: "👨‍⚕️"
                                                            font.pixelSize: 14
                                                        }
                                                    }
                                                    
                                                    ColumnLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 2
                                                        Text {
                                                            text: doctorData ? (doctorData.doctor_name || "—") : "—"
                                                            font.pixelSize: 13
                                                            font.weight: Font.DemiBold
                                                            color: textPrimary
                                                            elide: Text.ElideRight
                                                        }
                                                        Text {
                                                            text: doctorData ? ((doctorData.specialty_name || "—") + " · Каб. " + (doctorData.room_number || "—")) : "—"
                                                            font.pixelSize: 11
                                                            color: textSecondary
                                                        }
                                                    }
                                                }
                                                
                                                MouseArea {
                                                    id: mouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (doctorData) {
                                                            selectedDoctor = doctorData
                                                        }
                                                        if (popupRef) {
                                                            docDoctorSearch.text = doctorData.doctor_name
                                                            popupRef.close()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle { 
                                    Layout.fillWidth: true; height: 56; radius: 10
                                    color: "#FFFFFF"
                                    border.color: successColor; border.width: 2
                                    visible: selectedDoctor !== null
                                    
                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0; verticalOffset: 2; radius: 8
                                        samples: 17; color: "#00000015"
                                    }
                                    
                                    RowLayout { 
                                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                                        
                                        Rectangle {
                                            width: 40; height: 40; radius: 20
                                            color: successColor; opacity: 0.15
                                            Text {
                                                anchors.centerIn: parent
                                                text: "👨‍⚕️"
                                                font.pixelSize: 20
                                            }
                                        }
                                        
                                        ColumnLayout { 
                                            Layout.fillWidth: true; spacing: 2
                                            Text { 
                                                text: selectedDoctor ? selectedDoctor.doctor_name : ""
                                                font.pixelSize: 14; font.weight: Font.DemiBold; color: textPrimary
                                            }
                                            Text { 
                                                text: selectedDoctor ? (selectedDoctor.specialty_name || "—") + " · Каб. " + (selectedDoctor.room_number || "—") : ""
                                                font.pixelSize: 11; color: textSecondary
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 32; height: 32; radius: 16
                                            color: closeDoctorMouseArea.containsMouse ? "#E53935" : "#F44336"
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: 14; font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                            }
                                            
                                            MouseArea {
                                                id: closeDoctorMouseArea
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: { 
                                                    selectedDoctor = null
                                                    docDoctorSearch.text = ""
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle { Layout.fillWidth: true; height: 1; color: borderColor }
                                
                                Text { text: "Дополнительно"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                TextArea { id: docContent; Layout.fillWidth: true; Layout.preferredHeight: 80; placeholderText: "Текст документа..."; placeholderTextColor: textLight; font.pixelSize: 13; color: textPrimary
                                    background: Rectangle { radius: 8; color: bgColor; border.color: borderColor } }
                                
                                RowLayout { Layout.fillWidth: true; spacing: 12
                                    Button { Layout.fillWidth: true; Layout.preferredHeight: 44; text: "📝 Оформить"
                                        enabled: selectedPatient !== null && selectedDoctor !== null
                                        background: Rectangle { radius: 10; color: parent.enabled ? (parent.hovered ? Qt.darker(primaryColor,1.1) : primaryColor) : textLight }
                                        contentItem: Text { text: parent.text; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                        onClicked: createDocument()
                                    }
                                }
                            }
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: surfaceColor; radius: 12
                        ColumnLayout { anchors.fill: parent; anchors.margins: 1; spacing: 0
                            Text { 
                                text: "📋 Журнал выданных документов"
                                font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary
                                Layout.margins: 20
                                Layout.topMargin: 20
                            }
                            
                            // Table Header
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 44
                                Layout.margins: 16
                                Layout.topMargin: 12
                                color: bgColor
                                radius: 8
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 0
                                    
                                    Rectangle { width: 80; height: 44; color: "transparent"; Label { text: "Дата"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 160; height: 44; color: "transparent"; Label { text: "Пациент"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 100; height: 44; color: "transparent"; Label { text: "Тип"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 140; height: 44; color: "transparent"; Label { text: "Врач"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 50; height: 44; color: "transparent"; Label { text: ""; anchors.centerIn: parent } }
                                }
                            }
                            
                            // Table Body
                            ListView { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.margins: 16
                                clip: true
                                model: documentsJournal
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
                                            width: 80; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.date
                                                anchors.centerIn: parent
                                                font.pixelSize: 13
                                                color: "#1A1A1A"
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 160; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.patient || "—"
                                                anchors.centerIn: parent
                                                width: parent.width - 8
                                                font.pixelSize: 13; font.weight: Font.DemiBold
                                                color: "#1A1A1A"
                                                elide: Text.ElideRight
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 100; height: 52; color: "transparent"
                                            Rectangle {
                                                height: 24; radius: 12
                                                width: typeText.implicitWidth + 20
                                                color: primaryColor; opacity: 0.1
                                                anchors.centerIn: parent
                                                
                                                Text {
                                                    id: typeText
                                                    anchors.centerIn: parent
                                                    text: modelData.type || "—"
                                                    font.pixelSize: 11; font.weight: Font.DemiBold
                                                    color: primaryColor
                                                }
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 140; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.doctor || "—"
                                                anchors.centerIn: parent
                                                width: parent.width - 8
                                                font.pixelSize: 13
                                                color: "#555555"
                                                elide: Text.ElideRight
                                            }
                                        }
                                        
                                        // Кнопка просмотра
                                        Rectangle {
                                            width: 50; height: 52; color: "transparent"
                                            
                                            Rectangle {
                                                width: 32; height: 32; radius: 6
                                                color: viewBtnMouse.containsMouse ? primaryColor : "transparent"
                                                border.color: primaryColor; border.width: 1
                                                anchors.centerIn: parent
                                                
                                                Behavior on color { ColorAnimation { duration: 150 } }
                                                
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "👁"
                                                    font.pixelSize: 14
                                                }
                                                
                                                MouseArea {
                                                    id: viewBtnMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        try {
                                                            var docs = MedicalDocumentFullInfoViewService.search([
                                                                {"field": "id", "operator": "eq", "value": modelData.id}
                                                            ])
                                                            if (docs.length > 0) {
                                                                var doc = docs[0]
                                                                var types = {"certificate":"Справка","referral":"Направление","prescription":"Рецепт","extract":"Выписка"}
                                                                
                                                                documentViewDialog.docTypeText = types[doc.document_type] || doc.document_type
                                                                documentViewDialog.docNumber = doc.document_number || "—"
                                                                documentViewDialog.patientName = doc.patient_name || modelData.patient
                                                                documentViewDialog.doctorName = doc.doctor_name || modelData.doctor
                                                                documentViewDialog.docDate = formatDate(doc.created_at) || modelData.date
                                                                documentViewDialog.docContent = doc.content || ""
                                                                documentViewDialog.open()
                                                            }
                                                        } catch(e) {
                                                            console.error("Ошибка загрузки документа:", e)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    MouseArea {
                                        id: rowMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: "Нет выданных документов"
                                    font.pixelSize: 14
                                    color: textLight
                                    visible: documentsJournal.length === 0
                                }
                            }
                        }
                    }
                }
            }

            // ============================================
            // TAB 2: БОЛЬНИЧНЫЕ
            // ============================================
            Rectangle { color: "transparent"
                RowLayout { anchors.fill: parent; spacing: 20
                    
                    Rectangle { Layout.preferredWidth: parent.width * 0.45; Layout.fillHeight: true; color: surfaceColor; radius: 12
                        ScrollView {
                            anchors.fill: parent; anchors.margins: 20; clip: true
                            contentWidth: availableWidth
                            ColumnLayout { width: parent.width; spacing: 20
                                
                                Text { text: "📄 Оформление больничного"; font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary }
                                
                                Text { text: "Пациент"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                
                                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8; color: bgColor; border.color: borderColor
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 4
                                        TextField {
                                            id: slPatientSearch
                                            Layout.fillWidth: true; placeholderText: "Поиск пациента..."; placeholderTextColor: textLight
                                            font.pixelSize: 13; color: textPrimary; background: Item {}
                                            leftPadding: 8
                                            
                                            onTextChanged: {
                                                if (text.length < 2) {
                                                    patientListModel.clear()
                                                    if (slPatientSuggestions.visible) slPatientSuggestions.close()
                                                } else {
                                                    filterPatients(text, slPatientSuggestions)
                                                }
                                            }
                                        }
                                        Text { text: selectedPatient ? "✅" : "🔍"; font.pixelSize: 14; color: selectedPatient ? successColor : textSecondary }
                                    }
                                    
                                    Popup {
                                        id: slPatientSuggestions
                                        y: parent.height + 4; width: parent.width
                                        height: Math.min(250, patientListModel.count * 56 + 12)
                                        padding: 6
                                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                                        background: Rectangle { radius: 8; color: surfaceColor; border.color: borderColor }
                                        
                                        contentItem: ListView {
                                            id: slPatientList
                                            anchors.fill: parent
                                            clip: true
                                            model: patientListModel
                                            spacing: 2
                                            ScrollBar.vertical: ScrollBar {}
                                            
                                            delegate: Rectangle {
                                                width: ListView.view.width
                                                height: 56
                                                color: mouseArea.containsMouse ? hoverColor : "transparent"
                                                radius: 6
                                                
                                                property var patientData: model.patientData
                                                property var popupRef: model.popupRef
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    spacing: 10
                                                    
                                                    Rectangle {
                                                        width: 36; height: 36; radius: 18
                                                        color: primaryColor; opacity: 0.12
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: "👤"
                                                            font.pixelSize: 16
                                                        }
                                                    }
                                                    
                                                    ColumnLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 2
                                                        Text {
                                                            text: patientData ? (patientData.full_name || "—") : "—"
                                                            font.pixelSize: 13
                                                            font.weight: Font.DemiBold
                                                            color: textPrimary
                                                            elide: Text.ElideRight
                                                        }
                                                        Text {
                                                            text: {
                                                                if (!patientData) return "—"
                                                                var dateStr = "—"
                                                                var d = patientData.birth_date
                                                                if (d) {
                                                                    if (typeof d === "string" && d.indexOf("-") !== -1) {
                                                                        var p = d.split("-")
                                                                        dateStr = p[2] + "." + p[1] + "." + p[0]
                                                                    } else if (d.getDate) {
                                                                        dateStr = d.getDate().toString().padStart(2,'0') + "." + (d.getMonth()+1).toString().padStart(2,'0') + "." + d.getFullYear()
                                                                    }
                                                                }
                                                                return "📅 " + dateStr + "  📞 " + (patientData.phone || "—")
                                                            }
                                                            font.pixelSize: 11
                                                            color: textSecondary
                                                            elide: Text.ElideRight
                                                        }
                                                    }
                                                }
                                                
                                                MouseArea {
                                                    id: mouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (patientData) {
                                                            selectedPatient = patientData
                                                        }
                                                        if (popupRef) {
                                                            slPatientSearch.text = patientData.full_name
                                                            popupRef.close()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle { 
                                    Layout.fillWidth: true; height: 56; radius: 10
                                    color: "#FFFFFF"
                                    border.color: successColor; border.width: 2
                                    visible: selectedPatient !== null
                                    
                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0; verticalOffset: 2; radius: 8
                                        samples: 17; color: "#00000015"
                                    }
                                    
                                    RowLayout { 
                                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                                        
                                        Rectangle {
                                            width: 40; height: 40; radius: 20
                                            color: successColor; opacity: 0.15
                                            Text {
                                                anchors.centerIn: parent
                                                text: "👤"
                                                font.pixelSize: 20
                                            }
                                        }
                                        
                                        ColumnLayout { 
                                            Layout.fillWidth: true; spacing: 2
                                            Text { 
                                                text: selectedPatient ? selectedPatient.full_name : ""
                                                font.pixelSize: 14; font.weight: Font.DemiBold; color: textPrimary
                                            }
                                            Text { 
                                                text: selectedPatient ? "📅 " + (formatDate(selectedPatient.birth_date) || "—") + "  📞 " + (selectedPatient.phone || "—") : ""
                                                font.pixelSize: 11; color: textSecondary
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 32; height: 32; radius: 16
                                            color: closePatientMouseArea.containsMouse ? "#E53935" : "#F44336"
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: 14; font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                            }
                                            
                                            MouseArea {
                                                id: closePatientMouseArea
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: { 
                                                    selectedPatient = null
                                                    docPatientSearch.text = ""
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Text { text: "Врач"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                
                                Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8; color: bgColor; border.color: borderColor
                                    RowLayout { anchors.fill: parent; anchors.margins: 4; spacing: 4
                                        TextField {
                                            id: slDoctorSearch
                                            Layout.fillWidth: true; placeholderText: "Поиск врача..."; placeholderTextColor: textLight
                                            font.pixelSize: 13; color: textPrimary; background: Item {}
                                            leftPadding: 8
                                            
                                            onTextChanged: {
                                                if (text.length < 2) {
                                                    doctorListModel.clear()
                                                    if (slDoctorSuggestions.visible) slDoctorSuggestions.close()
                                                } else {
                                                    filterDoctors(text, slDoctorSuggestions)
                                                }
                                            }
                                        }
                                        Text { text: selectedDoctor ? "✅" : "🔍"; font.pixelSize: 14; color: selectedDoctor ? successColor : textSecondary }
                                    }
                                    
                                    Popup {
                                        id: slDoctorSuggestions
                                        y: parent.height + 4; width: parent.width
                                        height: Math.min(200, doctorListModel.count * 48 + 12)
                                        padding: 6
                                        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
                                        background: Rectangle { radius: 8; color: surfaceColor; border.color: borderColor }
                                        
                                        contentItem: ListView {
                                            id: slDoctorList
                                            anchors.fill: parent
                                            clip: true
                                            model: doctorListModel
                                            spacing: 2
                                            ScrollBar.vertical: ScrollBar {}
                                            
                                            delegate: Rectangle {
                                                width: ListView.view.width
                                                height: 48
                                                color: mouseArea.containsMouse ? hoverColor : "transparent"
                                                radius: 6
                                                
                                                property var doctorData: model.doctorData
                                                property var popupRef: model.popupRef
                                                
                                                RowLayout {
                                                    anchors.fill: parent
                                                    anchors.margins: 10
                                                    spacing: 10
                                                    
                                                    Rectangle {
                                                        width: 32; height: 32; radius: 16
                                                        color: successColor; opacity: 0.12
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: "👨‍⚕️"
                                                            font.pixelSize: 14
                                                        }
                                                    }
                                                    
                                                    ColumnLayout {
                                                        Layout.fillWidth: true
                                                        spacing: 2
                                                        Text {
                                                            text: doctorData ? (doctorData.doctor_name || "—") : "—"
                                                            font.pixelSize: 13
                                                            font.weight: Font.DemiBold
                                                            color: textPrimary
                                                            elide: Text.ElideRight
                                                        }
                                                        Text {
                                                            text: doctorData ? ((doctorData.specialty_name || "—") + " · Каб. " + (doctorData.room_number || "—")) : "—"
                                                            font.pixelSize: 11
                                                            color: textSecondary
                                                        }
                                                    }
                                                }
                                                
                                                MouseArea {
                                                    id: mouseArea
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        if (doctorData) {
                                                            selectedDoctor = doctorData
                                                        }
                                                        if (popupRef) {
                                                            slDoctorSearch.text = doctorData.doctor_name
                                                            popupRef.close()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Rectangle { 
                                    Layout.fillWidth: true; height: 56; radius: 10
                                    color: "#FFFFFF"
                                    border.color: successColor; border.width: 2
                                    visible: selectedDoctor !== null
                                    
                                    layer.enabled: true
                                    layer.effect: DropShadow {
                                        horizontalOffset: 0; verticalOffset: 2; radius: 8
                                        samples: 17; color: "#00000015"
                                    }
                                    
                                    RowLayout { 
                                        anchors.fill: parent; anchors.margins: 12; spacing: 12
                                        
                                        Rectangle {
                                            width: 40; height: 40; radius: 20
                                            color: successColor; opacity: 0.15
                                            Text {
                                                anchors.centerIn: parent
                                                text: "👨‍⚕️"
                                                font.pixelSize: 20
                                            }
                                        }
                                        
                                        ColumnLayout { 
                                            Layout.fillWidth: true; spacing: 2
                                            Text { 
                                                text: selectedDoctor ? selectedDoctor.doctor_name : ""
                                                font.pixelSize: 14; font.weight: Font.DemiBold; color: textPrimary
                                            }
                                            Text { 
                                                text: selectedDoctor ? (selectedDoctor.specialty_name || "—") + " · Каб. " + (selectedDoctor.room_number || "—") : ""
                                                font.pixelSize: 11; color: textSecondary
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 32; height: 32; radius: 16
                                            color: closeSLDoctorMouseArea.containsMouse ? "#E53935" : "#F44336"
                                            
                                            Text {
                                                anchors.centerIn: parent
                                                text: "✕"
                                                font.pixelSize: 14; font.weight: Font.DemiBold
                                                color: "#FFFFFF"
                                            }
                                            
                                            MouseArea {
                                                id: closeSLDoctorMouseArea
                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked: { 
                                                    selectedDoctor = null
                                                    docDoctorSearch.text = ""
                                                }
                                            }
                                        }
                                    }
                                }

                                Text { text: "Номер бланка"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }

                                Rectangle {
                                    Layout.fillWidth: true; Layout.preferredHeight: 42; radius: 8
                                    color: bgColor; border.color: borderColor
                                    
                                    RowLayout {
                                        anchors.fill: parent; anchors.margins: 12; spacing: 8
                                        
                                        Text {
                                            text: "📄"
                                            font.pixelSize: 16
                                        }
                                        
                                        Text {
                                            id: autoBlankNumber
                                            text: "БЛ-" + Qt.formatDate(new Date(), "yyyy") + "-" + (sickLeavesJournal.length + 1).toString().padStart(4, '0')
                                            font.pixelSize: 14; font.weight: Font.DemiBold
                                            color: primaryColor
                                            Layout.fillWidth: true
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        
                                        Text {
                                            text: "(авто)"
                                            font.pixelSize: 10
                                            color: textLight
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                    }
                                }
                                
                                // Даты
                                // Даты
                                RowLayout { Layout.fillWidth: true; spacing: 12
                                    ColumnLayout { Layout.fillWidth: true; spacing: 6
                                        Text { text: "Дата открытия *"; font.pixelSize: 12; color: textSecondary }
                                        RowLayout {
                                            Layout.fillWidth: true; spacing: 4
                                            TextField { 
                                                id: slOpenDate
                                                Layout.fillWidth: true; Layout.preferredHeight: 42
                                                text: Qt.formatDate(new Date(), "dd.MM.yyyy")
                                                font.pixelSize: 13; color: textPrimary
                                                background: Rectangle { radius: 8; color: bgColor; border.color: borderColor } 
                                            }
                                            // Кнопка "Сегодня" для даты открытия
                                            Rectangle {
                                                width: 70; height: 42; radius: 8
                                                color: openTodayMouse.containsMouse ? primaryColor : "transparent"
                                                border.color: primaryColor; border.width: 1
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Сегодня"
                                                    font.pixelSize: 11; font.weight: Font.DemiBold
                                                    color: openTodayMouse.containsMouse ? "#FFFFFF" : primaryColor
                                                }
                                                MouseArea {
                                                    id: openTodayMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: slOpenDate.text = Qt.formatDate(new Date(), "dd.MM.yyyy")
                                                }
                                            }
                                        }
                                    }
                                    ColumnLayout { Layout.fillWidth: true; spacing: 6
                                        Text { text: "Дата закрытия *"; font.pixelSize: 12; color: textSecondary }
                                        RowLayout {
                                            Layout.fillWidth: true; spacing: 4
                                            TextField { 
                                                id: slCloseDate
                                                Layout.fillWidth: true; Layout.preferredHeight: 42
                                                text: Qt.formatDate(new Date(), "dd.MM.yyyy")
                                                font.pixelSize: 13; color: textPrimary
                                                background: Rectangle { radius: 8; color: bgColor; border.color: borderColor } 
                                            }
                                            // Кнопка "Сегодня" для даты закрытия
                                            Rectangle {
                                                width: 70; height: 42; radius: 8
                                                color: closeTodayMouse.containsMouse ? primaryColor : "transparent"
                                                border.color: primaryColor; border.width: 1
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Сегодня"
                                                    font.pixelSize: 11; font.weight: Font.DemiBold
                                                    color: closeTodayMouse.containsMouse ? "#FFFFFF" : primaryColor
                                                }
                                                MouseArea {
                                                    id: closeTodayMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: slCloseDate.text = Qt.formatDate(new Date(), "dd.MM.yyyy")
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                Text { text: "Диагноз"; font.pixelSize: 13; font.weight: Font.DemiBold; color: textSecondary }
                                ComboBox { id: diagnosisCombo; Layout.fillWidth: true; Layout.preferredHeight: 42; model: []
                                    background: Rectangle { radius: 8; color: bgColor; border.color: borderColor }
                                    contentItem: Text { text: diagnosisCombo.currentText; font.pixelSize: 13; color: textPrimary; verticalAlignment: Text.AlignVCenter; leftPadding: 12 }
                                }
                                
                                RowLayout { Layout.fillWidth: true; spacing: 12
                                    Button { Layout.fillWidth: true; Layout.preferredHeight: 44; text: "📝 Оформить"
                                        enabled: selectedPatient !== null && selectedDoctor !== null
                                        background: Rectangle { radius: 10; color: parent.enabled ? (parent.hovered ? Qt.darker(primaryColor,1.1) : primaryColor) : textLight }
                                        contentItem: Text { text: parent.text; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter }
                                        onClicked: createSickLeave()
                                    }
                                }
                            }
                        }
                    }
                    
                    Rectangle { Layout.fillWidth: true; Layout.fillHeight: true; color: surfaceColor; radius: 12
                        ColumnLayout { anchors.fill: parent; anchors.margins: 1; spacing: 0
                            Text { 
                                text: "📄 Журнал больничных"
                                font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary
                                Layout.margins: 20
                                Layout.topMargin: 20
                            }
                            
                            // Table Header
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 44
                                Layout.margins: 16
                                Layout.topMargin: 12
                                color: bgColor
                                radius: 8
                                
                                Row {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 0
                                    
                                    Rectangle { width: 120; height: 44; color: "transparent"; Label { text: "№ бланка"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { Layout.fillWidth: true; height: 44; color: "transparent"; Label { text: "Пациент"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 150; height: 44; color: "transparent"; Label { text: "Врач"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 90; height: 44; color: "transparent"; Label { text: "Открыт"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 90; height: 44; color: "transparent"; Label { text: "Закрыт"; anchors.centerIn: parent; font.pixelSize: 12; font.weight: Font.DemiBold; color: textSecondary } }
                                    Rectangle { width: 50; height: 44; color: "transparent"; Label { text: ""; anchors.centerIn: parent } }
                                }
                            }
                            
                            // Table Body
                            ListView { 
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.margins: 16
                                clip: true
                                model: sickLeavesJournal
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
                                            width: 120; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.number
                                                anchors.centerIn: parent
                                                font.pixelSize: 13; font.weight: Font.DemiBold
                                                color: primaryColor
                                                elide: Text.ElideRight
                                            }
                                        }
                                        
                                        Rectangle {
                                            Layout.fillWidth: true; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.patient || "—"
                                                anchors.centerIn: parent
                                                width: parent.width - 8
                                                font.pixelSize: 13; font.weight: Font.DemiBold
                                                color: "#1A1A1A"
                                                elide: Text.ElideRight
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 150; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.doctor || "—"
                                                anchors.centerIn: parent
                                                width: parent.width - 8
                                                font.pixelSize: 13
                                                color: "#555555"
                                                elide: Text.ElideRight
                                            }
                                        }
                                        
                                        Rectangle {
                                            width: 90; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.opened
                                                anchors.centerIn: parent
                                                font.pixelSize: 13
                                                color: "#1A1A1A"
                                            }
                                        }
                                        
                                         Rectangle {
                                            width: 90; height: 52; color: "transparent"
                                            Text {
                                                text: modelData.closed || "—"
                                                anchors.centerIn: parent
                                                font.pixelSize: 13
                                                color: modelData.closed !== "—" ? dangerColor : textSecondary
                                            }
                                        }

                                        Rectangle {
                                            width: 50; height: 52; color: "transparent"
                                            
                                            Rectangle {
                                                width: 32; height: 32; radius: 6
                                                color: slViewBtnMouse.containsMouse ? primaryColor : "transparent"
                                                border.color: primaryColor; border.width: 1
                                                anchors.centerIn: parent
                                                
                                                Behavior on color { ColorAnimation { duration: 150 } }
                                                
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "👁"
                                                    font.pixelSize: 14
                                                }
                                                
                                                MouseArea {
                                                    id: slViewBtnMouse
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: {
                                                        try {
                                                            var sickLeaves = SickLeaveFullInfoViewService.search([
                                                                {"field": "id", "operator": "eq", "value": modelData.id}
                                                            ])
                                                            if (sickLeaves.length > 0) {
                                                                var sl = sickLeaves[0]
                                                                
                                                                sickLeaveViewDialog.docTypeText = "Больничный лист"
                                                                sickLeaveViewDialog.docNumber = sl.sick_leave_number || modelData.number
                                                                sickLeaveViewDialog.patientName = sl.patient_name || modelData.patient
                                                                sickLeaveViewDialog.doctorName = sl.doctor_name || modelData.doctor
                                                                sickLeaveViewDialog.docDate = formatDate(sl.opened_at) || modelData.opened
                                                                sickLeaveViewDialog.closedDate = sl.closed_at ? formatDate(sl.closed_at) : ""
                                                                sickLeaveViewDialog.docContent = "Диагноз: " + (sl.initial_diagnosis_name || sl.initial_diagnosis || "—")
                                                                sickLeaveViewDialog.open()
                                                            }
                                                        } catch(e) {
                                                            console.error("Ошибка загрузки больничного:", e)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                    MouseArea {
                                        id: rowMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        acceptedButtons: Qt.NoButton
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ============================================
            // TAB 3: КНИГА УЧЁТА
            // ============================================
            // Rectangle { color: surfaceColor; radius: 12
            //     ColumnLayout { anchors.fill: parent; anchors.margins: 20; spacing: 20
                    
            //         RowLayout { Layout.fillWidth: true
            //             Text { text: "📊 Книга регистрации листков нетрудоспособности"; font.pixelSize: 16; font.weight: Font.DemiBold; color: textPrimary; Layout.fillWidth: true }
            //             Button { text: "📋 Выдать бланки"; Layout.preferredHeight: 42
            //                 background: Rectangle { radius: 8; color: parent.hovered ? Qt.darker(successColor,1.1) : successColor }
            //                 contentItem: Text { text: parent.text; font.pixelSize: 13; font.weight: Font.DemiBold; color: "#FFFFFF"; horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter; leftPadding: 16; rightPadding: 16 }
            //                 onClicked: issueBlanksDialog.open()
            //             }
            //         }
                    
            //         Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 50; radius: 25; color: primaryColor; opacity: 0.1
            //             Text { anchors.centerIn: parent; text: "📦 Остаток бланков: " + blanksRemaining; font.pixelSize: 16; font.weight: Font.DemiBold; color: primaryColor }
            //         }
                    
            //         Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 40; color: bgColor; radius: 6
            //             Row { anchors.fill: parent; anchors.margins: 10
            //                 Label { text: "Дата выдачи"; width: 100; font.pixelSize: 11; font.weight: Font.DemiBold; color: textSecondary }
            //                 Label { text: "Врач"; width: 160; font.pixelSize: 11; font.weight: Font.DemiBold; color: textSecondary }
            //                 Label { text: "Номера бланков"; width: 180; font.pixelSize: 11; font.weight: Font.DemiBold; color: textSecondary }
            //                 Label { text: "Кол-во"; width: 70; font.pixelSize: 11; font.weight: Font.DemiBold; color: textSecondary }
            //                 Label { text: "Выдал"; width: 140; font.pixelSize: 11; font.weight: Font.DemiBold; color: textSecondary }
            //             }
            //         }
                    
            //         ListView { Layout.fillWidth: true; Layout.fillHeight: true; clip: true; model: blankRegister; spacing: 3
            //             ScrollBar.vertical: ScrollBar {}
            //             delegate: Rectangle { width: ListView.view.width; height: 40; color: index%2===0 ? "transparent" : bgColor; radius: 4
            //                 Row { anchors.fill: parent; anchors.margins: 10
            //                     Text { text: modelData.date; width: 100; font.pixelSize: 12; color: textPrimary; verticalAlignment: Text.AlignVCenter }
            //                     Text { text: modelData.doctor; width: 160; font.pixelSize: 12; color: textPrimary; verticalAlignment: Text.AlignVCenter }
            //                     Text { text: modelData.numbers; width: 180; font.pixelSize: 12; color: textPrimary; verticalAlignment: Text.AlignVCenter }
            //                     Text { text: modelData.count; width: 70; font.pixelSize: 13; font.weight: Font.DemiBold; color: primaryColor; verticalAlignment: Text.AlignVCenter }
            //                     Text { text: modelData.issued_by; width: 140; font.pixelSize: 12; color: textPrimary; verticalAlignment: Text.AlignVCenter }
            //                 }
            //             }
            //         }
            //     }
            // }
        }
    }

    // ============================================
    // FUNCTIONS
    // ============================================

    function loadFullPatientData(patient) {
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
        } catch (e) {
            console.error("Error loading full patient data:", e)
        }
        return patient
    }

    function formatDate(dateValue) {
        if (!dateValue) return "—"
        if (typeof dateValue === "object" && dateValue.getDate) {
            return (dateValue.getDate().toString().padStart(2,'0') + "." + (dateValue.getMonth()+1).toString().padStart(2,'0') + "." + dateValue.getFullYear())
        }
        var str = dateValue.toString()
        if (str.indexOf("-") !== -1) { var p = str.split("-"); return p[2]+"."+p[1]+"."+p[0] }
        return str
    }
    
    function showSuccess(msg) { successSnackbar.text = msg; successSnackbar.open() }
    function showError(msg) { errorSnackbar.text = msg; errorSnackbar.open() }
    
    function filterPatients(text, popup) {
        if (!popup || text.length < 2) {
            patientListModel.clear()
            if (popup) popup.close()
            return
        }
        try {
            var res = PatientService.search([
                {"field": "full_name", "operator": "like", "value": "%" + text + "%"}
            ])
            patientListModel.clear()
            for (var i = 0; i < res.length; i++) {
                patientListModel.append({
                    patientData: res[i],
                    popupRef: popup
                })
            }
            if (res.length > 0) {
                popup.height = Math.min(250, res.length * 56 + 12)
                popup.open()
            } else {
                popup.close()
            }
        } catch(e) { 
            console.error(e)
            patientListModel.clear()
            if (popup) popup.close()
        }
    }

    function filterDoctors(text, popup) {
        if (!popup || text.length < 2) {
            doctorListModel.clear()
            if (popup) popup.close()
            return
        }
        try {
            var res = DoctorFullInfoViewService.search([
                {"field": "doctor_name", "operator": "like", "value": "%" + text + "%"},
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            doctorListModel.clear()
            for (var i = 0; i < res.length; i++) {
                doctorListModel.append({
                    doctorData: res[i],
                    popupRef: popup
                })
            }
            if (res.length > 0) {
                popup.height = Math.min(200, res.length * 48 + 12)
                popup.open()
            } else {
                popup.close()
            }
        } catch(e) { 
            console.error(e)
            doctorListModel.clear()
            if (popup) popup.close()
        }
    }
    
    function createDocument() {
        if (!selectedPatient || !selectedDoctor) { showError("Выберите пациента и врача"); return }
        try {
            var types = {"certificate":"Справка","referral":"Направление","prescription":"Рецепт","extract":"Выписка"}
            var docNumber = "С-"+Qt.formatDate(new Date(),"yyyy")+"-"+(documentsJournal.length+1).toString().padStart(4,'0')
            var docDate = Qt.formatDate(new Date(),"dd.MM.yyyy")
            
            console.log("📄 СОЗДАНИЕ ДОКУМЕНТА")
            console.log("Тип:", types[docType])
            console.log("Номер:", docNumber)
            
            var r = MedicalDocumentService.add({
                document_type: docType, 
                document_number: docNumber, 
                id_patient: selectedPatient.id, 
                id_doctor: selectedDoctor.doctor_id, 
                id_registrar: 1, 
                content: docContent.text, 
                created_at: new Date().toISOString()
            })
            
            console.log("Результат add:", r)
            
            if (r) {
                // Получаем ID созданного документа
                var newDocId = -1
                try {
                    var newDocs = MedicalDocumentService.search([
                        {"field": "document_number", "operator": "eq", "value": docNumber}
                    ])
                    if (newDocs.length > 0) {
                        newDocId = newDocs[0].id
                        console.log("ID созданного документа:", newDocId)
                    }
                } catch(e) {
                    console.log("Не удалось получить ID:", e)
                }
                
                // Используем ID из поиска или временный
                var actualId = newDocId > 0 ? newDocId : (documentsJournal.length + 1)
                
                documentsJournal.unshift({
                    id: actualId,
                    date: docDate, 
                    patient: selectedPatient.full_name, 
                    type: types[docType], 
                    doctor: selectedDoctor.doctor_name,
                    content: docContent.text
                })
                
                // Принудительно обновляем массив
                var temp = []
                for (var i = 0; i < documentsJournal.length; i++) {
                    temp.push(documentsJournal[i])
                }
                documentsJournal = temp
                
                // Показываем диалог успеха
                documentPreviewDialog.docTypeText = types[docType]
                documentPreviewDialog.docNumber = docNumber
                documentPreviewDialog.patientName = selectedPatient.full_name
                documentPreviewDialog.doctorName = selectedDoctor.doctor_name
                documentPreviewDialog.docDate = docDate
                documentPreviewDialog.docContent = docContent.text
                
                console.log("📌 ОТКРЫВАЮ ДИАЛОГ, actualId:", actualId)
                documentPreviewDialog.open()
                
                docContent.text = ""
                showSuccess("Документ " + docNumber + " оформлен")
                
            } else {
                showError("Ошибка создания документа")
            }
        } catch (e) { 
            console.log("❌ Исключение:", e)
            showError("Ошибка оформления") 
        }
    }
    
    function validateDate(dateStr, fieldName) {
    // Пустая строка
    if (!dateStr || dateStr.trim() === "") {
        return { valid: false, error: "Укажите " + fieldName }
    }
    
    // Формат с точками
    if (dateStr.indexOf(".") === -1) {
        return { valid: false, error: "Неверный формат " + fieldName + ". Используйте ДД.ММ.ГГГГ" }
    }
    
    var parts = dateStr.split(".")
    if (parts.length !== 3) {
        return { valid: false, error: "Неверный формат " + fieldName + ". Используйте ДД.ММ.ГГГГ" }
    }
    
    var day = parseInt(parts[0])
    var month = parseInt(parts[1])
    var year = parseInt(parts[2])
    
    // Проверка, что все части - числа
    if (isNaN(day) || isNaN(month) || isNaN(year)) {
        return { valid: false, error: fieldName + " содержит недопустимые символы" }
    }
    
    // Проверка года (1900-2100)
    if (year < 1900 || year > 2100) {
        return { valid: false, error: "Год " + fieldName + " должен быть между 1900 и 2100" }
    }
    
    // Проверка месяца (1-12)
    if (month < 1 || month > 12) {
        return { valid: false, error: "Месяц " + fieldName + " должен быть от 1 до 12" }
    }
    
    // Проверка дня с учётом количества дней в месяце
    var daysInMonth = new Date(year, month, 0).getDate()
    if (day < 1 || day > daysInMonth) {
        return { valid: false, error: "День " + fieldName + " должен быть от 1 до " + daysInMonth }
    }
    
    return { 
        valid: true, 
        date: new Date(year, month - 1, day), 
        day: day, 
        month: month, 
        year: year 
    }
}

    function createSickLeave() {
        if (!selectedPatient || !selectedDoctor) { 
            showError("Выберите пациента и врача"); 
            return 
        }
        
        // Валидируем дату открытия
        var openValidation = validateDate(slOpenDate.text, "даты открытия")
        if (!openValidation.valid) {
            showError(openValidation.error)
            return
        }
        
        // Валидируем дату закрытия
        var closeValidation = validateDate(slCloseDate.text, "даты закрытия")
        if (!closeValidation.valid) {
            showError(closeValidation.error)
            return
        }
        
        // Проверяем, что закрытие не раньше открытия
        if (closeValidation.date < openValidation.date) {
            showError("Дата закрытия не может быть раньше даты открытия")
            return
        }
        
        // Проверяем, что дата открытия не в будущем
        var today = new Date()
        today.setHours(0, 0, 0, 0)
        if (openValidation.date > today) {
            showError("Дата открытия не может быть в будущем")
            return
        }
        
        // Форматируем даты для БД (YYYY-MM-DD)
        var open = openValidation.year + "-" + 
                String(openValidation.month).padStart(2, '0') + "-" + 
                String(openValidation.day).padStart(2, '0')
        
        var close = closeValidation.year + "-" + 
                    String(closeValidation.month).padStart(2, '0') + "-" + 
                    String(closeValidation.day).padStart(2, '0')
        
        var diagText = diagnosisCombo.currentText || "J06 - ОРВИ"
        var diagCode = diagText.split(" - ")[0]
        var diagId = null
        
        try { 
            var ds = DiseaseService.search([{"field": "code", "operator": "eq", "value": diagCode}])
            if (ds.length > 0) diagId = ds[0].id 
        } catch (e) {}
        
        var docNumber = autoBlankNumber.text
        
        // Регистрируем бланк
        var registerResult = SickLeaveRegisterService.add({
            sick_leave_number: docNumber, 
            issued_by: 1,
            issued_to_doctor: selectedDoctor.doctor_id, 
            issued_date: new Date().toISOString()
        })
        
        if (!registerResult) {
            showError("Не удалось зарегистрировать бланк")
            return
        }
        
        // Создаём больничный
        var sickLeaveData = {
            sick_leave_number: docNumber, 
            id_patient: selectedPatient.id, 
            id_doctor: selectedDoctor.doctor_id, 
            opened_at: open + "T00:00:00", 
            closed_at: close + "T00:00:00",
            initial_diagnosis: diagText
        }
        
        if (diagId) {
            sickLeaveData.id_initial_diagnosis = diagId
        }
        
        var r = SickLeaveService.add(sickLeaveData)
        
        if (r) {                
            var newSlId = -1
            try {
                var newSl = SickLeaveService.search([
                    {"field": "sick_leave_number", "operator": "eq", "value": docNumber}
                ])
                if (newSl.length > 0) newSlId = newSl[0].id
            } catch(e) {}
            
            sickLeavesJournal.unshift({
                id: newSlId > 0 ? newSlId : sickLeavesJournal.length + 1,
                number: docNumber, 
                patient: selectedPatient.full_name, 
                doctor: selectedDoctor.doctor_name, 
                opened: formatDate(open),
                closed: formatDate(close),
                status: "open"
            })
            
            var temp = []
            for (var i = 0; i < sickLeavesJournal.length; i++) temp.push(sickLeavesJournal[i])
            sickLeavesJournal = temp
            
            documentPreviewDialog.docTypeText = "Больничный лист"
            documentPreviewDialog.docNumber = docNumber
            documentPreviewDialog.patientName = selectedPatient.full_name
            documentPreviewDialog.doctorName = selectedDoctor.doctor_name
            documentPreviewDialog.docDate = formatDate(open)
            documentPreviewDialog.docContent = "Диагноз: " + diagText + "\nЗакрыт: " + formatDate(close)
            documentPreviewDialog.open()
            
            showSuccess("Больничный " + docNumber + " оформлен")
        } else {
            showError("Ошибка создания больничного")
        }
    }
    
    // function issueBlanks() {
    //     if (!issueBlanksDialog.selectedBlanksDoctor) { showError("Выберите врача"); return }
    //     try {
    //         var count = parseInt(blanksCount.text); var start = blanksRemaining - count + 1
    //         SickLeaveRegisterService.add({sick_leave_number: "БЛ-"+Qt.formatDate(new Date(),"yyyy")+"-"+start.toString().padStart(4,'0'), issued_by: 1, issued_to_doctor: issueBlanksDialog.selectedBlanksDoctor.doctor_id, issued_date: new Date().toISOString()})
    //         blankRegister.unshift({date: Qt.formatDate(new Date(),"dd.MM.yyyy"), doctor: issueBlanksDialog.selectedBlanksDoctor.doctor_name, numbers: "БЛ-"+start.toString().padStart(4,'0')+" - БЛ-"+blanksRemaining.toString().padStart(4,'0'), count: count, issued_by: "Иванова М.П."})
    //         blankRegister = blankRegister.slice()
    //         blanksRemaining -= count
    //         showSuccess("Бланки выданы")
    //         issueBlanksDialog.close()
    //     } catch (e) { showError("Ошибка выдачи") }
    // }
    
    // Component.onCompleted: {
    //     diagnosisCombo.model = ["J06 - ОРВИ", "I10 - Гипертензия", "K29 - Гастрит", "M54 - Дорсалгия"]
    //     blankRegister = [{date:"15.04.2026", doctor:"Докторов Д.Д.", numbers:"БЛ-0101 - БЛ-0120", count:20, issued_by:"Иванова М.П."}]
    //     documentsJournal = [{id:1, date:"20.04.2026", patient:"Иванов И.И.", type:"Справка", doctor:"Докторов Д.Д."}]
    //     sickLeavesJournal = [{id:1, number:"БЛ-0001", patient:"Иванов И.И.", doctor:"Докторов Д.Д.", opened:"10.04.2026", status:"open"}]
    // }

    Component.onCompleted: {
        console.log("📦 Загрузка данных из БД...")
        loadDiagnoses()
        loadDocumentsJournal()
        loadSickLeavesJournal()
    }

    function loadDiagnoses() {
        try {
            var diseases = DiseaseService.getAll()
            console.log("Найдено диагнозов:", diseases.length)
            
            var diagnosisList = []
            for (var i = 0; i < diseases.length; i++) {
                diagnosisList.push(diseases[i].code + " - " + diseases[i].name)
            }
            
            if (diagnosisList.length > 0) {
                diagnosisCombo.model = diagnosisList
            } else {
                diagnosisCombo.model = ["J06 - ОРВИ", "I10 - Гипертензия", "K29 - Гастрит", "M54 - Дорсалгия"]
            }
        } catch(e) {
            console.log("Ошибка загрузки диагнозов:", e)
            diagnosisCombo.model = ["J06 - ОРВИ", "I10 - Гипертензия", "K29 - Гастрит", "M54 - Дорсалгия"]
        }
    }

    function loadDocumentsJournal() {
        try {
            var docs = MedicalDocumentFullInfoViewService.getAll()  // ← используем View сервис
            console.log("Найдено документов:", docs.length)
            
            var types = {"certificate":"Справка","referral":"Направление","prescription":"Рецепт","extract":"Выписка"}
            var temp = []
            
            for (var i = 0; i < docs.length; i++) {
                temp.push({
                    id: docs[i].id,
                    date: formatDate(docs[i].created_at),
                    patient: docs[i].patient_name || "—",
                    type: types[docs[i].document_type] || docs[i].document_type,
                    doctor: docs[i].doctor_name || "—",
                    content: docs[i].content || ""
                })
            }
            
            documentsJournal = temp
            
        } catch(e) {
            console.log("Ошибка загрузки журнала документов:", e)
            documentsJournal = [{id:1, date:"20.04.2026", patient:"Иванов И.И.", type:"Справка", doctor:"Докторов Д.Д."}]
        }
    }

    function loadSickLeavesJournal() {
        try {
            var sickLeaves = SickLeaveFullInfoViewService.getAll()
            console.log("Найдено больничных:", sickLeaves.length)
            
            var temp = []
            
            for (var i = 0; i < sickLeaves.length; i++) {
                temp.push({
                    id: sickLeaves[i].id,
                    number: sickLeaves[i].sick_leave_number,
                    patient: sickLeaves[i].patient_name || "—",
                    doctor: sickLeaves[i].doctor_name || "—",
                    opened: formatDate(sickLeaves[i].opened_at),
                    closed: sickLeaves[i].closed_at ? formatDate(sickLeaves[i].closed_at) : "—",
                    diagnosis: sickLeaves[i].initial_diagnosis_name || sickLeaves[i].initial_diagnosis || "—"
                    // status - УБРАЛИ
                })
            }
            
            sickLeavesJournal = temp
            
            if (temp.length > 0) {
                var lastNumber = temp[temp.length - 1].number
                var num = parseInt(lastNumber.split("-").pop())
            }
            
        } catch(e) {
            console.log("Ошибка загрузки журнала больничных:", e)
            sickLeavesJournal = [{id:1, number:"БЛ-0001", patient:"Иванов И.И.", doctor:"Докторов Д.Д.", opened:"10.04.2026", closed:"—"}]
        }
    }
}