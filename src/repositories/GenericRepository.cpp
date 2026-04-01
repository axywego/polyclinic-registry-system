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

template <ModelType T>
std::optional<QVector<T>> GenericRepository<T>::searchByQueries(const QVector<CriteriaPtr>& criteriaVector) {
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
template class GenericRepository<Department>;
template class GenericRepository<Specialty>;
template class GenericRepository<Doctor>;
template class GenericRepository<Room>;
template class GenericRepository<Patient>;
template class GenericRepository<MedicalCard>;
template class GenericRepository<Schedule>;
template class GenericRepository<ScheduleException>;
template class GenericRepository<Disease>;
template class GenericRepository<Symptom>;
template class GenericRepository<SickLeave>;
template class GenericRepository<Appointment>;
template class GenericRepository<Visit>;
template class GenericRepository<VisitDiagnosis>;
template class GenericRepository<VisitSymptom>;
template class GenericRepository<Service>;
template class GenericRepository<ServiceAppointment>;