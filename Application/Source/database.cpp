#include "Headers/database.h"
#include <QDebug>

DataBase::DataBase(QObject *parent) : QObject(parent)
{
    this->connectToDataBase(curPath);
    QSqlQuery query;

    /*-------------------------------------------
    Передаточные матрицы
            dx/dt = Ax + bu
            y =Cx

            u(t) - непрерывное заданное для всех t >= 0
            ||u(t)|| <= pe^at
            -----------------------------*/
    /*query.exec("DROP TABLE " TABLE_PERSONS);
    FieldsDescriptions personsFields;
    personsFields.AddField(FieldPair(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT"));
    personsFields.AddField(FIELD_FNAME, "VARCHAR(255)");
    personsFields.AddField(FIELD_SNAME, "VARCHAR(255)");
    personsFields.AddField(FIELD_TNAME, "VARCHAR(255)");
    personsFields.AddField(FIELD_BIRTH, "DATE");
    personsFields.AddField(FIELD_PHONE, "VARCHAR(255)");
    this->AddTable(TABLE_PERSONS, personsFields);

    query.exec("DROP TABLE " TABLE_STUDENTS);
    FieldsDescriptions studentsFields;
    studentsFields.AddField(FieldPair(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT"));
    studentsFields.AddField(FieldPair(FIELD_PERSON, "INTEGER"));
    studentsFields.AddField(FieldPair(FIELD_STCLASS, "INTEGER"));
    studentsFields.AddField(FieldPair(FIELD_SUBJECT, "INTEGER"));
    this->AddTable(TABLE_STUDENTS, studentsFields);
    query.exec("DROP TABLE " TABLE_SUBJECTS);
    FieldsDescriptions subjectsFields;
    subjectsFields.AddField((FieldPair(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT")));
    subjectsFields.AddField(FieldPair(FIELD_NAME, "VARCHAR(255)"));
    subjectsFields.AddField(FieldPair(FIELD_SUBJCLASS, "VARACHAR(255)"));
    this->AddTable(TABLE_SUBJECTS, subjectsFields);
    query.exec("DROP TABLE " TABLE_LESSONS);
    FieldsDescriptions lessonsFields;
    lessonsFields.AddField(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT");
    lessonsFields.AddField(FIELD_DATE, "DATETIME");
    lessonsFields.AddField(FIELD_SUBJECT, "INTEGER");
    lessonsFields.AddField(FIELD_LONG, "REAL");
    this->AddTable(TABLE_LESSONS, lessonsFields);
    query.exec("DROP TABLE " TABLE_VISITS);
    FieldsDescriptions visitsFields;
    visitsFields.AddField(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT");
    visitsFields.AddField(FIELD_STUDENT, "INTEGER");
    visitsFields.AddField(FIELD_LESSON, "INTEGER");
    this->AddTable(TABLE_VISITS, visitsFields);*/
}
//Передаем QVariantList с необходимыми полями
bool DataBase::insertPersonIntoTable(const QVariantList &data)
{
    /*FieldsDescriptions fields;

    fields.AddField(FieldPair(FIELD_FNAME, data[0].toString()));
    fields.AddField(FieldPair(FIELD_SNAME, data[1].toString()));
    fields.AddField(FieldPair(FIELD_TNAME, data[2].toString()));
    fields.AddField(FieldPair(FIELD_BIRTH, data[3].toString()));
    fields.AddField(FieldPair(FIELD_PHONE, data[4].toString()));
    return AddRecordInTable(TABLE_PERSONS, fields);*/
    QSqlQuery query;

    query.prepare("INSERT INTO " TABLE_PERSONS " (" FIELD_FNAME ","
                                            FIELD_SNAME ","
                                            FIELD_TNAME ","
                                            FIELD_BIRTH ","
                                            FIELD_PHONE ")"
                  " VALUES (:Name, :SecName, :ThName, :Birth, :Phone)");
    query.bindValue(":Name", data[0].toString());
    query.bindValue(":SecName", data[1].toString());
    query.bindValue(":ThName", data[2].toString());
    query.bindValue(":Birth", data[3].toString());
    query.bindValue(":Phone", data[4].toString());

    if(!query.exec())
    {
        qDebug() << "error insert into " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
        return false;
    }else
    {
        return true;
    }
}

bool DataBase::insertPersonIntoTable(const QString &fname, const QString &sname, const QString &tname, const QString &phone, const QString &birth)
{
    QVariantList data;
    data.append(fname);
    data.append(sname);
    data.append(tname);
    QDate locDate = QDate::fromString(birth, "dd.MM.yyyy");
    data.append(birth);
    data.append(phone);
    return insertPersonIntoTable(data);
    //return false;
}

