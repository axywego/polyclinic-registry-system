import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Polyclinic.UI 1.0
import Schedule.Services 1.0
import ScheduleException.Services 1.0
import DoctorFullInfoView.Services 1.0
import AppointmentFullInfoView.Services 1.0

Rectangle {
    id: root

    // ============================================
    // PROPERTIES
    // ============================================
    
    property int idPolyclinic: 0
    property date dateNow: new Date()
    property int numWeek: root.dateNow.getDay() === 0 ? 7 : root.dateNow.getDay()
    
    property int doctorsWorkingNow: 0
    property int appointmentsToday: 0
    property int completedAppointmentsToday: 0
    property int patientsInQueue: 0

    // ============================================
    // TIMERS
    // ============================================
    
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.dateNow = new Date()
    }
    
    Timer {
        id: statsTimer
        interval: 30000
        running: true
        repeat: true
        onTriggered: updateAllStats()
    }

    // ============================================
    // LAYOUT
    // ============================================
    
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 20
    
    color: "#F5F7FA"
    radius: 12

    ScrollView {
        anchors.fill: parent
        anchors.margins: 5
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        contentWidth: availableWidth
        
        ColumnLayout {
            width: parent.width
            spacing: 20

            // ============================================
            // STATS CARDS
            // ============================================
            
            GridLayout {
                Layout.fillWidth: true
                columns: 4
                rowSpacing: 15
                columnSpacing: 15
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    iconText: "👨‍⚕️"
                    iconColor: "#4CAF50"
                    title: "Врачей на смене"
                    value: root.doctorsWorkingNow
                    subtitle: "Принимают пациентов"
                }
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    iconText: "📋"
                    iconColor: "#1976D2"
                    title: "Записей на сегодня"
                    value: root.appointmentsToday
                    subtitle: "Выполнено: " + root.completedAppointmentsToday
                }
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    iconText: "⏳"
                    iconColor: "#9C27B0"
                    title: "В очереди"
                    value: root.patientsInQueue
                    subtitle: "Ожидают приема"
                }
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    iconText: "✅"
                    iconColor: "#607D8B"
                    title: "Явка"
                    value: root.getAttendanceRate() + "%"
                    subtitle: "За сегодня"
                }
            }

            // ============================================
            // SECOND ROW STATS
            // ============================================
            
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 15
                columnSpacing: 15
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                    iconText: "📊"
                    iconColor: "#F44336"
                    title: "Загруженность"
                    value: root.getOccupancyRate() + "%"
                    subtitle: root.getOccupancyLevel()
                }
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                    iconText: "🎫"
                    iconColor: "#00BCD4"
                    title: "Свободных талонов"
                    value: root.getFreeTicketsCount()
                    subtitle: "На сегодня"
                }
                
                StatsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                    iconText: "📈"
                    iconColor: "#FF9800"
                    title: "Всего записей"
                    value: root.appointmentsToday
                    subtitle: "За сегодня"
                }
            }

            // ============================================
            // QUICK ACTIONS
            // ============================================
            
            Text {
                text: "Быстрые действия"
                font.pixelSize: 18
                font.bold: true
                color: "#2C3E50"
                Layout.topMargin: 5
                Layout.fillWidth: true
            }
            
            RowLayout {
                Layout.fillWidth: true
                spacing: 15
                
                QuickActionButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    text: "Записать на прием"
                    iconText: "📝"
                    buttonColor: "#4CAF50"
                    onClicked: root.switchToPage(1)
                }
                
                QuickActionButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    text: "Больничный лист"
                    iconText: "📄"
                    buttonColor: "#1976D2"
                    onClicked: root.switchToPage(4)
                }
                
                QuickActionButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    text: "Найти медкарту"
                    iconText: "🔍"
                    buttonColor: "#9C27B0"
                    onClicked: root.switchToPage(3)
                }
            }

            // ============================================
            // RECENT APPOINTMENTS
            // ============================================
            
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 5
                
                Text {
                    text: "Последние записи"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#2C3E50"
                }
                
                Item { Layout.fillWidth: true }
                
                Button {
                    text: "Обновить"
                    flat: true
                    onClicked: updateAllStats()
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#1976D2"
                        font.pixelSize: 13
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                color: "#FFFFFF"
                radius: 12
                
                ListView {
                    id: recentAppointmentsList
                    anchors.fill: parent
                    anchors.margins: 5
                    clip: true
                    model: root.getRecentAppointments(8)
                    spacing: 2
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                    
                    delegate: Rectangle {
                        width: ListView.view.width - 10
                        height: 56
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: mouseArea.containsMouse ? "#F5F7FA" : "transparent"
                        radius: 8
                        
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 15
                            
                            Rectangle {
                                Layout.preferredWidth: 4
                                Layout.fillHeight: true
                                radius: 2
                                color: root.getStatusColor(modelData.status)
                            }
                            
                            Text {
                                text: Qt.formatDateTime(modelData.appointment_time, "hh:mm")
                                font.bold: true
                                font.pixelSize: 15
                                color: "#2C3E50"
                                Layout.preferredWidth: 60
                            }
                            
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 2
                                
                                Text {
                                    text: modelData.patient_name || "Неизвестный пациент"
                                    font.pixelSize: 14
                                    font.bold: true
                                    color: "#2C3E50"
                                    elide: Text.ElideRight
                                }
                                
                                Text {
                                    text: modelData.doctor_name || "—"
                                    font.pixelSize: 12
                                    color: "#7F8C8D"
                                    elide: Text.ElideRight
                                }
                            }
                            
                            Rectangle {
                                Layout.preferredWidth: 90
                                Layout.preferredHeight: 28
                                radius: 14
                                color: root.getStatusColor(modelData.status)
                                opacity: 0.15
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: root.getStatusText(modelData.status)
                                    font.pixelSize: 11
                                    font.bold: true
                                    color: root.getStatusColor(modelData.status)
                                }
                            }
                        }
                        
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Open appointment:", modelData.appointment_id)
                            }
                        }
                    }
                    
                    Text {
                        anchors.centerIn: parent
                        text: "Нет записей на сегодня"
                        font.pixelSize: 14
                        color: "#7F8C8D"
                        visible: recentAppointmentsList.count === 0
                    }
                }
            }
        }
    }

    // ============================================
    // SIGNALS
    // ============================================
    
    signal switchToPage(int index)

    // ============================================
    // INITIALIZATION
    // ============================================
    
    Component.onCompleted: {
        updateAllStats()
    }

    // ============================================
    // STATS UPDATE
    // ============================================
    
    function updateAllStats() {
        doctorsWorkingNow = calculateDoctorsWorkingNow()
        appointmentsToday = calculateAppointmentsToday()
        completedAppointmentsToday = calculateCompletedAppointmentsToday()
        patientsInQueue = calculatePatientsInQueue()
        recentAppointmentsList.model = getRecentAppointments(8)
    }

    // ============================================
    // UTILITY FUNCTIONS
    // ============================================

    function isDateTimeInRange(startDate, endDate, startTime, endTime, checkDateTime) {
        if (!startDate || !endDate) return false

        var start = new Date(startDate)
        var end = new Date(endDate)
        var check = new Date(checkDateTime)

        if (startTime) {
            var startT = new Date(startTime)
            start.setHours(startT.getHours(), startT.getMinutes(), startT.getSeconds())
        } else {
            start.setHours(0, 0, 0, 0)
        }

        if (endTime) {
            var endT = new Date(endTime)
            end.setHours(endT.getHours(), endT.getMinutes(), endT.getSeconds())
        } else {
            end.setHours(23, 59, 59, 999)
        }

        return check >= start && check <= end
    }

    function isTimeInRange(startTime, endTime, checkTime) {
        if (!startTime || !endTime) return true
        
        var start = new Date(startTime)
        var end = new Date(endTime)
        var check = new Date(checkTime)

        var startMinutes = start.getHours() * 60 + start.getMinutes()
        var endMinutes = end.getHours() * 60 + end.getMinutes()
        var checkMinutes = check.getHours() * 60 + check.getMinutes()

        return checkMinutes >= startMinutes && checkMinutes <= endMinutes
    }
    
    function isSameDate(date1, date2) {
        var d1 = new Date(date1)
        var d2 = new Date(date2)
        return d1.getDate() === d2.getDate() &&
               d1.getMonth() === d2.getMonth() &&
               d1.getFullYear() === d2.getFullYear()
    }

    // ============================================
    // CALCULATION FUNCTIONS
    // ============================================
    
    function calculateDoctorsWorkingNow() {
        const allDoctorsInPolyclinic = DoctorFullInfoViewService.search([
            {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
        ])

        var count = 0

        for (var i = 0; i < allDoctorsInPolyclinic.length; i++) {
            const doctor = allDoctorsInPolyclinic[i]

            const schedules = ScheduleService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctor.doctor_id},
                {"field": "day_of_week", "operator": "eq", "value": root.numWeek}
            ])

            if (schedules.length === 0) continue
            
            const schedule = schedules[0]

            if (!isTimeInRange(schedule.start_time, schedule.end_time, root.dateNow)) continue

            const exceptionsInSchedule = ScheduleExceptionService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctor.doctor_id}
            ])

            var hasActiveException = false
            var exceptionAllowsWork = true

            for (var j = 0; j < exceptionsInSchedule.length; j++) {
                const ex = exceptionsInSchedule[j]
                if (isDateTimeInRange(
                    ex.exception_start_date,
                    ex.exception_end_date,
                    ex.start_time,
                    ex.end_time,
                    root.dateNow
                )) {
                    hasActiveException = true
                    exceptionAllowsWork = ex.is_working
                    break
                }
            }

            if (hasActiveException) {
                if (exceptionAllowsWork) count++
            } else {
                count++
            }
        }

        return count
    }
    
    function calculateAppointmentsToday() {
        const appointments = AppointmentFullInfoViewService.search([
            {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
        ])

        var count = 0
        
        for (var i = 0; i < appointments.length; i++) {
            if (isSameDate(appointments[i].appointment_time, root.dateNow)) {
                count++
            }
        }

        return count
    }
    
    function calculateCompletedAppointmentsToday() {
        const appointments = AppointmentFullInfoViewService.search([
            {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic},
            {"field": "status", "operator": "eq", "value": "completed"}
        ])

        var count = 0
        
        for (var i = 0; i < appointments.length; i++) {
            if (isSameDate(appointments[i].appointment_time, root.dateNow)) {
                count++
            }
        }

        return count
    }
    
    function calculatePatientsInQueue() {
        try {
            const appointments = AppointmentFullInfoViewService.search([
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            
            var count = 0
            var now = root.dateNow
            
            for (var i = 0; i < appointments.length; i++) {
                var appt = appointments[i]
                var apptTime = new Date(appt.appointment_time)
                
                if (!isSameDate(apptTime, now)) continue
                if (appt.status !== "scheduled" && appt.status !== "confirmed") continue
                
                if (apptTime > now) {
                    count++
                }
            }
            return count
        } catch (e) {
            console.error("Error calculating patients in queue:", e)
            return 0
        }
    }
    
    function getOccupancyRate() {
        if (root.doctorsWorkingNow === 0) return 0
        const maxPossible = root.doctorsWorkingNow * 12
        if (maxPossible === 0) return 0
        return Math.round((root.appointmentsToday / maxPossible) * 100)
    }
    
    function getOccupancyLevel() {
        const rate = getOccupancyRate()
        if (rate < 30) return "Низкая"
        if (rate < 60) return "Средняя"
        if (rate < 85) return "Высокая"
        return "Критическая"
    }
    
    function getFreeTicketsCount() {
        if (root.doctorsWorkingNow === 0) return 0
        const maxPossible = root.doctorsWorkingNow * 12
        return Math.max(0, maxPossible - root.appointmentsToday)
    }
    
    function getAttendanceRate() {
        if (root.appointmentsToday === 0) return 0
        return Math.round((root.completedAppointmentsToday / root.appointmentsToday) * 100)
    }

    // ============================================
    // UI HELPER FUNCTIONS
    // ============================================
    
    function getStatusColor(status) {
        switch (status) {
            case "scheduled": return "#1976D2"
            case "confirmed": return "#4CAF50"
            case "completed": return "#607D8B"
            case "cancelled": return "#F44336"
            case "no_show": return "#FF9800"
            default: return "#607D8B"
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
    
    function getRecentAppointments(limit) {
        try {
            const appointments = AppointmentFullInfoViewService.search([
                {"field": "polyclinic_id", "operator": "eq", "value": root.idPolyclinic}
            ])
            
            var todayAppointments = []
            for (var i = 0; i < appointments.length; i++) {
                if (isSameDate(appointments[i].appointment_time, root.dateNow)) {
                    todayAppointments.push(appointments[i])
                }
            }
            
            todayAppointments.sort(function(a, b) {
                return new Date(a.appointment_time) - new Date(b.appointment_time)
            })
            
            return todayAppointments.slice(0, limit)
        } catch (e) {
            console.error("Error loading appointments:", e)
            return []
        }
    }
}