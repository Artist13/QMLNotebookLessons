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
            nameBl = "New subject"
            SubjectMapper.newData();
        }
        else{
            isNew = false;
            //console.log(targetIndex)
            nameBl = "Edit subject"
            SubjectMapper.updateData(row)
            subjectName
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
            columns: 2

            Text {
                text: qsTr("Name")
                Layout.fillWidth: true
            }

            TextField{
                id: subjectName
                Layout.preferredWidth: 200
            }


            Text {
                text: qsTr("Class Number")
                Layout.fillWidth: true
            }

            /*ComboBox{
                id: classNum
                Layout.preferredWidth: 200
                model: ClassNumbers
            }*/
            TextField{
                id: classNum
                Layout.preferredWidth: 200
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
                        SubjectMapper.toPrevious()
                    }
                }

                Button{
                    id: buttonNext
                    text: qsTr("Next")
                    Layout.preferredWidth: 80

                    onClicked: {
                        SubjectMapper.toNext()
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
                        console.log(targetIndex);
                        SubjectMapper.updateData(targetIndex)
                    }
                }
            }
        }


        Component.onCompleted: {

            SubjectMapper.addMapping(subjectName, (0x100 + 2), "text")
            SubjectMapper.addMapping(classNum, (0x100 + 3), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента
    function save()
    {
        console.log("save new");
        //database.insertIntoTable(nameField.text, secondNameField.text, thirdNameField.text, phoneField.text, birthField.text);
        SubjectsModel.add(subjectName.text, classNum.text)
        SubjectsModel.updateModel()
    }
    function updateElement(_index){
        console.log("save old")
        SubjectsModel.updateElement(targetIndex, subjectName.text, classNum.text)
        SubjectsModel.updateModel()
    }
}
