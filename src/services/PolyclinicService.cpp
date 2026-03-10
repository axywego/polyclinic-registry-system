#include "PolyclinicService.h"

bool PolyclinicService::add(Polyclinic& p) {
    return repo.create(p);
}

bool PolyclinicService::remove(const int id) {
    return repo.remove(id);
}

std::optional<QHash<QString, QVariant>> PolyclinicService::getInfo(const int id){
    if(auto p = repo.findById(id)) {
        QHash<QString, QVariant> info;

        const auto& value = p.value();

        info["id"] = value.id.value();
        info["name"] = value.name;
        info["address"] = value.address;
        info["phoneNumber"] = value.phoneNumber;

        return info;
    }
    return std::nullopt;
}