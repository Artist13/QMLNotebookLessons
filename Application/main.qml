import QtQml 2.0
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import "Views"
import org.qtproject.examples.calendar 1.0

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    id: mainWindow
    title: qsTr("Hello World")

    SystemPalette {
        id: systemPalette
    }

    SqlEventModel {
        id: eventModel
    }



    TabView {
        anchors.fill: parent
        Tab {
            title: "Главная"
            MainPage{

            }

        }
        Tab {
            title: "Люди"
            PersonsTableView {
                id: personsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Ученики"
            StudentsTableView{
                id: studentsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Предметы"
            SubjectsTableView{
                id: subjectsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Занятия"
            LessonsTableView{
                id: lessonsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Посещения"
            VisitsTableView{
                id: visitsList
                anchors.fill: parent
            }
        }
//        Tab {
//            title: "Green"
//            Rectangle { color: "green" }
//        }
    }
}
