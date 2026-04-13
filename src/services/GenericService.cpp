#include "GenericService.h"

template<ModelType T>
bool GenericService<T>::add(T& model) {
    return repo.create(model);
}

template<ModelType T>
bool GenericService<T>::remove(const int id) {
    return repo.remove(id);
}

template<ModelType T>
std::optional<QVector<T>> GenericService<T>::search(const QVector<CriteriaPtr>& criteriaVector){
    if(criteriaVector.empty())
        return std::nullopt;
    return repo.searchByQueries(criteriaVector);
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
template class GenericService<Department>;
template class GenericService<Specialty>;
template class GenericService<Doctor>;
template class GenericService<Room>;
template class GenericService<Patient>;
template class GenericService<MedicalCard>;
template class GenericService<Schedule>;
template class GenericService<ScheduleException>;
template class GenericService<Disease>;
template class GenericService<Symptom>;
template class GenericService<SickLeave>;
template class GenericService<Appointment>;
template class GenericService<Visit>;
template class GenericService<VisitDiagnosis>;
template class GenericService<VisitSymptom>;
template class GenericService<Service>;
template class GenericService<ServiceAppointment>;

template class GenericService<AppointmentTicket>;
template class GenericService<District>;
template class GenericService<MedicalDocument>;
template class GenericService<Registrar>;
template class GenericService<SickLeaveRegister>;
template class GenericService<Street>;