#pragma once

#include "../models/BaseModel.h"
#include "../models/Polyclinic.h"

template<typename T>
class GenericRepository {
public:
    bool create(T& model);
    bool update(const T& model);
    std::optional<T> findById(const int id) const;
    QVector<T> getAll() const;
    bool remove(const int id);
};

//template class GenericRepository<Polyclinic>;