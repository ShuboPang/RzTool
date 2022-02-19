#ifndef SETTINGDATA_H
#define SETTINGDATA_H

#include<QSettings>

class SettingData
{
public:
    SettingData();

    void Init();

public:
    void SetSystemValue(const QString& key,const QString& value);

    QString GetSystemValue(const QString& key, const QString &default_value);

    void SetUserValue(const QString& key,const QString& value);

    QString GetUserValue(const QString& key, const QString &default_value);

    void SetValue(const QString& key,const QString& value,const QString& group);

    QString GetValue(const QString& key,const QString& group,const QString& default_value);

public:
    static SettingData* Instance(){
        static SettingData setting_data;
        return &setting_data;
    }

private:
    QSettings *setting;
};

#endif // SETTINGDATA_H
