#pragma once

#include "../repositories/PolyclinicRepository.h"
#include "../repositories/criteria/CriteriaHelpers.h"
#include "../database/DatabaseManager.h"
#include <optional>
#include <QHash>
#include <QString>
#include <QVariant>

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

class PolyclinicService {
private:
    PolyclinicRepository repo;
public:
    bool add(Polyclinic& p);

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
    std::optional<QVector<Polyclinic>> searchByQueries(const Args& ...args) {
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

        QString sql = "SELECT * FROM polyclinics ";
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

        QVector<Polyclinic> res;
        while(q.next()){
            Polyclinic p;

            p.id = q.value("id").toInt();
            p.name = q.value("name").toString();
            p.address = q.value("address").toString();
            p.phoneNumber = q.value("phoneNumber").toString();

            res.append(p);
        }

        if(res.empty())
            return std::nullopt;

        return res;
    }
};