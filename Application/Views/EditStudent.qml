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
    function editEntry(row)
    {
        targetIndex = row
        if(row === -1){
            isNew = true;
            nameBl = "New student"
            StudentMapper.newData();

        }
        else{
            isNew = false;
            //console.log(targetIndex)
            nameBl = "Edit student"
            StudentMapper.updateData(row)
            personName.text = PersonsModel.getNameByID(personID.text);
            subjectName.text = SubjectsModel.getNameByID(subjectID.text);

            //Не правильно получает данные
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
                text: qsTr("Person ID")
                Layout.fillWidth: true
            }

            TextField{
                id: personID
                visible: false
                //Layout.preferredWidth: 200
            }

            TextField{
                id: personName
                readOnly: true
                Layout.preferredWidth: 200
            }

            Button{
                id: choosePerson
                Layout.preferredWidth: 90
                text: qsTr("Выбрать")

                onClicked: {
                    listforChoose.open();
                }
            }

            Text {
                text: qsTr("Class Number")
                Layout.fillWidth: true
            }

            TextField{
                id: classNum
                Layout.preferredWidth: 300
                Layout.columnSpan: 2
            }

            Text {
                text: qsTr("Subject")
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
                    listForChoosenSubj.open();
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
                        StudentMapper.toPrevious()
                    }
                }

                Button{
                    id: buttonNext
                    text: qsTr("Next")
                    Layout.preferredWidth: 80

                    onClicked: {
                        StudentMapper.toNext()
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
            }
        }


        Component.onCompleted: {
            StudentMapper.addMapping(personID, (0x100 +2), "text")
            StudentMapper.addMapping(classNum, (0x100 + 3), "text")
            StudentMapper.addMapping(subjectID, (0x100 + 4), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента
    function save()
    {
        console.log("save new");
        //database.insertIntoTable(nameField.text, secondNameField.text, thirdNameField.text, phoneField.text, birthField.text);
        StudentsModel.add(personID.text, classNum.text, subjectID.text)
        StudentsModel.updateModel()
    }
    function updateElement(_index){
        console.log("save old")
        StudentsModel.updateElement(targetIndex, personID.text, classNum.text, subjectID.text)
        StudentsModel.updateModel()
    }

    Dialog{
        id: listforChoose
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return list.getChoosen();
        }

        PersonsListView{
            id: list
            anchors.fill: parent

        }

        onAccepted: {
            var locIndex = list.choosenElement;
            var locPersID = PersonsModel.getId(locIndex);
            personID.text = locPersID;
            var locName = PersonsModel.getNameByID(locPersID);
            personName.text = locName;
        }
    }

    Dialog{
        id: listForChoosenSubj
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

        onAccepted: {
            var locIndex = listSubjects.choosenElement;
            var locSubjID = SubjectsModel.getId(locIndex);
            subjectID.text = locSubjID;
            subjectName.text = SubjectsModel.getNameByID(locSubjID);


        }
    }
}
