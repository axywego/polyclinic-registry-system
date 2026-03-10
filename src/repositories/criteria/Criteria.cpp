#include "Criteria.h"


QString EqualsCriterion::toSql(const int paramIndex) const {
    return QString("%1 = :criteria_%2").arg(field).arg(paramIndex);
}

QHash<QString, QVariant> EqualsCriterion::getParams(const int paramIndex) const {
    return { { QString(":criteria_%1").arg(paramIndex), value } };
}    

QString LikeCriterion::toSql(const int paramIndex) const {
    return QString("%1 LIKE :criteria_%2").arg(field).arg(paramIndex);
}

QHash<QString, QVariant> LikeCriterion::getParams(const int paramIndex) const {
    return { { QString(":criteria_%1").arg(paramIndex), "%" + value.toString() + "%" } };
}


QString GreaterThanCriterion::toSql(const int paramIndex) const {
    
}

QHash<QString, QVariant> GreaterThanCriterion::getParams(const int paramIndex) const {
    
}