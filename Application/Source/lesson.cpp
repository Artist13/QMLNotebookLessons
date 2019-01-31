#include "Headers/lesson.h"

Lesson::Lesson(QObject *parent) : QObject(parent)
{
    _ID = -1;
    _date = QDateTime();
    _longs = 0;
    _subj = nullptr;
}

Lesson::Lesson(const int &ID)
{
    Init(ID);
}

Lesson::~Lesson()
{
    delete _subj;
    DestructStudents();
}

void Lesson::Init(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_LESSONS " WHERE " FIELD_ID " =  :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    _ID = ID;
    _date = query.value(FIELD_DATE).toDateTime();
    _longs = query.value(FIELD_LONG).toDouble();
    _subj = Subject::getSubject(query.value(FIELD_SUBJECT).toInt());
    LoadStudents();
    //qDebug() << _ID << "|" << _date.toString() << "|" << _subj->getID();
}

int Lesson::ID() const
{
    return _ID;
}

void Lesson::setID(const int id)
{
    _ID = id;
}

QDateTime Lesson::date()
{
    return _date;
}

void Lesson::setDate(const QDateTime date)
{
    if (_date == date)
        return;
    _date = date;
    emit dateChanged();
}

Subject *Lesson::subject()
{
    return _subj;
}

void Lesson::setSubject(Subject* &subj)
{
    if(_subj != nullptr)
        if (_subj->ID() == subj->ID())
            return;
    _subj = subj;
    emit subjectChanged();
}

double Lesson::longs()
{
    return _longs;
}

void Lesson::setLongs(const double &longs)
{
    if (fabs(_longs - longs) < 1.0e-6)
        return;
    _longs = longs;
    emit onLongsChanged();
}

QString Lesson::name() const
{
    if(_subj != nullptr){
        return _subj->name();
    }else{
        return this->genDefaultName();
    }
}


QString Lesson::StringView()
{
    return _date.toString("dd.MM.yyyy") + " " + _subj->getFullName();
}

void Lesson::save()
{
    //При сохранении с незаполненым полем Subject там объект с некорректными данными
    QSqlQuery query;
    if (_ID == -1)
    {
        CreateNewRecord();
    }else{
        UpdateRecord();
    }
}

int Lesson::getID() const
{
    return _ID;
}

void Lesson::LoadStudents()
{
    //Нужна проверка на то, что ID указан
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_VISITS " WHERE " FIELD_LESSON " = :lessonID");
    query.bindValue(":lessonID", _ID);
    if (!query.exec())
    {
        qDebug() << "error in load lesson's student. lesson ID: " << _ID;
        qDebug() << query.lastError().text();
        return;
    }
    while(query.next())
    {
        _students.push_back(new Student(query.value(FIELD_STUDENT).toInt())); //Нет объекта для студента
    }
}

void Lesson::DestructStudents()
{
    for(int i = 0; i < _students.count(); i++)
    {
        delete _students[i];
    }
}

void Lesson::CreateNewRecord()
{
    QSqlQuery query;

    query.prepare("INSERT INTO " TABLE_LESSONS " (" FIELD_DATE ", " FIELD_SUBJECT ", " FIELD_LONG ") VALUES (:date, :subject, :long)");
    query.bindValue(":date", _date);
    if (_subj == nullptr)
    {
        //Может отсутствовать предмет
        qDebug() << "subject = null";
        //return;
    }else{
        query.bindValue(":subject", _subj->getID());
    }
    query.bindValue(":long", _longs);
    if(!query.exec())
    {
        qDebug() << "error insert into " TABLE_LESSONS;
        qDebug() << query.lastError().text();
    }


}

void Lesson::UpdateRecord()
{
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_LESSONS
                  " SET " FIELD_DATE " = :date, " FIELD_SUBJECT " = :subject , " FIELD_LONG " = :long WHERE id = :ID;");
    query.bindValue(":ID", _ID);
    //QString tempDate = _date;
    //qDebug() << tempDate;
    query.bindValue(":date", _date);
    if (_subj == nullptr)
    {
        //Может отсутствовать предмет
        qDebug() << "subject = null";
        //return;
    }else{
        query.bindValue(":subject", _subj->getID());
    }
    query.bindValue(":long", _longs);
    if(!query.exec())
    {
        qDebug() << "error update " << TABLE_LESSONS;
        qDebug() << query.lastError().text();
    }
}

void Lesson::SaveVisits()
{
    //Следует представить как список посещений
    //Либо хранить изменения в отдельных массивах
    //Пока же просто перезаписываем. Т.к. посещения не должны использоваться в других объектах.
    //По крайней мере по ID
    ClearLessonVisits();
    //Сделать обход листа через итератор
    for(int i = 0; i < _students.count(); i++)
    {
        //Нет объекта. Нет смысла сохранять
    }
}

void Lesson::ClearLessonVisits()
{
    QSqlQuery query;
    query.prepare("DELETE FROM " TABLE_VISITS " WHERE " FIELD_LESSON " = :lessonId");
    query.bindValue(":lessonId", _ID);
    if (!query.exec())
    {
        qDebug() << "error in DELET from " TABLE_VISITS;
        qDebug() << query.lastError().text();
    }
}

QString Lesson::genDefaultName() const
{
    return "Занятие " + _date.toString(Qt::DateFormat::SystemLocaleShortDate);
}

