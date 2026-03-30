#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QtQml>
#include <QDebug>

#include "core/EnvLoader.h"
#include "database/DatabaseManager.h"
#include "services/GenericService.h"
#include "PolyclinicServiceAdapter.h"

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

    auto* backend = new GenericService<Polyclinic>();
    auto* adapter = new PolyclinicServiceAdapter(backend, &app);

    QQmlApplicationEngine engine;

    qmlRegisterSingletonInstance(
        "Polyclinic.Services", 1, 0, "PolyclinicService", adapter
    );

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