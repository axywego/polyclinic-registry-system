#pragma once 

#include <QString>
#include <QVariant>
#include <QHash>

class ICriterion {
public:
    virtual ~ICriterion() = default;

    virtual QString toSql(const int paramIndex) const = 0;

    virtual QHash<QString, QVariant> getParams(const int paramIndex) const = 0;
};

class EqualsCriterion : public ICriterion {
private:
    QString field;
    QVariant value;
public:
    EqualsCriterion(const QString& field, const QVariant& value) : field(field), value(value) {}

    QString toSql(const int paramIndex) const override;

    QHash<QString, QVariant> getParams(const int paramIndex) const override;    
};

class LikeCriterion : public ICriterion {
private:
    QString field;
    QVariant value;
public:
    LikeCriterion(const QString& field, const QVariant& value) : field(field), value(value) {}

    QString toSql(const int paramIndex) const override;

    QHash<QString, QVariant> getParams(const int paramIndex) const override;    
};

class GreaterThanCriterion : public ICriterion {
private:
    QString field;
    QVariant value;
public:
    GreaterThanCriterion(const QString& field, const QVariant& value) : field(field), value(value) {}

    QString toSql(const int paramIndex) const override;

    QHash<QString, QVariant> getParams(const int paramIndex) const override;    
};