//---------------------------------------------------------------------------------
//Получаем список занятий на дату
//Открываем запрос и переводим его в Лист. Насколько это долго
QList<QObject *> LessonModel::lessonsList(const QDate &date)
{
    QSqlQuery query;
    QDate nextDay = date.addDays(1);//today + 1
    query.prepare("SELECT * FROM " TABLE_LESSONS " WHERE " FIELD_DATE " >= :date and " FIELD_DATE " < :next");
    query.bindValue(":date", date.toString(sqlDateFormat));//Это можно заменить на стандартный формат, но если потребуется изменить, так будет проще
    query.bindValue(":next", nextDay.toString(sqlDateFormat));
    if(!query.exec()){
        qDebug() << "error in getting lessons list by date";
        qDebug() << query.lastError().text();
    }
    QList<QObject*> lessons;
    while(query.next()){
        Lesson* lesson = new Lesson(this);
        lesson->setID(query.value(FIELD_ID).toInt());
        QDateTime locDateTime = query.value(FIELD_DATE).toDateTime();
        if(locDateTime.isValid())
        {
            lesson->setDate(locDateTime);
        }
        //Если предмет не указан, то возбуждается ошибка в sql запросе
        //Это в целом некорректная ситуация. Но нужен корректный результат
        qDebug() << "ToInt: " << query.value(FIELD_SUBJECT).toInt();
        qDebug() << "ToString: " << query.value(FIELD_SUBJECT).toString();
        int locSubjID = query.value(FIELD_SUBJECT).toInt();
        if(locSubjID != 0){
            Subject *locSubj = Subject::getSubject(locSubjID);
            lesson->setSubject(locSubj);
        }
        lessons.append(lesson);
    }

    return lessons;
}
//Получаем объект занятия по ID
QObject* LessonModel::getLessonByID(const int id)
{
    Lesson *tempLesson = new Lesson(id);
    return tempLesson;
}

QObject *LessonModel::getLessonByRow(const int row)
{
    return getLessonByID(getId(row));
}

LessonModel::LessonModel(QObject *parent) : QSqlQueryModel (parent)
{
    updateModel();
}

QVariant LessonModel::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    if (role == SubjectNameRole)
    {
        QModelIndex modelIndex = this->index(index.row(), SubjectRole - Qt::UserRole - 1);
        int subjectID = QSqlQueryModel::data(modelIndex, Qt::DisplayRole).toInt();
        return getSubjectName(subjectID);
    }
    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

void LessonModel::addElement(QVariantList data)
{
    QSqlQuery query;

    Lesson temp;
    temp.setDate(QDateTime::fromString(data[0].toString(), "dd.MM.yyyy"));
    Subject *locSubj = Subject::getSubject(data[1].toInt());
    temp.setSubject(locSubj);
    temp.setLongs(data[2].toDouble());
    temp.save();
}

QHash<int, QByteArray> LessonModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "id";
    roles[DateRole] = "lessonDate";
    roles[SubjectRole] = "lessonSubject";
    roles[LongRole] = "long";
    roles[SubjectNameRole] = "subjectName";
    return roles;
}

QVariant LessonModel::getSubjectName(const int subjectID) const
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_SUBJECTS " WHERE ID = :id");
    query.bindValue(":id", subjectID);
    query.exec();
    query.first();
    //qDebug() << subjectID;
    return query.value(FIELD_NAME).toString() + " " + query.value(FIELD_SUBJCLASS).toString();
}

int LessonModel::getId(int row) const
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void LessonModel::updateModel()
{
    setQuery("SELECT * FROM " TABLE_LESSONS);
}

void LessonModel::add(const QString _date, const QString _subject, const double _long)
{
    //qDebug() << "Add new lesson" << _date << " " << _subject;
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QVariantList data;
    data.append(_date);
    data.append(_subject);
    data.append(_long);
    addElement(data);
    endInsertRows();
}

void LessonModel::remove(int row)
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_LESSONS " WHERE " FIELD_ID " = :ID ;");
    query.bindValue(":ID", getId(row));

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_LESSONS;
        qDebug() << query.lastError().text();
    }

    query.prepare("DELETE FROM " TABLE_VISITS " WHERE " FIELD_LESSON " = :ID:");
    query.bindValue(":ID", getId(row));

    if(!query.exec()){
        qDebug() << "error delete row " << TABLE_VISITS;
        qDebug() << query.lastError().text();
    }
}

void LessonModel::updateElement(const int id, const QString _date, const QString _subject, const double _long)
{
    Lesson temp(id);
    temp.setDate(QDateTime::fromString(_date, "dd.MM.yyyy HH:mm"));
    Subject *locSubj = new Subject(_subject.toInt());
    temp.setSubject(locSubj);
    temp.setLongs(_long);
    temp.save();
}

QAbstractTableModel *LessonModel::visitList(const int row)
{
    int locID = getId(row);
    VisitModel* result = new VisitModel();
    result->updateModel("ID = " + QString::number(locID));
    return result;
}

QString LessonModel::getStringView(const int row)
{
    return this->data(this->index(row, 0), DateRole).toString() + " " + this->data(this->index(row, 0), SubjectNameRole).toString();
    //Заменить на создание объекта и получение от него строкового представления
}

QString LessonModel::getStringViewById(const int id)
{
    QString result = "";
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_LESSONS " WHERE ID = " + QString::number(id));
    query.exec();
    query.first();
    result =  query.value(FIELD_DATE).toString();
    int subjectId = query.value(FIELD_SUBJECT).toInt();
    SubjectModel *subjects = new SubjectModel();
    return result + " " + subjects->getNameByID(subjectId);
}
