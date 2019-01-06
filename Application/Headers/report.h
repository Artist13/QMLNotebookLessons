#ifndef REPORT_H
#define REPORT_H

#include <QObject>
#include <QString>
#include <QDate>
#include <QVector>

#include "subject.h"

//Содержит данные о прошедшем периоде
//Данные по каждому дню
//--Данные по каждому предмету
//----Кол-во часов, кол-во учеников, предмет

struct Period{
    QDate DateStart;
    QDate DateEnd;
};

struct SubjectData{
    double _hours;
    int _persons;
    Subject* _subj;
};


struct OneDay{
    QVector<SubjectData> subjects;
};

class Report : public QObject
{
    Q_OBJECT
public:
    explicit Report(QObject *parent = nullptr);

    static Report* CreateReport(const QString &settings, Period reportPeriod);


signals:

public slots:

private:
    QString _settings;
    QVector<OneDay> _days;
};

#endif // REPORT_H
