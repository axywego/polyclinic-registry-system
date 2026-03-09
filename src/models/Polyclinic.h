#pragma once

#include <QString>
#include <optional>

struct Polyclinic {
    std::optional<int> id;
    QString name;
    QString address;
    QString phoneNumber;
};