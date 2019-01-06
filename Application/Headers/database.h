#ifndef DATABASE_H
#define DATABASE_H

#include <QObject>
#include <QtSql>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlDatabase>
#include <QFile>
#include <QDate>
#include <QDebug>

//Перенести таблицы в соответствующие классы
//База общая

#include "dbconsts.h"


class DataBase : public QObject
{
    Q_OBJECT
public:
    typedef QPair<QString, QString> FieldPair;
    struct FieldsDescriptions{
    public:
        QVector<FieldPair> Fields;
        void AddField(FieldPair field){
            if (CheckFieldName(field.first))
                Fields.push_back(field);
        }
        void AddField(const QString fieldName, const QString fieldDesc)
        {
            AddField(FieldPair(fieldName, fieldDesc));
        }
        int Count(){
            return Fields.count();
        }

        FieldPair operator[](const int index){
            return Fields[index];
        }
    private:
        bool CheckFieldName(QString fieldName){
            int tempCount = Fields.count();
            for(int i = 0; i < tempCount; i++)
            {
                if (Fields[i].first == fieldName)
                    return false;
            }
            return true;
        }
    };

    explicit DataBase(QObject *parent = nullptr);
    ~DataBase();

    void connectToDataBase(const QString path);
    bool AddTable(const QString tableName, FieldsDescriptions fields);
    bool AddRecordInTable(const QString TableName, FieldsDescriptions fields);
    bool insertPersonIntoTable(const QVariantList &data);
private:
    QSqlDatabase db;

private:
    bool openDataBase(const QString path = "/home/morganf/Projects/TestSql");
    bool restoreDataBase(const QString path = "/home/morganf/Projects/TestSql");
    void closeDataBase();
    bool createTable();

    const QString curPath = "/home/morganf/Projects/DatabaseForStudents/";
public slots:
    bool insertPersonIntoTable(const QString &fname, const QString &sname, const QString &tname, const QString &phone, const QString &birth);
    bool removeRecord(const int id);
};

#endif // DATABASE_H
