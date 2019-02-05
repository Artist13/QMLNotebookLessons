#ifndef PERSON_H
#define PERSON_H

#include <QString>
#include <QDate>
#include <QSqlQueryModel>
#include <QList>
#include "database.h"

#include <QObject>

class Person : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int ID READ ID WRITE setID NOTIFY IDChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString secondName READ secondName WRITE setSecondName NOTIFY secondNameChanged)
    Q_PROPERTY(QString thirdName READ thirdName WRITE setThirdName NOTIFY thirdNameChanged)
    Q_PROPERTY(QDate birth READ birth WRITE setBirth NOTIFY birthChanged)
    Q_PROPERTY(QString phone READ phone WRITE setPhone NOTIFY phoneChanged)

public:
    Person();
    Person(const QString _name, const QString _secName, const QString _thName, const QDate _birth);
    Person(const int &ID);
    static Person* getPerson(const int ID);
    ~Person();

    int ID() const;
    void setID(const int &ID);
    QString getStringName() const;

    QString name() const;
    void setName(const QString name);

    QString secondName() const;
    void setSecondName(const QString secondName);

    QString thirdName() const;
    void setThirdName(const QString thirdName);

    QDate birth() const;
    void setBirth(const QDate birth);

    QString phone() const;
    void setPhone(const QString &phone);

    Q_INVOKABLE void save();
    Q_INVOKABLE void remove();
//private:

signals:
    void IDChanged();
    void nameChanged();
    void secondNameChanged();
    void thirdNameChanged();
    void birthChanged();
    void phoneChanged();

private:
    int _ID;
    QString _name;
    QString _secondName;
    QString _thirdName;
    QDate _birth;
    QString _phone;//Следует превратить в объект

    void CreateNewRecord();
    void UpdateRecord();
};

class PersonModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit PersonModel(QObject *parent = nullptr);

    enum Roles{
            IdRole = Qt::UserRole + 1,
            FNameRole,
            SNameRole,
            TNameRole,
            BirthRole,
            PhoneRole
        };
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    //Переводит список полей указанных в объекте в запрос
    void addElement(QVariantList data);
    void getWithFilter(QString _filter);
protected:
    QHash<int, QByteArray> roleNames() const;
    QString filter;
signals:

public slots:
    QString getPersonString(int row);
    int getId(int row);
    void updateModel();
    void add(QString _fname, QString _sname, QString _tname, QString _birth, QString _phone);
    void setFilter(QString _filter);
    void updateElement(int row, QString _fname, QString _sname, QString _tname, QString _birth, QString _phone);
    void remove(int row);
    QString getNameByID(const int ID);
    QObject* getByID(const int ID);
};


#endif // PERSON_H
