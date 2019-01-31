#include "Headers/subject.h"



Subject::Subject(QObject *parent) : QObject(parent), Classes{"9","11"}
{
    _ID = -1;
    _Name = "New Subject";
    _ClassNum = 0;
}

Subject::Subject(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_SUBJECTS " WHERE " FIELD_ID " = :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    if(query.isValid()){
        _ID = ID;
        _Name = query.value(FIELD_NAME).toString();
        _ClassNum = query.value(FIELD_SUBJCLASS).toInt();
        //qDebug() << _ID << "|" << _Name << "|" << _ClassNum;
    }else{
        qDebug() << "Subject not found";
        //return nullptr;
    }

}

Subject::Subject(Subject &_other)
{
    _ID = _other.ID();
    _Name = _other.name();
    _ClassNum = _other.classNum();
}

Subject *Subject::getSubject(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_SUBJECTS " WHERE " FIELD_ID " = :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    if(query.isValid()){
        Subject* locSubj = new Subject();
        locSubj->setID(ID);
        locSubj->setName(query.value(FIELD_NAME).toString());
        locSubj->setClassNum(query.value(FIELD_SUBJCLASS).toInt());
        return locSubj;
        //qDebug() << _ID << "|" << _Name << "|" << _ClassNum;
    }else{
        qDebug() << "Subject not found";
        return nullptr;
    }
}

Subject Subject::operator=(Subject &_other)
{
    _ID = _other.ID();
    _Name = _other.name();
    _ClassNum = _other.classNum();
}

int Subject::ID() const
{
    return _ID;
}

void Subject::setID(const int &id)
{
    if(_ID == id)
        return;
    _ID = id;
    emit IDChanged();
}

QString Subject::name() const
{
    return _Name;
}

void Subject::setName(const QString &name)
{
    if(_Name == name)
        return;
    _Name = name;
    emit nameChanged();
}

int Subject::classNum() const
{
    return _ClassNum;
}

void Subject::setClassNum(const int &classNum)
{
    if(_ClassNum == classNum)
        return;
    _ClassNum = classNum;
    emit classNumChanged();
}

void Subject::Save()
{
    if (_ID == -1)
        CreateNewRecord();
    else
        UpdateRecord();
}

int Subject::getID()
{
    return _ID;
}

QString Subject::getFullName() const
{
    return _Name + " " + QString::number(_ClassNum);
}

Subject::~Subject()
{

}

void Subject::CreateNewRecord() const
{
    QSqlQuery query;
    qDebug() << "save subject";
    query.prepare("INSERT INTO " TABLE_SUBJECTS " (" FIELD_NAME ", " FIELD_SUBJCLASS ") VALUES (:name, :classNum)");
    query.bindValue(":name", _Name);
    query.bindValue(":classNum", _ClassNum);
    if(!query.exec())
    {
        qDebug() << "error insert into " TABLE_SUBJECTS;
        qDebug() << query.lastError().text();
    }
}

void Subject::UpdateRecord()
{
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_SUBJECTS
                  " SET " FIELD_NAME " = :name, " FIELD_SUBJCLASS " = :classNum  WHERE id = :ID;");
    query.bindValue(":ID", _ID);
    query.bindValue(":name", _Name);
    query.bindValue(":classNum", _ClassNum);
    if(!query.exec())
    {
        qDebug() << "error update " << TABLE_SUBJECTS;
        qDebug() << query.lastError().text();
    }
}

SubjectModel::SubjectModel(QObject* parent) : QSqlQueryModel(parent)
{
    updateModel();
}

QVariant SubjectModel::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

void SubjectModel::addElement(QVariantList data)
{
    Subject* tempSubject = new Subject();
    tempSubject->setName(data[0].toString());
    tempSubject->setClassNum((data[1].toInt()));
    tempSubject->Save();
}

QHash<int, QByteArray> SubjectModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "ID";
    roles[NameRole] = "name";
    roles[ClassRole] = "classNum";
    return roles;
}

QString SubjectModel::getSubjectString(int row) const
{
    int locID = getId(row);
    return getNameByID(locID);
}

int SubjectModel::getId(int row) const
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void SubjectModel::updateModel()
{
    this->setQuery("SELECT * FROM " TABLE_SUBJECTS);
}

void SubjectModel::add(const QString _name, const QString _classNum)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QVariantList data;
    data.append(_name);
    data.append(_classNum);
    addElement(data);
    endInsertRows();
}

void SubjectModel::remove(int row)
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_SUBJECTS " WHERE id = :ID ;");
    query.bindValue(":ID", getId(row));

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_SUBJECTS;
        qDebug() << query.lastError().text();
    }
}

void SubjectModel::setFilter(QString _filter)
{

}

void SubjectModel::updateElement(const int row, const QString _name, const QString _classNum)
{
    //QSqlRecord tempRec = record(row);
    int locID = getId(row);

    Subject* tempSubj = new Subject(locID);
    tempSubj->setName(_name);
    tempSubj->setClassNum(_classNum.toInt());
    tempSubj->Save();
}

QString SubjectModel::getNameByID(const int ID) const
{
    Subject* tempSubjecct = new Subject(ID);
    return tempSubjecct->getFullName();
}
