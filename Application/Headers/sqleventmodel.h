#ifndef SQLEVENTMODEL_H
#define SQLEVENTMODEL_H

#include <QList>
#include <QObject>

#include "Headers/event.h"

class SqlEventModel : public QObject
{
    Q_OBJECT

public:
    SqlEventModel();

    Q_INVOKABLE QList<QObject*> eventsForDate(const QDate &date);

private:
    static void createConnection();
};

#endif // SQLEVENTMODEL_H
