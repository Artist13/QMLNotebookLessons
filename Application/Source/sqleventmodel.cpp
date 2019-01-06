#include "Headers/sqleventmodel.h"

#include <QDebug>
#include <QFileInfo>
#include <QSqlError>
#include <QSqlQuery>

SqlEventModel::SqlEventModel()
{
    createConnection();
}

QList<QObject*> SqlEventModel::eventsForDate(const QDate &date)
{
    const QString queryStr = QString::fromLatin1("SELECT * FROM Event WHERE '%1' >= startDate AND '%1' <= endDate").arg(date.toString("yyyy-MM-dd"));
    QSqlQuery query(queryStr);
    if (!query.exec())
        qFatal("Query failed");

    QList<QObject*> events;
    while (query.next()) {
        Event *event = new Event(this);
        event->setName(query.value("name").toString());

        QDateTime startDate;
        startDate.setDate(query.value("startDate").toDate());
        startDate.setTime(QTime(0, 0).addSecs(query.value("startTime").toInt()));
        event->setStartDate(startDate);

        QDateTime endDate;
        endDate.setDate(query.value("endDate").toDate());
        endDate.setTime(QTime(0, 0).addSecs(query.value("endTime").toInt()));
        event->setEndDate(endDate);

        events.append(event);
    }

    return events;
}

/*
    Defines a helper function to open a connection to an
    in-memory SQLITE database and to create a test table.
*/
void SqlEventModel::createConnection()
{
//    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
//    db.setDatabaseName(":memory:");
//    if (!db.open()) {
//        qFatal("Cannot open database");
//        return;
//    }

    QSqlQuery query;
    // We store the time as seconds because it's easier to query.
    query.exec("DROP TABLE Event");
    query.exec("create table Event (name TEXT, startDate DATE, startTime INT, endDate DATE, endTime INT)");
    query.exec("insert into Event values('Математика 9 кл', '2019-01-01', 36000, '2019-01-01', 39600)");
    query.exec("insert into Event values('Информатика 11 кл', '2019-01-01', 57600, '2019-01-01', 61200)");
    query.exec("insert into Event values('Математика 11 кл', '2019-01-15', 57600, '2019-01-15', 63000)");
    query.exec("insert into Event values('Математика 9 кл', '2019-01-24', 32400, '2019-01-24', 61200)");

    return;
}
