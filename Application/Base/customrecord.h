#ifndef CUSTOMRECORD_H
#define CUSTOMRECORD_H

#include <QObject>
#include <QObject>

//Базовая запиь для объектов представляющих записи в системе
//Например все записи должны иметь метод предоставляющий имя для вывода в списке
//Методы save и remove и др реализующие работу с базой тоже будут подняты сюда
//В дальнейшем через внедрение зависимости и выделение класса можно будет изменять методы хранения

class CustomRecord : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString nameForList READ nameForList)
public:
    explicit CustomRecord(QObject *parent = nullptr);
    virtual QString nameForList() const = 0;
    virtual ~CustomRecord();
signals:

public slots:
};

#endif // CUSTOMRECORD_H
