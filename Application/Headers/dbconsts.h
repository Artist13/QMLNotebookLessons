#ifndef DBCONSTS_H
#define DBCONSTS_H

#include <QString>

//Константы для базы данных
#define DATABASE_HOSTNAME "ExampleDataBase"
#define DATABASE_NAME "DataBase.db"

//Общие поля
#define FIELD_ID "id" //primary key
#define FIELD_SUBJECT "subject" //external key

//Тблица с людьми
#define TABLE_PERSONS "TablePersons"

#define FIELD_FNAME "firstName" //String
#define FIELD_SNAME "secondName" //String
#define FIELD_TNAME "thirdName" //String
#define FIELD_BIRTH "birthDay" //Date
#define FIELD_PHONE "phone" //String

//Таблица со студентами
//FIELD_ID
#define TABLE_STUDENTS "TableStudents"
#define FIELD_PERSON "person" //external key
#define FIELD_STCLASS "classNum" //int
//FIELD_SUBJECT

#define TABLE_SUBJECTS "TableSubjects"
#define FIELD_NAME "name"
#define FIELD_SUBJCLASS "classNum"


//Таблица занятий
#define TABLE_LESSONS "TableLessons"
//FIELD_ID
//FIELD_SUBJECT // external key
#define FIELD_DATE "lessonDate" //Date
#define FIELD_LONG "lessonLong" //real
//Спиоск студентов реализован через таблицу с полями Студент_ИД | Занятие_ИД

//Таблица связей
#define TABLE_VISITS "TableVisits"
//FIELD_ID //primary key
#define FIELD_STUDENT "student" // external key
#define FIELD_LESSON "lesson" // external key

const QString sqlDateFormat = "yyyy-MM-dd";
const QString sqlDateTimeFormat = "yyyy-MM-dd hh:MM";


#endif // DBCONSTS_H
