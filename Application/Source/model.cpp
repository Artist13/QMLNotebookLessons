#include "Headers/model.h"
#include "Headers/database.h"

Model::Model(QObject *parent) : QSqlQueryModel(parent)
{

}

QVariant Model::data(const QModelIndex &index, int role) const
{
    int columnId = role - Qt::UserRole - 1;

    QModelIndex modelIndex = this->index(index.row(), columnId);

    return QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
}

void Model::addElement(QVariantList data)
{
    //Должно вставлять элемент в базу
    //DataBase db;
    //db.insertIntoTable(data);
}

//Передаем sql фильтр
void Model::getWithFilter(QString _filter)
{
    //this->setQuery("SELECT ID, " FIELD_FNAME ", " FIELD_SNAME ", " FIELD_TNAME ", " FIELD_BIRTH ", " FIELD_CLASS ", " FIELD_SUBJECT " FROM " TABLE_PERSONS " WHERE " + _filter);
}

//возвращает значение Id по номеру строки
int Model::getId(int row)
{
    return this->data(this->index(row, 0), IdRole).toInt();
}

void Model::updateModel()
{
    //this->setQuery("SELECT ID, " FIELD_FNAME ", " FIELD_SNAME ", " FIELD_TNAME ", " FIELD_BIRTH ", " FIELD_CLASS ", " FIELD_SUBJECT " FROM " TABLE_PERSONS);
}

void Model::add(QString _fname, QString _sname, QString _tname, QString _birth, QString _class, QString _subject)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    QVariantList data;
    data.append(_fname);
    data.append(_sname);
    data.append(_tname);
    data.append(_birth);
    data.append(_class);
    data.append(_subject);
    addElement(data);
    endInsertRows();
}

void Model::setFilter(QString _filter)
{
    getWithFilter(_filter);
}



QHash<int, QByteArray> Model::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IdRole] = "ID";
    roles[FNameRole] = "name";
    roles[SNameRole] = "secondName";
    roles[TNameRole] = "thirdName";
    roles[BirthRole] = "birthDay";
    roles[ClassRole] = "classNumber";
    roles[SubjectRole] = "subject";
    return roles;
}

QString Model::getPersonString(int row)
{
    QString name = data(this->index(row, 0), FNameRole).toString();
    QString secName = data(this->index(row, 0), SNameRole).toString();
    QString thName = data(this->index(row, 0), TNameRole).toString();
    return  secName + " " + name + " " + thName;
}
