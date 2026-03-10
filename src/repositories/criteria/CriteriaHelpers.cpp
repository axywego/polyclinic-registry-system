#include "CriteriaHelpers.h"

CriteriaPtr Equals(const QString& field, const QVariant& value){
    return std::make_shared<EqualsCriterion>(field, value);
}

CriteriaPtr Like(const QString& field, const QVariant& value){
    return std::make_shared<LikeCriterion>(field, value);
}

CriteriaPtr GreaterThan(const QString& field, const QVariant& value){
    return std::make_shared<GreaterThanCriterion>(field, value);
}