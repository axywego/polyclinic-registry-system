#include "ViewsService.h"

template<ViewType T>
std::optional<QVector<T>> ViewsService<T>::search(const QVector<CriteriaPtr>& criteriaVector){
    if(criteriaVector.empty())
        return std::nullopt;
    return repo.searchByQueries(criteriaVector);
}

template<ViewType T>
std::optional<QVector<T>> ViewsService<T>::getAll() const {
    return repo.getAll();
}

template class ViewsService<DoctorFullInfoView>;
template class ViewsService<AppointmentFullInfoView>;