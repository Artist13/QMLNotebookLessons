#include "Headers/visit.h"
#include "Headers/lesson.h"

Visit::Visit(QObject *parent) : QObject(parent)
{
    _ID = -1;
}

Visit::Visit(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_VISITS " WHERE " FIELD_ID " =  :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    _ID = ID;
    _lesson = new Lesson(query.value(FIELD_LESSON).toInt());
    _student = new Student(query.value(FIELD_STUDENT).toInt());
    //qDebug() << _ID << "|" << _Name << "|" << _ClassNum;
}

Visit::~Visit()
{
    delete _lesson;
    delete _student;
}

int Visit::gtID() const
{
    return _ID;
}

Lesson *Visit::lesson() const
{
    return _lesson;
}

void Visit::setLesson(const int &lessonId)
{
    if(_lesson != nullptr)
        if(_lesson->ID() == lessonId)
            return;
    _lesson = new Lesson(lessonId);
    emit lessonChanged();
}

Student *Visit::student() const
{
    return _student;
}

void Visit::setStudent(const int &studentId)
{
    if(_student != nullptr)
        if(_student->ID() == studentId)
            return;
    _student = new Student(studentId);
    emit studentChanged();
}

QString Visit::getStringView() const
{
    return _lesson->StringView() + " " + _student->name();
}

void Visit::Save()
{
    if (_ID == -1)
        CreateNewRecord();
    else
        UpdateRecord();
}

void Visit::CreateNewRecord()
{
    QSqlQuery query;

    query.prepare("INSERT INTO " TABLE_VISITS " (" FIELD_LESSON ", " FIELD_STUDENT ") VALUES (:lesson, :subject)");
    query.bindValue(":lesson", _lesson->ID());
    query.bindValue(":subject", _student->ID());
    if(!query.exec())
    {
        qDebug() << "error insert into " TABLE_VISITS;
        qDebug() << query.lastError().text();
    }
}

void Visit::UpdateRecord()
{
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_VISITS
                  " SET " FIELD_LESSON " = :lesson, " FIELD_STUDENT " = :student  WHERE id = :ID;");
    query.bindValue(":ID", _ID);
    query.bindValue(":lesson", _lesson->ID());
    query.bindValue(":student", _student->ID());
    if(!query.exec())
    {
        qDebug() << "error update " << TABLE_VISITS;
        qDebug() << query.lastError().text();
    }
}

VisitModel::VisitModel(QObject *parent) : QSqlQueryModel (parent)
{
    updateModel("");
}

QVariant VisitModel::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    if(role == StudentName)
    {
        QModelIndex modelIndex = this->index(index.row(), StudentId - Qt::UserRole - 1);
        return getStudentName(QSqlQueryModel::data(modelIndex, Qt::DisplayRole).toInt());
    }

    if (role == LessonName)
    {
        QModelIndex modelIndex = this->index(index.row(), LessonId - Qt::DisplayRole - 1);
        return getLessonName(QSqlQueryModel::data(modelIndex, Qt::DisplayRole).toInt());
    }

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

void VisitModel::addElement(QVariantList data)
{
    Visit* tempVisit = new Visit();
    tempVisit->setLesson(data[1].toInt());
    tempVisit->setStudent(data[0].toInt());
    tempVisit->Save();
}

QHash<int, QByteArray> VisitModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "ID";
    roles[StudentId] = "studentID";
    roles[LessonId] = "lessonID";
    roles[StudentName] = "studentName";
    roles[LessonName] = "lessonName";
    return roles;
}

QString VisitModel::getStudentName(const int studentID) const
{
    Student* tempStudent = new Student(studentID);
    return tempStudent->name();
}

QString VisitModel::getLessonName(const int lessonID) const
{
    qDebug() << lessonID;
    Lesson* tempLesson = new Lesson(lessonID);
    return tempLesson->StringView();
    //return "test";
}

void VisitModel::updateElement(const int row, const QString _stId, const QString _lessonId)
{
    qDebug() << _stId << " " << _lessonId;
    int locID = getId(row);
    Visit* tempVisit = new Visit(locID);
    tempVisit->setStudent(_stId.toInt());
    tempVisit->setLesson(_lessonId.toInt());
    tempVisit->Save();
}

int VisitModel::getId(int row) const
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void VisitModel::updateModel(const QString _filter = "")
{
    QString query;
    if (_filter != "")
        query = "SELECT * FROM " TABLE_VISITS " WHERE " + _filter;
    else
        query = "SELECT * FROM " TABLE_VISITS;
    //qDebug() << query;
    this->setQuery(query);
}

void VisitModel::filterByLesson(const int _lessonId)
{
    updateModel(FIELD_LESSON " = " + QString::number(_lessonId));
}

void VisitModel::add(const QString _stId, const QString _lessonId)
{
    qDebug() << "Get studentId: " << _stId << " and lessonId: " << _lessonId;
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QVariantList data;
    data.append(_stId);
    data.append(_lessonId);
    addElement(data);
    endInsertRows();
}

void VisitModel::remove(int row)
{
    QSqlQuery query;
    query.prepare("DELETE FROM " TABLE_VISITS " WHERE id = :ID ;");
    query.bindValue(":ID", getId(row));

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_VISITS;
        qDebug() << query.lastError().text();
    }
}

QString VisitModel::getStringView(const int row)
{
    int locID = getId(row);
    qDebug() << "list row: " << row << "vist id: " << locID;
    Visit* tempVisit = new Visit(locID);
    //return tempVisit->getStringView();
    return tempVisit->student()->name();
    //return "test";
}
