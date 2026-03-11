#pragma once

#include "../repositories/GenericRepository.h"
#include "../repositories/criteria/CriteriaHelpers.h"
#include "../database/DatabaseManager.h"
#include <optional>
#include <QHash>
#include <QString>
#include <QVariant>

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

template<typename T>
class GenericService {
private:
    GenericRepository<T> repo;
public:
    bool add(T& p);

    bool remove(const int id);

    /*
        @brief get info about polyclinic
        @param id id of polyclinic
        @return associative container that contains key-value [string, QVariant] or nullopt if cannot get info
    */
    std::optional<QHash<QString, QVariant>> getInfo(const int id);

    /* 
        @brief Search by lambdas
        @param args CriteriaPtr
        @return optional vector of polyclinics
    */
    template<typename ...Args>
    std::optional<QVector<T>> searchByQueries(const Args& ...args) {
        QVector<CriteriaPtr> criteria = { args... };
        
        QStringList whereParts;
        QHash<QString, QVariant> allParams;

        int index = 0;
        for(const auto& criterion : criteria){
            whereParts << criterion->toSql(index);

            auto params = criterion->getParams(index);
            for(auto it = params.begin(); it != params.end(); ++it) {
                allParams.insert(it.key(), it.value());
            }

            index++;
        }

        T tempModel;

        QString sql = QString("SELECT * FROM %1 ").arg(tempModel.tableName());
        if(!whereParts.isEmpty()) {
            sql += "WHERE " + whereParts.join(" AND ");
        }

        QSqlQuery q(DatabaseManager::instance().getDatabase());

        q.prepare(sql);

        for(auto it = allParams.begin(); it != allParams.end(); ++it){
            q.bindValue(it.key(), it.value());
        }

        if(!q.exec()){
            qDebug() << "SQL Error: " << q.lastError().text();
            return std::nullopt;
        }

        QVector<T> res;
        while(q.next()){
            T model;

            model.fromSqlRecord(q.record());

            res.append(model);
        }

        if(res.empty())
            return std::nullopt;

        return res;
    }
};

// extern template class GenericService<Polyclinic>;