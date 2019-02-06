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
    QtObject{
        id: data
        property var person: Object.create(null)
    }

    function setDefaulValue(){
        secondNameField.text = "";
        nameField.text = "";
        thirdNameField.text = "";

    }

    function setDefaultBirth(){
        var tempDate = new Date();
        tempDate.setHours(0);
        tempDate.setMinutes(0);
        tempDate.setSeconds(0);
        data.person.birth = tempDate;
        birthField.setVal(data.person.birth);
    }

    function editPersonById(id){
        setDefaulValue();
        //targetIndex = id;
        data.person = Object.create(PersonsModel.getByID(id));
        if(id == -1){
            isNew = true;
            nameBl = "New person"
            data.person = PersonsModel.newPerson();
        }else{
            data.person = Object.create(PersonsModel.getByID(id));
            isNew = false;
            nameBl = "Edit person";
            secondNameField.text = data.person.secondName;
            nameField.text = data.person.name;
            thirdNameField.text = data.person.thirdName;
            phoneField.text = data.person.phone;
            if(isNaN(data.person.birth) == false){
                birthField.setVal(data.person.birth);
            }
        }
        open()
    }

    //var locDate;
    function editEntry(row)
    {
        targetIndex = row
        if(row === -1){
            editPersonById(-1);
        }
        else{
            editPersonById(PersonsModel.getId(row));
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
                onTextChanged: {
                    data.person.secondName = text;
                }
            }

            BaseText {
                text: qsTr("Name")
                Layout.fillWidth: true
            }

            TextField{
                id: nameField
                Layout.preferredWidth: 300
                onTextChanged: {
                    data.person.name = text;
                }
            }

            BaseText{
                text: qsTr("Third name")
                Layout.fillWidth: true
            }

            TextField{
                id: thirdNameField
                Layout.preferredWidth: 300
                onTextChanged: {
                    data.person.thirdName = text;
                }
            }

            BaseText{
                text: qsTr("Birth day")
                Layout.fillWidth: true
            }
            DateField{
                id: birthField
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                onSelected: {
                    var tempDate = getVal();
                    data.person.birth = tempDate;
                }
            }

            BaseText{
                text: qsTr("Телефон")
                Layout.fillWidth: true
            }

            TextField{
                id: phoneField
                Layout.preferredWidth: 300
                onTextChanged: {
                    data.person.phone = text;
                }
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
                        savePerson();
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
    }

    function savePerson(){
        data.person.save();
    }
}
