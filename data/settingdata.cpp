#include "settingdata.h"


SettingData::SettingData()
{
    setting = new QSettings("./setting/config.ini",QSettings::IniFormat);

}

void SettingData::Init(){

}

void SettingData::SetSystemValue(const QString& key,const QString& value){
    SetValue(key,value,"system");
}

QString SettingData::GetSystemValue(const QString& key,const QString& default_value){
    return GetValue(key,"system",default_value);
}

void SettingData::SetUserValue(const QString& key,const QString& value){
    SetValue(key,value,"user");
}

QString SettingData::GetUserValue(const QString& key, const QString &default_value){
    return GetValue(key,"user",default_value);
}

void SettingData::SetValue(const QString& key,const QString& value,const QString& group){
    setting->beginGroup(group);
    setting->setValue(key,value);
    setting->endGroup();
}

QString SettingData::GetValue(const QString& key,const QString& group,const QString& default_value){
    setting->beginGroup(group);
    QString value = default_value;
    if( setting->value(key) != NULL){
        value = setting->value(key).toString();
    }
    else{
        setting->setValue(key,default_value);
    }
    setting->endGroup();
    return value;
}
