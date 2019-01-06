#include "Headers/student.h"

Student::Student(QObject *parent) : QObject(parent)
{
    _ID = -1;
}

Student::Student(Person *, int, QString)
{
    _ID = -1;
}

Student::Student(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_STUDENTS " WHERE " FIELD_ID " =  :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    _ID = ID;
    _person = new Person(query.value(FIELD_PERSON).toInt());
    _classNum = query.value(FIELD_STCLASS).toInt();
    _subject = new Subject(query.value(FIELD_SUBJECT).toInt());
    //_ClassNum = query.value(FIELD_SUBJCLASS).toInt();
    //qDebug() << _ID << "|" << _Name << "|" << _ClassNum;
}

Student::~Student()
{
    delete _person;
}

int Student::getID() const
{
    return _ID;
}

QString Student::name() const
{
    return _person->getStringName() + " " + _subject->getFullName();
}

void Student::setPerson(const int &personID)
{
    if(_person != nullptr)
        if(_person->getID() == personID)
            return;
    _person = new Person(personID);
    emit personChanged();
}

int Student::classNum() const
{
    return _classNum;
}

void Student::setClassNum(const int &ClassNum)
{
    if(ClassNum == _classNum)
        return;
    _classNum = ClassNum;
}

Subject *Student::subject() const
{
    return _subject;
}

void Student::setSubject(const int &ID)
{
    if(_subject != nullptr)
        if (_subject->getID() == ID)
            return;
    _subject = new Subject(ID);
    emit subjectChanged();
}

void Student::Save()
{
    if(_ID == -1)
        CreateNewRecord();
    else
        UpdateRecord();
}

void Student::CreateNewRecord()
{
    QSqlQuery query;

    query.prepare("INSERT INTO " TABLE_STUDENTS " (" FIELD_PERSON ", " FIELD_STCLASS ", " FIELD_SUBJECT ") VALUES (:person, :classNum, :subject)");

    query.bindValue(":person", _person->getID());
    query.bindValue(":classNum", _classNum);
    query.bindValue(":subject", _subject->getID());
    if(!query.exec())
    {
        qDebug() << "error insert into " TABLE_STUDENTS;
        qDebug() << query.lastError().text();
    }
}

void Student::UpdateRecord()
{
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_STUDENTS
                  " SET " FIELD_PERSON " = :person, " FIELD_STCLASS " = :classNum , " FIELD_SUBJECT " = :subject WHERE id = :ID;");
    query.bindValue(":ID", _ID);
    query.bindValue(":person", _person->getID());
    query.bindValue(":classNum", _classNum);
    query.bindValue(":subject", _subject->getID());
    if(!query.exec())
    {
        qDebug() << "error update " << TABLE_STUDENTS;
        qDebug() << query.lastError().text();
    }
}

StudentSQL::StudentSQL(QObject* parent) : QSqlQueryModel(parent)
{
    updateModel();
}

StudentSQL::StudentSQL(Student *someSt)
{

}

void StudentSQL::addElement(const int _person, const int _class, const QString _subject)
{
    Student* tempStudent = new Student();
    tempStudent->setPerson(_person);
    tempStudent->setClassNum(_class);
    tempStudent->setSubject(_subject.toInt());
    tempStudent->Save();
}

QVariant StudentSQL::data(const QModelIndex &index, int role) const
{    int columnId = role - Qt::UserRole - 1;


    if (role == PersonNameRole)
    {
        QModelIndex modelIndex = this->index(index.row(), PersonRole - Qt::UserRole - 1);
        int personID = QSqlQueryModel::data(modelIndex, Qt::DisplayRole).toInt();
        //qDebug() << "Person ID " <<  personID;
        return getPersonName(personID);
    }
    if (role == SubjectNameRole)
    {
        QModelIndex modelIndex = this->index(index.row(), SubjectRole - Qt::UserRole - 1);
        int subjectID = QSqlQueryModel::data(modelIndex, Qt::DisplayRole).toInt();
        return getSubjectName(subjectID);
    }
    QModelIndex modelIndex = this->index(index.row(), columnId);
    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

QHash<int, QByteArray> StudentSQL::roleNames() const
{
    //В таблице нет роли для имени
    //Можно перенести в конец
    QHash<int, QByteArray> roles;
    roles[IdRole] = "ID";
    roles[PersonRole] = "person";
    roles[PersonNameRole] = "personName";
    roles[ClassRole] = "classNum";
    roles[SubjectRole] = "subject";
    roles[SubjectNameRole] = "subjectName";
    return roles;
}

QVariant StudentSQL::getPersonName(const int personID) const
{
    Person* tempPerson = new Person(personID);
    return tempPerson->getStringName();
}

QVariant StudentSQL::getSubjectName(const int subjectID) const
{
    Subject* tempSubject = new Subject(subjectID);
    return tempSubject->getFullName();
}

int StudentSQL::getId(int row)
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void StudentSQL::updateModel()
{
    this->setQuery("SELECT * FROM " TABLE_STUDENTS);
}

void StudentSQL::add(const int _person, const int _class, const QString _subject)
{
    addElement(_person, _class, _subject);
}

void StudentSQL::remove(int row)
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_STUDENTS " WHERE id = :ID ;");
    query.bindValue(":ID", getId(row));

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_STUDENTS;
        qDebug() << query.lastError().text();
    }
}

void StudentSQL::updateElement(const int row, const int _person, const int _class, const QString _subject)
{
    int locID = getId(row);

    Student* tempStudent = new Student(locID);
    tempStudent->setPerson(_person);
    tempStudent->setClassNum(_class);
    tempStudent->setSubject(_subject.toInt());
    tempStudent->Save();
}

QString StudentSQL::getStringView(const int row)
{
    qDebug() << "try to get ID";
    int locID = getId(row);
    //return QString::number(locID);
    return getStringViewById(locID);
}

QString StudentSQL::getStringViewById(const int id)
{
    Student* tempStudent = new Student(id);
    return tempStudent->name();
}

