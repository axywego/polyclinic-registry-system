#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QtQml>
#include <QDebug>

#include "core/EnvLoader.h"
#include "database/DatabaseManager.h"
#include "services/GenericService.h"

#include "PolyclinicServiceAdapter.h"
#include "DepartmentServiceAdapter.h"
#include "SpecialtyServiceAdapter.h"
#include "DoctorServiceAdapter.h"
#include "RoomServiceAdapter.h"
#include "PatientServiceAdapter.h"
#include "MedicalCardServiceAdapter.h"
#include "ScheduleServiceAdapter.h"
#include "ScheduleExceptionServiceAdapter.h"
#include "DiseaseServiceAdapter.h"
#include "SymptomServiceAdapter.h"
#include "SickLeaveServiceAdapter.h"
#include "AppointmentServiceAdapter.h"
#include "VisitServiceAdapter.h"
#include "VisitDiagnosisServiceAdapter.h"
#include "VisitSymptomServiceAdapter.h"
#include "ServiceServiceAdapter.h"
#include "ServiceAppointmentServiceAdapter.h"

#include "AppointmentTicketServiceAdapter.h"
#include "DistrictServiceAdapter.h"
#include "MedicalDocumentServiceAdapter.h"
#include "RegistrarServiceAdapter.h"
#include "SickLeaveRegisterServiceAdapter.h"
#include "StreetServiceAdapter.h"

#include "adapters/UtilsAdapter.h"

#include "DoctorFullInfoViewServiceAdapter.h"
#include "AppointmentFullInfoViewServiceAdapter.h"
#include "PatientsByDistrictViewServiceAdapter.h"
#include "MedicalDocumentFullInfoViewServiceAdapter.h"
#include "SickLeaveFullInfoViewServiceAdapter.h"
#include "SickLeaveRegisterFullViewServiceAdapter.h"

