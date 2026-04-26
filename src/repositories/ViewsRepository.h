#pragma once

#include "../core/common.h"
#include "../repositories/criteria/CriteriaHelpers.h"
#include "../database/DatabaseManager.h"
#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

#include "../models/views/DoctorFullInfoView.h"
#include "../models/views/AppointmentFullInfoView.h"
#include "../models/views/PatientsByDistrictView.h"
#include "../models/views/MedicalDocumentFullInfoView.h"
#include "../models/views/MedicalDocumentFullInfoView.h"
#include "../models/views/SickLeaveFullInfoView.h"
#include "../models/views/SickLeaveRegisterFullView.h"


template<ViewType T>
class ViewsRepository {
public:
    QVector<T> getAll() const;

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