bool DataBase::removeRecord(const int id)
{
    QSqlQuery query;

    query.prepare("DELETE FROM " TABLE_PERSONS " WHERE id = :ID ;");
    query.bindValue(":ID", id);

    if(!query.exec())
    {
        qDebug() << "error delete row " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
        return false;
    }else
    {
        return true;
    }
}
DataBase::~DataBase()
{

}

void DataBase::connectToDataBase(const QString path)
{
    if(!QFile(path + DATABASE_NAME).exists())
    {
        qDebug() << "Restore DB";
        restoreDataBase(path);
    }else
    {
        qDebug() << "Open DB";
        openDataBase(path);
    }
}

bool DataBase::AddTable(const QString tableName, FieldsDescriptions fields)
{
    if (fields.Count() <= 0)
    {
        qDebug() << "Нельзя добавить таблицу без полей";
        return false;
    }
    QSqlQuery query;
    QString queryStr = "";
    int tempCount = fields.Count() - 1;

    queryStr = "CREATE TABLE " + tableName + " (";
    for(int i = 0; i < tempCount; i++)
    {
        queryStr += fields[i].first + " " + fields[i].second + ", ";
    }
    queryStr += fields[tempCount].first + " " + fields[tempCount].second +")";
    //qDebug() << queryStr;
    if(!query.exec(queryStr))
    {
        qDebug() << "DataBase error of create" << tableName;
        qDebug() << query.lastError().text();
        return false;
    }else
    {
        return true;
    }
}

bool DataBase::AddRecordInTable(const QString TableName, DataBase::FieldsDescriptions fields)
{
    //Если список полей пустЁ добавится пустая запись?
    //Будет ошибка, т.к. tempCount = -1
    QSqlQuery query;
    QString queryStr = "";
    QString valuesStr = "";
    int tempCount = fields.Count() - 1;


    if (fields.Count() > 0)
    {
        queryStr = "INSERT INTO " + TableName + " (";
        valuesStr = "VALUES (";
        for(int i = 0; i < tempCount; i++)
        {
            queryStr += fields[i].first + ", ";
            valuesStr += ":" + fields[i].first + ", ";
        }
        valuesStr += ":" + fields[tempCount].first + ");";
        queryStr += fields[tempCount].first + ") " + valuesStr;
        query.prepare(queryStr);
        for(int i = 0; i < fields.Count(); i++)
        {
            //qDebug() << ":" + fields[i].first + " " + fields[i].second;
            query.bindValue(":" + fields[i].first, fields[i].second);
        }
    }
    else
    {
        queryStr = "INSERT INTO " + TableName;
    }
    //qDebug() << queryStr;
    if(!query.exec(queryStr))
    {
        qDebug() << "DataBase error of insert in " << TABLE_PERSONS;
        qDebug() << query.lastError().text();
        return false;
    }else
    {
        return true;
    }

}

bool DataBase::openDataBase(const QString path)
{
    db = QSqlDatabase::addDatabase("QSQLITE");
    db.setHostName(DATABASE_HOSTNAME);
    db.setDatabaseName(path + DATABASE_NAME);

    if(!db.open())
    {
        qDebug() << "something wrong";
        qDebug() << db.lastError().text();
        return false;
    }else
    {
        qDebug() << "All right";
        return true;
    }

}

bool DataBase::restoreDataBase(const QString path)
{
    if(this->openDataBase(path))
    {
        if(!this->createTable())
        {
            return false;
        }else
        {
            return true;
        }
    }else
    {
        qDebug() << "Не удалось восстановить базу данных";
        return false;
    }
}

void DataBase::closeDataBase()
{
    db.close();
}

bool DataBase::createTable()
{
    FieldsDescriptions temp;
    temp.AddField(FieldPair(FIELD_ID, "INTEGER PRIMARY KEY AUTOINCREMENT"));
    temp.AddField(FieldPair(FIELD_FNAME, "VARCHAR(255)"));
    temp.AddField(FieldPair(FIELD_SNAME, "VARCHAR(255)"));
    temp.AddField(FieldPair(FIELD_TNAME, "VARCHAR(255)"));
    temp.AddField(FieldPair(FIELD_BIRTH, "DATE"));
    temp.AddField(FieldPair(FIELD_PHONE, "VARCHAR(255)"));
    return AddTable(TABLE_PERSONS, temp);

}
