import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item {
    id: topBar

    height: 50

    RowLayout{
        anchors.fill: parent
        //column: 5

        Button{
            text: "Люди"

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5

            onClicked: {
                PersonsModel.updateModel()
                mainFrame.sourceComponent = personsComponent
            }
        }

        Button{
            text: "Ученики"

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5

            onClicked: {
                StudentsModel.updateModel()
                mainFrame.sourceComponent = studentsComponent
            }
        }

        Button{
            text: "Предметы"

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5
            Layout.alignment: Qt.AlignLeft

            onClicked: {
                SubjectsModel.updateModel()
                mainFrame.sourceComponent = subjectsComponent
            }
        }

        Button{
            text: qsTr("Занятия")

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5
            Layout.alignment: Qt.AlignLeft

            onClicked: {
                LessonsModel.updateModel()
                //mainFrame.source = "DevelopElem.qml";
                mainFrame.sourceComponent = lessonsComponent
            }
        }

        Button{
            text: qsTr("Посещения")

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5
            Layout.alignment: Qt.AlignLeft

            onClicked: {
                VisitsModel.updateModel("")
                mainFrame.sourceComponent = visitsComponent
            }
        }

        Button{
            text: qsTr("Test")

            width: 150
            Layout.fillHeight: true
            Layout.margins: 5
            Layout.alignment: Qt.AlignLeft

            onClicked: {
                mainFrame.sourceComponent = testListComponent
            }
        }

    }
}
