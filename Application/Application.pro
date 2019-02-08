QT += quick qml widgets sql testlib
CONFIG += c++11
TEMPLATE = app
# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
SUBDIRS += \
    Headers \
    Base \
    Source \
    Views
SOURCES += \
        main.cpp \
    Source/baserecord.cpp \
    Source/bootstrap.cpp \
    Source/database.cpp \
    Source/lesson.cpp \
    Source/model.cpp \
    Source/person.cpp \
    Source/qmldatamapper.cpp \
    Source/report.cpp \
    Source/salarysetting.cpp \
    Source/student.cpp \
    Source/subject.cpp \
    Source/visit.cpp \
    Source/event.cpp \
    Source/sqleventmodel.cpp \
    Base/customrecord.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Headers/baserecord.h \
    Headers/bootstrap.h \
    Headers/database.h \
    Headers/dbconsts.h \
    Headers/lesson.h \
    Headers/model.h \
    Headers/person.h \
    Headers/report.h \
    Headers/salarysetting.h \
    Headers/student.h \
    Headers/subject.h \
    Headers/visit.h \
    Headers/qmldatamapper.h \
    Headers/event.h \
    Headers/sqleventmodel.h \
    Base/customrecord.h

DISTFILES +=
