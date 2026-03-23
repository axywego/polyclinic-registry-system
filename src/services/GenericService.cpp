#include "GenericService.h"

template<ModelType T>
bool GenericService<T>::add(T& model) {
    return repo.create(model) != 1 ? true : false;
}

template<ModelType T>
bool GenericService<T>::remove(const int id) {
    return repo.remove(id);
}

template<ModelType T>
std::optional<QVariantHash> GenericService<T>::getInfo(const int id){
    if(auto model = repo.findById(id)) 
        return model->getFields();
    return std::nullopt;
}

template<ModelType T>
std::optional<QVector<T>> GenericService<T>::getAll() const {
    return repo.getAll();
}

template class GenericService<Polyclinic>;