#ifndef SUBJECT_H
#define SUBJECT_H

#include <QString>
#include <QDate>
#include <QSqlQueryModel>
#include <QList>
#include "database.h"
#include "dbconsts.h"

#include <QObject>

class Subject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int ID READ ID WRITE setID NOTIFY IDChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(int classNum READ classNum WRITE setClassNum NOTIFY classNumChanged)
public:
    explicit Subject(QObject *parent = nullptr);
    Subject(const int &ID);
    Subject(Subject& _other);
    static Subject* getSubject(const int &ID);

    Subject operator=(Subject& _other);

    int ID() const;
    void setID(const int &id);

    QString name() const;
    void setName(const QString &name);

    int classNum() const;
    void setClassNum(const int &classNum);

    void Save();
    int getID();

    QString getFullName() const;

    ~Subject();
signals:
    void IDChanged();
    void nameChanged();
    void classNumChanged();

public slots:

private:
    int _ID;
    QString _Name;
    int _ClassNum;
    QStringList Classes;

    void CreateNewRecord() const;
    void UpdateRecord();
};


class SubjectModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    explicit SubjectModel(QObject *parent = nullptr);
    enum Roles{
            IdRole = Qt::UserRole + 1,
            NameRole,
            ClassRole
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
    QString getSubjectString(int row) const;
    int getId(int row) const;
    void updateModel();
    void add(const QString _name, const QString _classNum);
    void remove(int row);
    void setFilter(QString _filter);
    void updateElement(const int row, const QString _name, const QString _classNum);
    QString getNameByID(const int ID) const;
};

#endif // SUBJECT_H
