#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include <QQmlContext>


#include "Headers/database.h"
#include "Headers/model.h"
#include "Headers/qmldatamapper.h"
#include "Headers/student.h"
#include "Headers/subject.h"
#include "Headers/lesson.h"
#include "Headers/visit.h"
#include "Headers/sqleventmodel.h"

//#include "testsubjectmodel.h"



void addClassNumbers(QQmlApplicationEngine *engine){
    QStringList classNumbers;
    classNumbers.append("");
    classNumbers.append("9");
    classNumbers.append("11");

    engine->rootContext()->setContextProperty("ClassNumbers", classNumbers);
}


int main(int argc, char *argv[])
{
    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    //QGuiApplication app(argc, argv);

    QApplication app(argc, argv);
    //qmlRegisterType<Subject>("test.Subject", 1, 0, "Subject");
    qmlRegisterType<SqlEventModel>("org.qtproject.examples.calendar", 1, 0, "SqlEventModel");
    //qmlRegisterType<Lesson>("myTypes.Lesson", 1, 0, "MyLesson");

    QQmlApplicationEngine engine;

    DataBase database;
    QSqlQuery test;
    test.prepare("SELECT * FROM " TABLE_PERSONS);
    test.exec();
    int count = 0;
    while(test.next())
        count++;
    qDebug() << "records count in PERSONS TABLE = " << count;
    PersonModel *PerModel = new PersonModel();
    StudentSQL *StModel = new StudentSQL();
    SubjectModel *SubjModel = new SubjectModel();
    LessonModel *LessonsModel = new LessonModel();
    VisitModel *VisitsModel = new VisitModel();
    //PersonModel *model = new PersonModel();

    QmlDataMapper *PersonMapper = new QmlDataMapper();
    PersonMapper->setModel(PerModel);
    QmlDataMapper *StudentMapper = new QmlDataMapper();
    StudentMapper->setModel(StModel);
    QmlDataMapper *SubjectMapper = new QmlDataMapper();
    SubjectMapper->setModel(SubjModel);
    QmlDataMapper *LessonMapper = new QmlDataMapper();
    LessonMapper->setModel(LessonsModel);
    QmlDataMapper *VisitMapper = new QmlDataMapper();
    VisitMapper->setModel(VisitsModel);

    //TestSubjectModel* testModel = new TestSubjectModel();
    //engine.rootContext()->setContextProperty("testModel", testModel);
    addClassNumbers(&engine);


    engine.rootContext()->setContextProperty("PersonsModel", PerModel);
    engine.rootContext()->setContextProperty("PersonMapper", PersonMapper);
    engine.rootContext()->setContextProperty("database", &database);
    engine.rootContext()->setContextProperty("StudentsModel", StModel);
    engine.rootContext()->setContextProperty("StudentMapper", StudentMapper);
    engine.rootContext()->setContextProperty("SubjectsModel", SubjModel);
    engine.rootContext()->setContextProperty("SubjectMapper", SubjectMapper);
    engine.rootContext()->setContextProperty("LessonsModel", LessonsModel);
    engine.rootContext()->setContextProperty("LessonMapper", LessonMapper);
    engine.rootContext()->setContextProperty("VisitsModel", VisitsModel);
    engine.rootContext()->setContextProperty("VisitMapper", VisitMapper);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}