int main(int argc, char* argv[]) {
    QGuiApplication app(argc, argv);

    if(!loadEnv(".env")){
        qDebug() << "Cannot to load env.";
    }

    const QString dbName = getEnv("POSTGRES_DB");
    const QString dbUser = getEnv("POSTGRES_USER");
    const QString dbPassword = getEnv("POSTGRES_PASSWORD");
    const int dbPort = getEnv("PG_PORT").toInt();

    if(!DatabaseManager::instance().connect("localhost", dbPort, dbName, dbUser, dbPassword)) {
        qDebug() << "Connection to database is failed";
        return -1;
    }
    qDebug() << "Database connected";

    // tables
    auto* backendPolyclinic = new GenericService<Polyclinic>();
    auto* backendDepartment = new GenericService<Department>();
    auto* backendSpecialty = new GenericService<Specialty>();
    auto* backendDoctor = new GenericService<Doctor>();
    auto* backendRoom = new GenericService<Room>();
    auto* backendPatient = new GenericService<Patient>();
    auto* backendMedicalCard = new GenericService<MedicalCard>();
    auto* backendSchedule = new GenericService<Schedule>();
    auto* backendScheduleException = new GenericService<ScheduleException>();
    auto* backendDisease = new GenericService<Disease>();
    auto* backendSymptom = new GenericService<Symptom>();
    auto* backendSickLeave = new GenericService<SickLeave>();
    auto* backendAppointment = new GenericService<Appointment>();
    auto* backendVisit = new GenericService<Visit>();
    auto* backendVisitDiagnosis = new GenericService<VisitDiagnosis>();
    auto* backendVisitSymptom = new GenericService<VisitSymptom>();
    auto* backendService = new GenericService<Service>();
    auto* backendServiceAppointment = new GenericService<ServiceAppointment>();

    auto* backendAppointmentTicket = new GenericService<AppointmentTicket>();
    auto* backendDistrict = new GenericService<District>();
    auto* backendMedicalDocument = new GenericService<MedicalDocument>();
    auto* backendRegistrar = new GenericService<Registrar>();
    auto* backendSickLeaveRegister = new GenericService<SickLeaveRegister>();
    auto* backendStreet = new GenericService<Street>();

    // views
    auto* backendDoctorFullInfoView = new ViewsService<DoctorFullInfoView>();
    auto* backendAppointmentFullInfoView = new ViewsService<AppointmentFullInfoView>();
    auto* backendPatientsByDistrictView = new ViewsService<PatientsByDistrictView>();
    auto* backendMedicalDocumentFullInfoView = new ViewsService<MedicalDocumentFullInfoView>();
    auto* backendSickLeaveFullInfoView = new ViewsService<SickLeaveFullInfoView>();
    auto* backendSickLeaveRegisterFullView = new ViewsService<SickLeaveRegisterFullView>();

    auto* adapterPolyclinic = new PolyclinicServiceAdapter(backendPolyclinic, &app);
    auto* adapterDepartment = new DepartmentServiceAdapter(backendDepartment, &app);
    auto* adapterSpecialty = new SpecialtyServiceAdapter(backendSpecialty, &app);
    auto* adapterDoctor = new DoctorServiceAdapter(backendDoctor, &app);
    auto* adapterRoom = new RoomServiceAdapter(backendRoom, &app);
    auto* adapterPatient = new PatientServiceAdapter(backendPatient, &app);
    auto* adapterMedicalCard = new MedicalCardServiceAdapter(backendMedicalCard, &app);
    auto* adapterSchedule = new ScheduleServiceAdapter(backendSchedule, &app);
    auto* adapterScheduleException = new ScheduleExceptionServiceAdapter(backendScheduleException, &app);
    auto* adapterDisease = new DiseaseServiceAdapter(backendDisease, &app);
    auto* adapterSymptom = new SymptomServiceAdapter(backendSymptom, &app);
    auto* adapterSickLeave = new SickLeaveServiceAdapter(backendSickLeave, &app);
    auto* adapterAppointment = new AppointmentServiceAdapter(backendAppointment, &app);
    auto* adapterVisit = new VisitServiceAdapter(backendVisit, &app);
    auto* adapterVisitDiagnosis = new VisitDiagnosisServiceAdapter(backendVisitDiagnosis, &app);
    auto* adapterVisitSymptom = new VisitSymptomServiceAdapter(backendVisitSymptom, &app);
    auto* adapterService = new ServiceServiceAdapter(backendService, &app);
    auto* adapterServiceAppointment = new ServiceAppointmentServiceAdapter(backendServiceAppointment, &app);

    auto* adapterAppointmentTicket = new AppointmentTicketServiceAdapter(backendAppointmentTicket, &app);
    auto* adapterDistrict = new DistrictServiceAdapter(backendDistrict, &app);
    auto* adapterMedicalDocument = new MedicalDocumentServiceAdapter(backendMedicalDocument, &app);
    auto* adapterRegistrar = new RegistrarServiceAdapter(backendRegistrar, &app);
    auto* adapterSickLeaveRegister = new SickLeaveRegisterServiceAdapter(backendSickLeaveRegister, &app);
    auto* adapterStreet = new StreetServiceAdapter(backendStreet, &app);

    auto* adapterUtils = new UtilsAdapter(&app);

    auto* adapterDoctorFullInfoView = new DoctorFullInfoViewServiceAdapter(backendDoctorFullInfoView, &app);
    auto* adapterAppointmentFullInfoView = new AppointmentFullInfoViewServiceAdapter(backendAppointmentFullInfoView, &app);
    auto* adapterPatientsByDistrictView = new PatientsByDistrictViewServiceAdapter(backendPatientsByDistrictView, &app);
    auto* adapterMedicalDocumentFullInfoView = new MedicalDocumentFullInfoViewServiceAdapter(backendMedicalDocumentFullInfoView, &app);
    auto* adapterSickLeaveFullInfoView = new SickLeaveFullInfoViewServiceAdapter(backendSickLeaveFullInfoView, &app);
    auto* adapterSickLeaveRegisterFullView = new SickLeaveRegisterFullViewServiceAdapter(backendSickLeaveRegisterFullView, &app);
    
    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance("Polyclinic.Services", 1, 0, "PolyclinicService", adapterPolyclinic);
    qmlRegisterSingletonInstance("Department.Services", 1, 0, "DepartmentService", adapterDepartment);
    qmlRegisterSingletonInstance("Specialty.Services", 1, 0, "SpecialtyService", adapterSpecialty);
    qmlRegisterSingletonInstance("Doctor.Services", 1, 0, "DoctorService", adapterDoctor);
    qmlRegisterSingletonInstance("Room.Services", 1, 0, "RoomService", adapterRoom);
    qmlRegisterSingletonInstance("Patient.Services", 1, 0, "PatientService", adapterPatient);
    qmlRegisterSingletonInstance("MedicalCard.Services", 1, 0, "MedicalCardService", adapterMedicalCard);
    qmlRegisterSingletonInstance("Schedule.Services", 1, 0, "ScheduleService", adapterSchedule);
    qmlRegisterSingletonInstance("ScheduleException.Services", 1, 0, "ScheduleExceptionService", adapterScheduleException);
    qmlRegisterSingletonInstance("Disease.Services", 1, 0, "DiseaseService", adapterDisease);
    qmlRegisterSingletonInstance("Symptom.Services", 1, 0, "SymptomService", adapterSymptom);
    qmlRegisterSingletonInstance("SickLeave.Services", 1, 0, "SickLeaveService", adapterSickLeave);
    qmlRegisterSingletonInstance("Appointment.Services", 1, 0, "AppointmentService", adapterAppointment);
    qmlRegisterSingletonInstance("Visit.Services", 1, 0, "VisitService", adapterVisit);
    qmlRegisterSingletonInstance("VisitDiagnosis.Services", 1, 0, "VisitDiagnosisService", adapterVisitDiagnosis);
    qmlRegisterSingletonInstance("VisitSymptom.Services", 1, 0, "VisitSymptomService", adapterVisitSymptom);
    qmlRegisterSingletonInstance("Service.Services", 1, 0, "ServiceService", adapterService);
    qmlRegisterSingletonInstance("ServiceAppointment.Services", 1, 0, "ServiceAppointmentService", adapterServiceAppointment);

    qmlRegisterSingletonInstance("AppointmentTicket.Services", 1, 0, "AppointmentTicketService", adapterAppointmentTicket);
    qmlRegisterSingletonInstance("District.Services", 1, 0, "DistrictService", adapterDistrict);
    qmlRegisterSingletonInstance("MedicalDocument.Services", 1, 0, "MedicalDocumentService", adapterMedicalDocument);
    qmlRegisterSingletonInstance("Registrar.Services", 1, 0, "RegistrarService", adapterRegistrar);
    qmlRegisterSingletonInstance("SickLeaveRegister.Services", 1, 0, "SickLeaveRegisterService", adapterSickLeaveRegister);
    qmlRegisterSingletonInstance("Street.Services", 1, 0, "StreetService", adapterStreet);

    qmlRegisterSingletonInstance("Utils", 1, 0, "Utils", adapterUtils);

    qmlRegisterSingletonInstance("DoctorFullInfoView.Services", 1, 0, "DoctorFullInfoViewService", adapterDoctorFullInfoView);
    qmlRegisterSingletonInstance("AppointmentFullInfoView.Services", 1, 0, "AppointmentFullInfoViewService", adapterAppointmentFullInfoView);
    qmlRegisterSingletonInstance("PatientsByDistrictView.Services", 1, 0, "PatientsByDistrictViewService", adapterPatientsByDistrictView);
    qmlRegisterSingletonInstance("MedicalDocumentFullInfoView.Services", 1, 0, "MedicalDocumentFullInfoViewService", adapterMedicalDocumentFullInfoView);
    qmlRegisterSingletonInstance("SickLeaveFullInfoView.Services", 1, 0, "SickLeaveFullInfoViewService", adapterSickLeaveFullInfoView);
    qmlRegisterSingletonInstance("SickLeaveRegisterFullView.Services", 1, 0, "SickLeaveRegisterFullViewService", adapterSickLeaveRegisterFullView);

    using namespace Qt::StringLiterals;
    const QUrl url(u"qrc:/Polyclinic/UI/src/qml/Main.qml"_s);
    engine.load(url);

    if (engine.rootObjects().isEmpty()){
        DatabaseManager::instance().disconnect();
        return -1;
    }

    int exitCode = app.exec();

    DatabaseManager::instance().disconnect();
        
    return exitCode;
}