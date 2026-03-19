#pragma once

#include "Criteria.h"
#include <memory>
#include <concepts>

using CriteriaPtr = std::shared_ptr<ICriterion>;

CriteriaPtr Equals(const QString& field, const QVariant& value);

CriteriaPtr Like(const QString& field, const QVariant& value);

CriteriaPtr GreaterThan(const QString& field, const QVariant& value);

template<typename T>
concept ConvertibleToCriteriaPtr = std::convertible_to<T, CriteriaPtr>;