#include <QCoreApplication>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>
#include <QProcessEnvironment>
#include <QLibrary>

int main(int argc, char* argv[]) {
    QCoreApplication a(argc, argv);

    // QLibrary lib("sqldrivers/qsqlpsql.dll");
    // if (!lib.load()) {
    //     qDebug() << "!!! cannot load plugin !!!";
    //     qDebug() << "error system:" << lib.errorString();
    //     return -1;
    // } else {
    //     qDebug() << "success.";
    //     lib.unload();
    // }

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    QString dbName = env.value("POSTGRES_DB");
    QString dbUser = env.value("POSTGRES_USER");
    QString dbPassword = env.value("POSTGRES_PASSWORD");
    int dbPort = env.value("PG_PORT").toInt();

    QSqlDatabase db = QSqlDatabase::addDatabase("QPSQL");
    db.setHostName("localhost");
    db.setPort(dbPort);
    db.setDatabaseName(dbName);
    db.setUserName(dbUser);
    db.setPassword(dbPassword);

    if(!db.open()) {
        qDebug() << "error connection: " << db.lastError().text();
        return -1;
    }

    qDebug() << "vse work\n";
    return 0;
}