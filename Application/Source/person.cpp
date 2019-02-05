#include "Headers/person.h"
#include <QDebug>



Person::Person()
{
    _ID = -1;
}

Person::Person(const QString _name, const QString _secName, const QString _thName, const QDate _birth) : _name(_name), _secondName(_secName), _thirdName(_thName), _birth(_birth)
{
    _ID = -1;
}

Person::Person(const int &ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_PERSONS " WHERE " FIELD_ID " =  :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    _ID = ID;
    _name = query.value(FIELD_FNAME).toString();
    _secondName = query.value(FIELD_SNAME).toString();
    _thirdName = query.value(FIELD_TNAME).toString();
    qDebug() << "birth date:" << query.value(FIELD_BIRTH).toDate();
    _birth = query.value(FIELD_BIRTH).toDate();
    _phone = query.value(FIELD_PHONE).toString();
}

Person *Person::getPerson(const int ID)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM " TABLE_PERSONS " WHERE " FIELD_ID " =  :ID");
    query.bindValue(":ID", ID);
    query.exec();
    //Нужна проверка на уникальность записи
    query.first();
    if(query.isValid()){
        auto locPerson = new Person(ID);
        //locPerson->setID(ID); //Лишнее оно и так установится
        return locPerson;
    }else{
        return nullptr;
    }
}

Person::~Person()
{

}

int Person::ID() const
{
    return _ID;
}

void Person::setID(const int &ID)
{
    if(ID == _ID)
        return;
    _ID = ID;
    emit IDChanged();
}


QString Person::getStringName() const
{
    return _secondName + " " + _name + " " + _thirdName;
}

QString Person::name() const
{
    return _name;
}

void Person::setName(const QString name)
{
    if(name == _name)
        return;
    _name = name;
    emit nameChanged();
}

QString Person::secondName() const
{
    return _secondName;
}

void Person::setSecondName(const QString secondName)
{
    if(secondName == _secondName)
        return;
    _secondName = secondName;
    emit secondNameChanged();
}

QString Person::thirdName() const
{
    return _thirdName;
}

void Person::setThirdName(const QString thirdName)
{
    if(_thirdName == thirdName)
        return;
    _thirdName = thirdName;
    emit thirdNameChanged();
}

QDate Person::birth() const
{
    return _birth;
}

void Person::setBirth(const QDate birth)
{
    if(_birth == birth)
        return;
    _birth = birth;
}

QString Person::phone() const
{
    return _phone;
}

void Person::setPhone(const QString &phone)
{
    if (_phone == phone)
        return;
    _phone = phone;
    emit phoneChanged();
}

void Person::save()
{
    if(_ID == -1)
        CreateNewRecord();
    else
        UpdateRecord();
}
//Нужно реализовывать механизм проверки ссылочности.
//Для этого все действия с БД нужно выносить в отдельную прослойку //РАЗНЫЕ УРОВНИ
void Person::remove()
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_PERSONS " WHERE " FIELD_ID " = :ID ;");
    query.bindValue(":ID", _ID);

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
    }
}

void Person::CreateNewRecord()
{
    QSqlQuery query;
    qDebug() << "try to save";
    query.prepare("INSERT INTO " TABLE_PERSONS " (" FIELD_FNAME ", " FIELD_SNAME ", " FIELD_TNAME ", " FIELD_BIRTH ", " FIELD_PHONE ") VALUES (:fname, :sname, :tname, :birth, :phone)");

    query.bindValue(":fname", _name);
    query.bindValue(":sname", _secondName);
    query.bindValue(":tname", _thirdName);
    //query.bindValue(":birth", _birth.toString(Qt::DateFormat::ISODate));
    query.bindValue(":birth", _birth.toString(Qt::DateFormat::ISODate));
    query.bindValue(":phone", _phone);
    qDebug() << "try to exec";
    if(!query.exec())
    {
        qDebug() << "error insert into " TABLE_PERSONS;
        qDebug() << query.lastError().text();
    }
}

