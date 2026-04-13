import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import Schedule.Services 1.0
import ScheduleException.Services 1.0
import DoctorFullInfoView.Services 1.0
import Appointment.Services 1.0
import AppointmentFullInfoView.Services 1.0

Rectangle {
    id: root

    property int  idPolyclinic: 0
    property date dateNow: new Date()
    property int  numWeek : root.dateNow.getDay() === 0 ? 7 : root.dateNow.getDay()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.dateNow = new Date()
    }

    Layout.fillWidth: true
    Layout.fillHeight: true

    Layout.margins: 20

    ColumnLayout {
        
        anchors.margins: 20
        Text { text: "Число месяца: " + dateNow.getDate() }
        Text { text: "День недели: " + dateNow.toLocaleDateString(Qt.locale("ru_RU"), "dddd") }
        Text { text: "Время: " + Qt.formatTime(dateNow, "hh:mm:ss") }

        Text {
            text: `Количество врачей, работающих в данное время: ${getCountDoctorsAtNow()}`
        }

        Text {
            text: `Записей на сегодня: ${getCountAppointments()}`
        }
    }

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
        if (!startTime || !endTime) {
            return true
        }
        var start = new Date(startTime)
        var end = new Date(endTime)
        var check = new Date(checkTime)

        var startMinutes = start.getHours() * 60 + start.getMinutes()
        var endMinutes = end.getHours() * 60 + end.getMinutes()
        var checkMinutes = check.getHours() * 60 + check.getMinutes()

        return checkMinutes >= startMinutes && checkMinutes <= endMinutes
    }

    function getCountDoctorsAtNow() {

        const allDoctorsInPolyclinic = DoctorFullInfoViewService.search([
            {"field": "id_polyclinic", "operator": "eq", "value": root.idPolyclinic}
        ])

        var res = 0

        for(var i = 0; i < allDoctorsInPolyclinic.length; i++) {
            const doctor = allDoctorsInPolyclinic[i]

            const schedules = ScheduleService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctor.id_doctor},
                {"field": "day_of_week", "operator": "eq", "value": root.numWeek}
            ])

            if(schedules.length === 0)
                continue
            
            const schedule = schedules[0]

            if(!isTimeInRange(schedule.start_time, schedule.end_time, root.dateNow))
                continue

            const exceptionsInSchedule = ScheduleExceptionService.search([
                {"field": "id_doctor", "operator": "eq", "value": doctor.id_doctor}
            ])

            var activeException = null

            for(var j = 0; j < exceptionsInSchedule.length; j++) {
                const ex = exceptionsInSchedule[j]
                if(isDateTimeInRange(
                    ex.exception_start_date,
                    ex.exception_end_date,
                    ex.start_time,
                    ex.end_time,
                    root.dateNow
                )) {
                    activeException = ex
                    break
                }
            }

            if(activeException !== null) {
                if(activeException.is_working) {
                    res++
                }
            }
            else {
                if(schedules.length > 0){
                    const schedule = schedules[0]
                    if(isTimeInRange(schedule.start_time, schedule.end_time, root.dateNow)) {
                        res++
                    }
                }
            }

            // if(exceptionsInSchedule.length === 0)
            //     res++
            // else {
            //     var hasActiveException = false

            //     for(var j = 0; j < exceptionsInSchedule.length; j++){
            //         const scheduleException = exceptionsInSchedule[j];
            //         if(isDateTimeInRange(
            //             scheduleException.exception_start_date,
            //             scheduleException.exception_end_date,
            //             scheduleException.start_time,
            //             scheduleException.end_time,
            //             root.dateNow
            //         )) {
            //             hasActiveException = true
            //             break
            //         }
            //     }
            //     if(!hasActiveException)
            //         res++
            // }
        }

        return res
    }

    function getCountAppointments() {
        // const allDoctorsInPolyclinic = DoctorFullInfoViewService.search([
        //     {"field": "id_polyclinic", "operator": "eq", "value": root.idPolyclinic}
        // ])

        // for(var i = 0; i < allDoctorsInPolyclinic.length; i++){
        //     const doctor = allDoctorsInPolyclinic[i]
        //     const allSchedules = ScheduleService.search([
        //         {"field": "id_doctor", "operator": "eq", "value": doctor.id_doctor}
        //     ])
            
        // }

        // const schedules = AppointmentService.search([
        //     {"field": "id_schedule", "operator": "eq", "value": ""}
        // ])
        var count = 0

        const appointmentsInPolyclinic = AppointmentFullInfoViewService.search([
            {"field": "id_polyclinic", "operator": "eq", "value": root.idPolyclinic}
        ])

        var todayDay = root.dateNow.getDate()
        var todayMonth = root.dateNow.getMonth()
        var todayYear = root.dateNow.getFullYear()
        
        for (var i = 0; i < appointmentsInPolyclinic.length; i++) {
            const appt = appointmentsInPolyclinic[i]
            
            var apptDate = new Date(appt.appointment_time)
            
            if (apptDate.getDate() === todayDay && 
                apptDate.getMonth() === todayMonth && 
                apptDate.getFullYear() === todayYear) {
                count++
            }
        }

        return count
    }
}