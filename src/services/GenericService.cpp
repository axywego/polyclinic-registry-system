#include "GenericService.h"

template<typename T>
bool GenericService<T>::add(T& p) {
    return repo.create(p);
}

template<typename T>
bool GenericService<T>::remove(const int id) {
    return repo.remove(id);
}

template<typename T>
std::optional<QHash<QString, QVariant>> GenericService<T>::getInfo(const int id){
    if(auto model = repo.findById(id)) 
        return model->getFields();
    return std::nullopt;
}

template class GenericService<Polyclinic>;