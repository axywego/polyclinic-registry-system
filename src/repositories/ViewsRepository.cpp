#include "ViewsRepository.h"

template <ViewType T>
std::optional<QVector<T>> ViewsRepository<T>::searchByQueries(const QVector<CriteriaPtr>& criteriaVector) {
    QStringList whereParts;
    QVariantHash allParams;

    int index = 0;
    for(const auto& criterion : criteriaVector){
        whereParts << criterion->toSql(index);

        auto params = criterion->getParams(index);
        for(auto it = params.begin(); it != params.end(); ++it) {
            allParams.insert(it.key(), it.value());
        }

        index++;
    }

    T tempViewModel;

    QString sql = QString("SELECT * FROM %1 ").arg(tempViewModel.viewName());
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

template<ViewType T>
QVector<T> ViewsRepository<T>::getAll() const {
    QVector<T> viewModels;
    auto& db = DatabaseManager::instance().getDatabase();

    QSqlQuery query(db);

    T tempViewModel;

    if(!query.exec(QString("SELECT * FROM %1").arg(tempViewModel.viewName()))) {
        qCritical() << "Repository : cannot get all : " << query.lastError().text();
        return viewModels;
    }

    while(query.next()){
        T viewModel;
        viewModel.fromSqlRecord(query.record());
        viewModels.append(viewModel);
    }

    return viewModels;
}

template class ViewsRepository<DoctorFullInfoView>;