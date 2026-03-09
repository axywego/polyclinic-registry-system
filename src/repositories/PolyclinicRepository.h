#pragma once

#include "../models/Polyclinic.h"

class PolyclinicRepository {
public:
    bool create(Polyclinic& p);
    bool update(const Polyclinic& p);
    std::optional<Polyclinic> findById(const int id) const;
    QVector<Polyclinic> getAll() const;
    bool remove(const int id);
};