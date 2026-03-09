#pragma once

#include "../repositories/PolyclinicRepository.h"
#include <optional>

class PolyclinicService {
private:
    PolyclinicRepository repos;
public:
    bool add(const Polyclinic& p);
    bool getInfo(const int id);
    std::optional<QVector<Polyclinic>> searchByQuery(const QString& query);
};