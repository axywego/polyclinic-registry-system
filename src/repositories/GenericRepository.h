#pragma once

#include "../core/common.h"
#include "../repositories/criteria/CriteriaHelpers.h"
#include "../database/DatabaseManager.h"
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

#include "../models/entities/Polyclinic.h"
#include "../models/entities/Department.h"
#include "../models/entities/Specialty.h"
#include "../models/entities/Doctor.h"
#include "../models/entities/Room.h"
#include "../models/entities/Patient.h"
#include "../models/entities/MedicalCard.h"
#include "../models/entities/Schedule.h"
#include "../models/entities/ScheduleException.h"
#include "../models/entities/Disease.h"
#include "../models/entities/Symptom.h"
#include "../models/entities/SickLeave.h"
#include "../models/entities/Appointment.h"
#include "../models/entities/Visit.h"
#include "../models/entities/VisitDiagnosis.h"
#include "../models/entities/VisitSymptom.h"
#include "../models/entities/Service.h"
#include "../models/entities/ServiceAppointment.h"

#include "../models/entities/AppointmentTicket.h"
#include "../models/entities/District.h"
#include "../models/entities/MedicalDocument.h"
#include "../models/entities/Registrar.h"
#include "../models/entities/SickLeaveRegister.h"
#include "../models/entities/Street.h"

template<ModelType T>
class GenericRepository {
public:
    bool create(T& model);
    bool update(const T& model);
    std::optional<T> findById(const int id) const;
    QVector<T> getAll() const;
    bool remove(const int id);

    /* 
        @brief Search by criteria
        @param criteriaVector QVector<CriteriaPtr>
        @return optional vector of models
    */
    std::optional<QVector<T>> searchByQueries(const QVector<CriteriaPtr>& criteriaVector);

    /* 
        @brief Search by criteria
        @param args CriteriaPtr
        @return optional vector of models
    */
    template<typename ...Args>
    requires(ConvertibleToCriteriaPtr<Args> && ...)
    std::optional<QVector<T>> searchByQueries(const Args& ...args) {
        QVector<CriteriaPtr> criteria = { args... };

        return searchByQueries(criteria);
    }
};

//template class GenericRepository<Polyclinic>;