#include "GenericRepository.h"

template<ModelType T>
bool GenericRepository<T>::create(T& model) {

    auto& db = DatabaseManager::instance().getDatabase();

    auto fields = model.getFields();
    QStringList fieldsName, placeholders;

    for(auto it = fields.begin(); it != fields.end(); it++){
        if(it.key() == "id") continue;

        fieldsName << it.key();
        placeholders << ":" + it.key();
    }

    QSqlQuery query(db);

    QString queryString = QString("INSERT INTO %1 (%2) VALUES (%3) RETURNING id").arg(model.tableName())
                                                                                .arg(fieldsName.join(", "))
                                                                                .arg(placeholders.join(", "));

    qDebug() << "Create query: " << queryString;

    query.prepare(queryString);

    for(auto it = fields.begin(); it != fields.end(); it++){
        query.bindValue(":" + it.key(), it.value());
    }

    if(!query.exec()) {
        qCritical() << "PolyclinicRepository : cannot create : " << query.lastError().text();
        return false;
    }

    if(query.next()){
        model.id = query.value(0).toInt(); 
    }

    return true;
}

template<ModelType T>
bool GenericRepository<T>::update(const T& model) {

    auto& db = DatabaseManager::instance().getDatabase();

    auto fields = model.getFields();
    QStringList fieldsName, placeholders;

    for(auto it = fields.begin(); it != fields.end(); it++){
        if(it.key() == "id") continue;

        fieldsName << it.key();
        placeholders << ":" + it.key();
    }

    QSqlQuery query(db);

    QString queryString = QString("UPDATE %1 SET").arg(model.tableName());

    for(auto it_field = fieldsName.begin(), it_placeholder = placeholders.begin();
        it_field != fieldsName.end() && it_placeholder != placeholders.end(); ) {
        
        queryString.append(QString(" %1 = %2,").arg(*it_field).arg(*it_placeholder));
        ++it_field;
        ++it_placeholder; 
    }

    queryString.remove(queryString.length() - 1, 1);
    
    queryString.append(QString(" WHERE id = %1").arg(model.id.value()));

    qDebug() << "Update query: " << queryString;

    query.prepare(queryString);

    for(auto it = fields.begin(); it != fields.end(); it++){
        query.bindValue(":" + it.key(), it.value());
    }

    if(!query.exec()) {
        qCritical() << "PolyclinicRepository : cannot update : " << query.lastError().text();
        return false;
    }

    return true;
}

template<ModelType T>
std::optional<T> GenericRepository<T>::findById(const int id) const {

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