void Person::UpdateRecord()
{
    QSqlQuery query;
    query.prepare("UPDATE " TABLE_PERSONS
                  " SET " FIELD_FNAME " = :fname, " FIELD_SNAME " = :sname , " FIELD_TNAME " = :tname, " FIELD_BIRTH " = :birth, " FIELD_PHONE " = :phone WHERE id = :ID;");
    query.bindValue(":ID", _ID);
    query.bindValue(":fname", _name);
    query.bindValue(":sname", _secondName);
    query.bindValue(":tname", _thirdName);
    qDebug() << _birth.toString(Qt::DateFormat::ISODate);
    query.bindValue(":birth", _birth.toString(Qt::DateFormat::ISODate));
    query.bindValue(":phone", _phone);
    if(!query.exec())
    {
        qDebug() << "error update " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
    }
}

PersonModel::PersonModel(QObject *parent) : QSqlQueryModel(parent)
{
    updateModel();
}

QVariant PersonModel::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    if (role == BirthRole)
    {
        return QSqlQueryModel::data(this->index(index.row(), columnId), Qt::DisplayRole).toDate().toString("dd.MM.yyyy");
    }

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

void PersonModel::addElement(QVariantList data)
{
    Person* tempPerson = new Person();
    tempPerson->setName(data[0].toString());
    tempPerson->setSecondName((data[1].toString()));
    tempPerson->setThirdName(data[2].toString());
    tempPerson->setBirth(QDate::fromString(data[3].toString(), "dd.MM.yyyy"));
    tempPerson->setPhone(data[4].toString());
    tempPerson->save();
}

//Передаем sql фильтр
void PersonModel::getWithFilter(QString _filter)
{
    this->setQuery("SELECT ID, " FIELD_FNAME ", " FIELD_SNAME ", " FIELD_TNAME ", " FIELD_BIRTH ", " FIELD_PHONE " FROM " TABLE_PERSONS " WHERE " + _filter);
}

//возвращает значение Id по номеру строки
int PersonModel::getId(int row)
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void PersonModel::updateModel()
{
    this->setQuery("SELECT * FROM " TABLE_PERSONS);
}
//Not work
void PersonModel::add(QString _fname, QString _sname, QString _tname, QString _birth, QString _phone)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QVariantList data;
    data.append(_fname);
    data.append(_sname);
    data.append(_tname);
    data.append(_birth);
    data.append(_phone);
    addElement(data);
    endInsertRows();
}

void PersonModel::setFilter(QString _filter)
{
    getWithFilter(_filter);
}

void PersonModel::updateElement(int row, QString _fname, QString _sname, QString _tname, QString _birth, QString _phone)
{
    int locID = getId(row);

    Person* tempPerson = new Person(locID);
    tempPerson->setName(_fname);
    tempPerson->setSecondName(_sname);
    tempPerson->setThirdName(_tname);
    qDebug() << _birth;
    qDebug() << QDate::fromString(_birth, "dd.MM.yyyy");
    tempPerson->setBirth(QDate::fromString(_birth, "dd.MM.yyyy"));
    tempPerson->setPhone(_phone);
    tempPerson->save();
}

void PersonModel::remove(int row)
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_PERSONS " WHERE id = :ID ;");
    query.bindValue(":ID", getId(row));

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
    }
}

QString PersonModel::getNameByID(const int ID)
{
    Person* tempPerson = new Person(ID);
    return tempPerson->getStringName();
}

QObject *PersonModel::getByID(const int ID)
{
    return Person::getPerson(ID);
}

QHash<int, QByteArray> PersonModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "ID";
    roles[FNameRole] = "name";
    roles[SNameRole] = "secondName";
    roles[TNameRole] = "thirdName";
    roles[BirthRole] = "birthDay";
    roles[PhoneRole] = "phone";
    return roles;
}

QString PersonModel::getPersonString(int row)
{
    int locID = getId(row);
    Person* tempPerson = new Person(locID);
    return tempPerson->getStringName();
}
