#include "EnvLoader.h"
#include <QFile>
#include <QTextStream>
#include <QMap>
#include <QDebug>

static QMap<QString, QString> envMap;

bool loadEnv(const QString& path){
    QFile file(path);

    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        return false;
    }
    QTextStream in(&file);
    while(!in.atEnd()){
        QString line = in.readLine().trimmed();
        if(line.isEmpty() || line.startsWith('#')){
            continue;
        }

        size_t separatorIndex = line.indexOf('=');
        if(separatorIndex == SIZE_MAX){
            continue;
        }

        QString key = line.left(separatorIndex).trimmed();
        QString value = line.mid(separatorIndex + 1).trimmed();

        if (value.length() >= 2) {
            QChar first = value.front();
            QChar last = value.back();

            if ((first == '"' && last == '"') || 
                (first == '\'' && last == '\'')) {
                
                value = value.mid(1, value.length() - 2);
            }
        }
        envMap[key] = value;
    }
    file.close();
    return true;
}

QString getEnv(const QString& key, const QString& defaultValue){
    return envMap.value(key, defaultValue);
}