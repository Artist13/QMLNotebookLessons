import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import "../Helpers"

Dialog{
    id: topElement
    title: nameBl
    height: 440
    width: 480

    property bool isNew: false
    property string nameBl: "Edit"
    property int targetIndex : -1
    property var targetObject
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
        readonly property color baseTextColor: "white"
        readonly property color baseBGColor: "#2e2f30"
        readonly property int fontSize: 16
        implicitHeight: 220
        implicitWidth: 480
        color: baseBGColor

        GridLayout{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            rowSpacing: 10
            columnSpacing: 10
            rows: 4
            columns: 2

            BaseText {
                text: qsTr("Название")
                Layout.fillWidth: true
            }

            TextField{
                id: subjectName
                Layout.preferredWidth: 300
            }


            BaseText {
                text: qsTr("Класс")
                Layout.fillWidth: true
            }

            /*ComboBox{
                id: classNum
                Layout.preferredWidth: 200
                model: ClassNumbers
            }*/
            TextField{
                id: classNum
                Layout.preferredWidth: 300
            }

        }

        Rectangle{
            color: parent.baseBGColor
            height: 50
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Button{
                anchors.right: buttonCancel.left
                anchors.margins: 5
                id: buttonOk
                text: qsTr("Ok")
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
                anchors.right: parent.right
                anchors.margins: 5
                id: buttonCancel
                text: qsTr("Cancel")
                onClicked: {
                    close()
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
