#ifndef STUDENT_H
#define STUDENT_H

#include <QObject>
#include "person.h"
#include "subject.h"


class Student : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ name)
    Q_PROPERTY(Person* person READ person WRITE setPerson NOTIFY personChanged)
    Q_PROPERTY(int classNum READ classNum WRITE setClassNum NOTIFY classNumChanged)
    Q_PROPERTY(Subject* subject READ subject WRITE setSubject NOTIFY subjectChanged)
public:
    explicit Student(QObject *parent = nullptr);
    Student(Person*, int, QString);
    Student(const QString _name, const QString _fname, const QString _thname, const QDate _birth, const int _class, const QString _subject);
    Student(const int &ID);
    static Student* getStudent(const int ID);
    ~Student();

    int getID() const;

    QString name() const;

    Person* person() const;
    void setPerson(Person* pers);

    int classNum() const;
    void setClassNum(const int& ClassNum);

    Subject* subject() const;
    void setSubject(Subject* subj);

    void Save();
signals:
    void classNumChanged();
    void subjectChanged();
    void personChanged();

private:
    int _ID;
    Person* _person;
    int _classNum;
    Subject* _subject;

    void CreateNewRecord();
    void UpdateRecord();
};


class StudentSQL : public QSqlQueryModel
{
    Q_OBJECT
public:
    enum Roles{
        IdRole = Qt::UserRole + 1,
        PersonRole,
        ClassRole,
        SubjectRole,
        PersonNameRole,
        SubjectNameRole
    };
    explicit StudentSQL(QObject* paren = nullptr);
    StudentSQL(Student* someSt);
    void addElement(const int _person, const int _class, const QString _subject);

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QVariant getPersonName(const int personID) const;
    QVariant getSubjectName(const int subjectID) const;
public Q_SLOTS:
    int getId(int row);
    void updateModel();
    void add(const int _person, const int _class, const QString _subject);
    void remove(int row);
    void updateElement(const int row, const int _person, const int _class, const QString _subject);
    QString getStringView(const int row);
    QString getStringViewById(const int id);
};

#endif // STUDENT_H
