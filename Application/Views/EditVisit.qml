import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Dialog{
    id: topElement
    title: nameBl
    height: 440
    width: 480

    property bool isNew: false
    property string nameBl: "Edit"
    property int targetIndex : -1
    property int parentLesson: -1
    function setLesson(lessonId){
        parentLesson = lessonId;
    }

    function editEntry(row, lesson)
    {
        console.log("Created")
        targetIndex = row
        if(row === -1){
            isNew = true;
            nameBl = "New visit"
            console.log(lesson)
            if(lesson !== -1)
            {
                fullLesson(lesson)
            }
            VisitMapper.newData();
        }
        else{
            isNew = false;
            //console.log(targetIndex)
            nameBl = "Edit visit"
            studentName.text = VisitsModel.getStudentName(studentId.text)
            lessonName.text = VisitsModel.getLessonName(lessonId.text)
            VisitMapper.updateData(row)
        }
        open()
    }
    contentItem: Rectangle{
        implicitHeight: 220
        implicitWidth: 480

        GridLayout{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            rowSpacing: 10
            columnSpacing: 10
            rows: 4
            columns: 3

            Text {
                text: qsTr("Student")
                Layout.fillWidth: true
            }

            TextField{
                id: studentId
                visible: false
            }

            TextField{
                id: studentName
                Layout.preferredWidth: 200
            }

            Button{
                id: chooseSt
                text: qsTr("&Выбрать")
                Layout.preferredWidth: 90
                onClicked: {
                    listforChooseStudent.open()
                }
            }


            Text {
                text: qsTr("Lesson Name")
                Layout.fillWidth: true
            }

            TextField{
                id: lessonName
                Layout.preferredWidth: 200
            }

            TextField{
                id: lessonId
                visible: false
                Layout.preferredWidth: 200
            }

            Button{
                id: chooseLesson
                text: qsTr("&Выбрать")
                Layout.preferredWidth: 90
                onClicked: {
                    listForChoosenLesson.open()
                }
            }

        }

        Rectangle{
            color: "#eeeeee"
            height: 50
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout{
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5
                spacing:  10

                Button{
                    id: buttonPrevios
                    text: qsTr("Prev")
                    Layout.preferredWidth: 80

                    onClicked: {
                        VisitMapper.toPrevious()
                    }
                }

                Button{
                    id: buttonNext
                    text: qsTr("Next")
                    Layout.preferredWidth: 80

                    onClicked: {
                        VisitMapper.toNext()
                    }
                }

                Rectangle{
                    Layout.fillWidth: true
                    color: "#eeeeee"
                }

                Button{
                    id: buttonOk
                    text: qsTr("Ok")
                    Layout.preferredWidth: 80
                    onClicked: {
                        if(targetIndex === -1){
                            save()
                        }else
                        {
                            updateElement(targetIndex)
                        }
                        close()
                    }
                }

                Button{
                    id: buttonCancel
                    text: qsTr("Cancel")
                    Layout.preferredWidth: 80
                    onClicked: {
                        close()
                    }
                }

                Button{
                    text: qsTr("Refresh")
                    onClicked: {
                        //console.log(targetIndex);
                        VisitMapper.updateData(targetIndex)
                    }
                }
            }
        }


        Component.onCompleted: {
            VisitMapper.addMapping(studentId, (0x100 + 2), "text")
            VisitMapper.addMapping(lessonId, (0x100 + 3), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента
    function save()
    {
        console.log("save new");
        //database.insertIntoTable(nameField.text, secondNameField.text, thirdNameField.text, phoneField.text, birthField.text);
        VisitsModel.add(studentId.text, lessonId.text)
        VisitsModel.updateModel("")
    }
    function updateElement(_index){
        console.log("save old")
        VisitsModel.updateElement(targetIndex, studentId.text, lessonId.text)
        VisitsModel.updateModel("")
    }

    function fullStudent(stId){
        studentId.text = stId;
        var locName = StudentsModel.getStringViewById(stId);
        studentName.text = locName;
    }

    function fullLesson(lessId){
        lessonId.text = lessId;
        lessonName.text = LessonsModel.getStringViewById(lessId);
    }

    Dialog{
        id: listforChooseStudent
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return list.getChoosen();
        }

        StudentsListView{
            id: list
            anchors.fill: parent

        }

        onAccepted: {
            var locIndex = list.choosenElement;
            var locID = StudentsModel.getId(locIndex);
            fullStudent(locID);
        }
    }

    Dialog{
        id: listForChoosenLesson
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return listLessons.getChoosen();
        }

        LessonsListView{
            id: listLessons
            anchors.fill: parent
        }

        onAccepted: {
            var locIndex = listLessons.choosenElement;
            console.log(locIndex);
            var locID = LessonsModel.getId(locIndex);
            console.log(locID);
            fullLesson(locID);
        }
    }
}
