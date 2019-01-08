#ifndef LESSON_H
#define LESSON_H

#include <QString>
#include <QDate>
#include <QSqlQueryModel>
#include <QList>
#include "database.h"

#include <QObject>
#include "visit.h"
#include "subject.h"
#include "student.h"

//Объект для работы с занятием. Есть куски более низкого слоя(SQL запросы)
class Lesson : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int ID READ ID WRITE setID NOTIFY IDChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)

    //Q_PROPERTY(Subject* subject READ subject WRITE setSubject NOTIFY subjectChanged)
public:
    explicit Lesson(QObject *parent = nullptr);
    Lesson(const int &ID);
    ~Lesson();

    void Init(const int &ID);


    int ID() const;
    void setID(const int id);
    QDateTime date();
    void setDate(const QDateTime date);
    Subject* subject();
    void setSubject(const int &subjID);
    double longs();
    void setLongs(const double &longs);
    QString name() const;

    QString StringView();

    Q_INVOKABLE void Save();
    //void Save();
    int getID() const;
signals:
    void dateChanged();
    void subjectChanged();
    void onLongsChanged();
    void IDChanged();
    void nameChanged();


private:
    int _ID;
    QDateTime _date;
    QList<Student*> _students;
    Subject* _subj;
    double _longs;

    void LoadStudents();
    void DestructStudents();
    void CreateNewRecord();
    void UpdateRecord();
    void SaveVisits();
    void ClearLessonVisits();
};

class LessonModel : public QSqlQueryModel
{
    Q_OBJECT

    //Q_INVOKABLE QList<QObject*> lessonsList(const QDate &date);
public:
    explicit LessonModel(QObject *parent = nullptr);
    enum Roles{
        IdRole = Qt::UserRole + 1,
        DateRole,
        SubjectRole,
        LongRole,
        SubjectNameRole
    };
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    void addElement(QVariantList data);
protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QVariant getSubjectName(const int subjectID) const;
public Q_SLOTS:
    //QString getSubjectString(int row) const;
    int getId(int row) const;
    void updateModel();
    void add(const QString _date, const QString _subject, const double _long);
    void remove(int row);
    //void setFilter(QString _filter);
    void updateElement(const int id, const QString _date, const QString _subject, const double _long);
    QAbstractTableModel* visitList(const int row);
    QString getStringView(const int row);
    QString getStringViewById(const int id);
    //QString getNameByID(const int ID) const;
    QList<QObject*> lessonsList(const QDate &date);
    //Пробую использовать MOC
    QObject *getLessonByID(const int id);
    QObject *getLessonByRow(const int row);
};

#endif // LESSON_H
