import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
//import "MyTypes.Lesson"

Dialog{
    id: topElement
    title: nameBl
    height: 440
    width: 480



    property bool isNew: false
    property string nameBl: "Edit"
    property int targetIndex : -1
    property var targetObject;


    function create(targetDate){
        isNew = true;
        nameBl = "Добавить занятие"
        LessonMapper.newData();
        date.text = targetDate.toLocaleDateString(Qt.locale(), "dd.MM.yyyy");
        date.visible = false;
        open()
    }

    function editEntry(row)
    {
        targetIndex = row
        if(row === -1){
            isNew = true;
            nameBl = "New lesson"
            LessonMapper.newData();
            //visiters.openWithFilter(-1)
        }
        else{
            isNew = false;
            //console.log(targetIndex)
            nameBl = "Edit lesson"
            LessonMapper.updateData(row)
            targetObject = LessonsModel.getLessonByRow(row);
            date.text = targetObject.date.toLocaleString(Qt.locale(), "dd.MM.yyyy hh:MM");
            //visiters.openWithFilter(LessonsModel.getId(row))
            subjectName.text = SubjectsModel.getNameByID(subjectID.text);
        }

        open()
    }
    contentItem: Rectangle{
        id: form
        implicitHeight: 220
        implicitWidth: 480

        readonly property color baseTextColor: "white"
        readonly property color baseBGColor: "#2e2f30"
        readonly property int fontSize: 16
        color: baseBGColor


        GridLayout{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            rowSpacing: 10
            columnSpacing: 10
            rows: 7
            columns: 3

            BaseText {
                text: qsTr("Дата")
                Layout.fillWidth: true
                visible: false
            }


            TextField{
                id: date
                Layout.columnSpan: 2
                Layout.preferredWidth: 300

            }
            Calendar{
                visible: false
            }


            BaseText {
                text: qsTr("Предмет")
                Layout.fillWidth: true
            }

            TextField{
                id: subjectID
                visible: false
                Layout.preferredWidth: 300
                Layout.columnSpan: 2
            }

            TextField{
                id: subjectName
                readOnly: true
                Layout.preferredWidth: 200
            }

            Button{
                id: chooseSubject
                Layout.preferredWidth: 90
                text: qsTr("Выбрать")

                onClicked: {
                    listSubjectsForChoose.open();
                }
            }

            BaseText{
                text: qsTr("Длительность")
                Layout.fillWidth: true
            }

            TextField{
                id: longs
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
            }


        }

//        Rectangle{
//            //color: 'red'
//            anchors.bottom: bottomButtons.top
//            anchors.left: parent.left
//            anchors.right: parent.right
//            height: 100
//            VisitsListView{
//                id: visiters
//                anchors.fill: parent
//                lessonId: LessonsModel.getId(targetIndex)
//            }
//        }

        Rectangle{
            id: bottomButtons
            color: form.baseBGColor
            height: 40
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            RowLayout{
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 5
                spacing:  10
                //Пока не знаю нужны ли они
//                Button{
//                    id: buttonPrevios
//                    text: qsTr("Prev")
//                    Layout.preferredWidth: 80

//                    onClicked: {
//                        LessonMapper.toPrevious()
//                    }
//                }

//                Button{
//                    id: buttonNext
//                    text: qsTr("Next")
//                    Layout.preferredWidth: 80

//                    onClicked: {
//                        LessonMapper.toNext()
//                    }
//                }

                Rectangle{
                    Layout.fillWidth: true
                    color: "#eeeeee"
                }

                Button{
                    id: buttonOk
                    text: qsTr("Ok")
                    Layout.preferredWidth: 80
                    onClicked: {
                        //console.log("And error")
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

//                Button{
//                    text: qsTr("Refresh")
//                    onClicked: {
//                        LessonMapper.updateData(targetIndex)
//                    }
//                }
            }
        }


        Component.onCompleted: {
            LessonMapper.addMapping(date, (0x100 + 2), "text")
            LessonMapper.addMapping(subjectID, (0x100 + 3), "text")
            LessonMapper.addMapping(longs, (0x100 + 4), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента
    function save()
    {
        console.log("save new lesson");
        //database.insertIntoTable(nameField.text, secondNameField.text, thirdNameField.text, phoneField.text, birthField.text);
        LessonsModel.add(date.text, subjectID.text, longs.text)
        LessonsModel.updateModel()
    }
    function updateElement(_index){
        console.log("save old")
        LessonsModel.updateElement(targetIndex, date.text, subjectID.text, longs.text)
        LessonsModel.updateModel()
    }

    Dialog{
        id: listSubjectsForChoose
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return listSubjects.getChoosen();
        }

        SubjectListView{
            id: listSubjects
            anchors.fill: parent
        }

        onVisibleChanged: {
            SubjectsModel.updateModel()
        }

        onAccepted: {
            var locIndex = listSubjects.choosenElement;
            var locSubjID = SubjectsModel.getId(locIndex);
            subjectID.text = locSubjID;
            subjectName.text = SubjectsModel.getNameByID(locSubjID);
        }
    }
}

