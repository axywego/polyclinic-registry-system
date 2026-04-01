#pragma once

#include "../repositories/ViewsRepository.h"
#include "../database/DatabaseManager.h"
#include <optional>
#include <QHash>
#include <QString>
#include <QVariant>

#include <QtSql/QSqlQuery>
#include <QtSql/QSqlError>

template<ViewType T>
class ViewsService {
private:
    ViewsRepository<T> repo;
public:
    std::optional<QVector<T>> search(const QVector<CriteriaPtr>& criteriaVector);

    template<typename ...Args>
    requires(ConvertibleToCriteriaPtr<Args> && ...)
    std::optional<QVector<T>> search(const Args& ...args) {
        return repo.searchByQueries(args...);
    }

    template<typename ...Args>
    requires(ConvertibleToCriteriaPtr<Args> && ...)
    std::optional<T> searchFirst(const Args& ...args) {
        auto opt = repo.searchByQueries(args...); 
        if(!opt->isEmpty())
            return opt->first();
        return std::nullopt;
    }

    /*
        @brief get info about model
        @param id id of model
        @return associative container that contains key-value [string, QVariant] or nullopt if cannot get info
    */
    std::optional<QVariantHash> getInfo(const int id);

    std::optional<QVector<T>> getAll() const;

};

// extern template class GenericService<Polyclinic>;