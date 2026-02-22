#pragma once 

#include <QString>

bool loadEnv(const QString& path);

QString getEnv(const QString& key, const QString& defaultValue = "");