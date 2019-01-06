#ifndef BASERECORD_H
#define BASERECORD_H

//объект для работы с таблицами

#include <QObject>
#include <QSqlRecord>
#include <QSqlDatabase>

class BaseRecord : public QObject
{
    Q_OBJECT
public:
    explicit BaseRecord(QObject *parent = nullptr);
    //virtual bool createTable(QSqlDatabase &db);
    //virtual bool dropTable(QSqlDatabase &db);


signals:

public slots:

private:
    QSqlRecord record;
};

#endif // BASERECORD_H
