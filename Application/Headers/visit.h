#ifndef VISIT_H
#define VISIT_H

#include <QString>
#include <QDate>
#include <QSqlQueryModel>
#include <QList>
#include "database.h"

#include <QObject>

class Lesson;
class Student;

class Visit : public QObject
{
    Q_OBJECT
public:
    explicit Visit(QObject *parent = nullptr);
    Visit(const int &ID);
    ~Visit();

    int gtID() const;

    Lesson* lesson() const;
    void setLesson(const int &lessonId);

    Student* student() const;
    void setStudent(const int &studentId);

    QString getStringView() const;

    void Save();
signals:
    void lessonChanged();
    void studentChanged();

private:
    int _ID;
    Lesson* _lesson;
    Student* _student;

    void CreateNewRecord();
    void UpdateRecord();
};

class VisitModel : public QSqlQueryModel
{
    Q_OBJECT
public:
    //static void addVisit(const QString StId, const QString LesId);
    explicit VisitModel(QObject *parent = nullptr);
    enum Roles{
        IdRole = Qt::UserRole + 1,
        StudentId,
        LessonId,
        StudentName,
        LessonName
    };
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    void addElement(QVariantList data);
protected:
    QHash<int, QByteArray> roleNames() const;

public Q_SLOTS:
    //QString getSubjectString(int row) const;
    int getId(int row) const;
    void updateModel(const QString _filter);
    void filterByLesson(const int _lessonId);
    void add(const QString _stId, const QString _lessonId);
    void remove(int row);
    QString getStringView(const int row);
    QString getStudentName(const int studentID) const;
    QString getLessonName(const int lessonID) const;
    //void setFilter(QString _filter);
    void updateElement(const int row, const QString _stId, const QString _lessonId);
    //QString getNameByID(const int ID) const;

};

#endif // VISIT_H
