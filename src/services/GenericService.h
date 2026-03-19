#pragma once

#include "../repositories/GenericRepository.h"
#include "../database/DatabaseManager.h"
#include <optional>
#include <QHash>
#include <QString>
#include <QVariant>

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

template<ModelType T>
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

};

// extern template class GenericService<Polyclinic>;