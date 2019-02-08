import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../Helpers"

//Тут два элемента. Таких объектов я еще не делал. Надо подумать над разметкой, чтоб была адаптивная
Item {
    id: mainObject
    function getVal(){
        return data.curObject;
    }

    function setVal(someObject){
        data.curObject = someObject;
        if(someObject.nameForList !== undefined){
            dataField.text = someObject.nameForList;
        }else{
            dataField.text = "";
        }

        changed();
    }

    QtObject{
        id: data
        property var curObject
    }
    property alias innerList : listElements

    signal changed()

    RowLayout{
        TextField{
            id: dataField
            readOnly: true
            Layout.preferredWidth: 200
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    dialogElements.open();
                }
            }
        }

        Button{
            id: chooseSubject
            Layout.preferredWidth: 90
            text: qsTr("Выбрать")

            onClicked: {
                dialogElements.open();
            }
        }
    }
    //Инициализируем список т.к. не знаю как использовать делегат

    Dialog{
        id: dialogElements
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return listElements.getChoosen();
        }
        //Нужно унифицировать. Вид общий разная только модель и бланк редактор.
        //В форме выбора бланк редактор можно опустить
        ListForChoosen{
            //var component = Qt.createComponent("EditStudent.qml");
            //var obj = component.createObject(parent);
            shownModel: mainObject.shownModel
            editBlank: mainObject.blank
            canAdd: mainObject.canAdd
            canEdit: mainObject.canEdit
            canRemove: mainObject.canRemove
            id: listElements
            anchors.fill: parent
//            Component.onCompleted: {
//                var component = Qt.createComponent("EditSubject.qml");
//                var obj = component.createObject(parent);
//                editBlank = obj;
//            }
            onSelected: {
                dialogElements.accept();
            }
        }
        //А это для чего??
        onVisibleChanged: {
            SubjectsModel.updateModel()
        }

        onAccepted: {
            mainObject.setVal(listElements.choosenElement);//SubjectsModel.getSubjectByID(locSubjID);
        }
    }


}
