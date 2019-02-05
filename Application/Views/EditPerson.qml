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
    //var locDate;
    function editEntry(row)
    {
        targetIndex = row
        if(row === -1){
            isNew = true;
            nameBl = "New person"
            PersonMapper.newData();
        }
        else{
            isNew = false;
            console.log(targetIndex)
            nameBl = "Edit person"
            PersonMapper.updateData(row)
            //Не правильно получает данные
        }
        open()
    }

    contentItem: Rectangle{
        readonly property color baseTextColor: "white"
        readonly property color baseBGColor: "#2e2f30"
        readonly property int fontSize: 16
        color: baseBGColor
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

            BaseText {
                text: qsTr("Second name")
                Layout.fillWidth: true
            }

            TextField{
                id: secondNameField
                Layout.preferredWidth: 300
            }

            BaseText {
                text: qsTr("Name")
                Layout.fillWidth: true
            }

            TextField{
                id: nameField
                Layout.preferredWidth: 300
            }

            BaseText{
                text: qsTr("Third name")
                Layout.fillWidth: true
            }

            TextField{
                id: thirdNameField
                Layout.preferredWidth: 300
            }

            BaseText{
                text: qsTr("Birth day")
                Layout.fillWidth: true
            }

            TextField{
                id: birthField
                Layout.preferredWidth: 300
            }

            BaseText{
                text: qsTr("Телефон")
                Layout.fillWidth: true
            }

            TextField{
                id: phoneField
                Layout.preferredWidth: 300
            }
        }

        Rectangle{
            color: parent.baseBGColor
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
            PersonMapper.addMapping(nameField, (0x100 +2), "text")
            PersonMapper.addMapping(secondNameField, (0x100 + 3), "text")
            PersonMapper.addMapping(thirdNameField, (0x100 + 4), "text")
            PersonMapper.addMapping(birthField, (0x100 + 5), "text")
            PersonMapper.addMapping(phoneField, (0x100 + 6), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента
    function save()
    {
        //database.insertIntoTable(nameField.text, secondNameField.text, thirdNameField.text, phoneField.text, birthField.text);
        PersonsModel.add(nameField.text, secondNameField.text, thirdNameField.text, birthField.text, phoneField.text);
        PersonsModel.updateModel()
    }
    function updateElement(_index){
        PersonsModel.updateElement(targetIndex, nameField.text, secondNameField.text, thirdNameField.text, birthField.text, phoneField.text)
        PersonsModel.updateModel()
    }
}
