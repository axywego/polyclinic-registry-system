#include "GenericRepository.h"

template<ModelType T>
bool GenericRepository<T>::create(T& model) {

    auto& db = DatabaseManager::instance().getDatabase();

    auto fields = model.getFields();
    QStringList fieldsName, placeholders;

    for(auto it = fields.begin(); it != fields.end(); it++){
        fieldsName << it.key();
        placeholders << ":" + it.key();
    }

    QSqlQuery query(db);

    QString queryString = QString("INSERT INTO %1 (%2) VALUES (%3) RETURNING id").arg(model.tableName())
                                                                                .arg(fieldsName.join(", "))
                                                                                .arg(placeholders.join(", "));

    query.prepare(queryString);

    for(auto it = fields.begin(); it != fields.end(); it++){
        query.bindValue(":" + it.key(), it.value());
    }

    if(!query.exec()) {
        qCritical() << "PolyclinicRepository : cannot create : " << query.lastError().text();
    }

    if(query.next()){
        model.id = query.value(0).toInt(); 
    }

    return true;
}

template<ModelType T>
bool GenericRepository<T>::update(const T& model) {
    return true;
}

template<ModelType T>
std::optional<T> GenericRepository<T>::findById(const int id) const {
    static_assert(std::is_base_of_v<BaseModel, T>, "T must inherit from BaseModel");

    auto& db = DatabaseManager::instance().getDatabase();
    QSqlQuery query(db);

    T model;

    QString queryString = QString("SELECT * FROM %1 WHERE id = :id").arg(model.tableName());
    query.prepare(queryString);
    query.bindValue(":id", id);

    if (!query.exec() || !query.next()) {
        return std::nullopt;
    }

    model.fromSqlRecord(query.record());

    return model;
}

template<ModelType T>
QVector<T> GenericRepository<T>::getAll() const {
    QVector<T> models;
    auto& db = DatabaseManager::instance().getDatabase();

    QSqlQuery query(db);

    T tempModel;

    if(!query.exec(QString("SELECT * FROM %1").arg(tempModel.tableName()))) {
        qCritical() << "Repository : cannot get all : " << query.lastError().text();
        return models;
    }

    while(query.next()){
        T model;
        model.fromSqlRecord(query.record());
        models.append(model);
    }

    return models;
}

template<ModelType T>
bool GenericRepository<T>::remove(const int id) {
    auto& db = DatabaseManager::instance().getDatabase();

    T tempModel;

    QSqlQuery query(db);

    QString queryString = QString("DELETE FROM %1 WHERE id = :id").arg(tempModel.tableName());

    query.prepare(queryString);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qCritical() << "Repository : remove - Error:" << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

template class GenericRepository<Polyclinic>;