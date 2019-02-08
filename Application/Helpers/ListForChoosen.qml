import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

//Общий список для моделей объектов CustomRecord
//shownModel - отображаемая модель
//editBlank - бланк редактор для этих объектов

//Необходимо реализовать
//Возможности для редактирования и добавления должны быть доступны в соответствии с установленными флагами

Item {
    //not in use
    property bool canAdd : false
    property bool canEdit: false
    property bool canRemove: false
    //--------------

    property var shownModel
    property var editBlank
    visible: true
    function getChoosen(){
        return choosenElement;
    }

    property var choosenElement

    RowLayout{
        id: row
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        height: 35
        //Это бланк только для выбора тут добавлять не надо. Вовсяком случае пока
//        Button{
//            id: addBut
//            text: qsTr("Add")

//            width: 150

//            Layout.fillHeight: true

//            onClicked: {
//                var component = Qt.createComponent("EditStudent.qml");
//                var obj = component.createObject(parent);
//                obj.editEntry(-1)
//            }
//        }
    }

    Component{
        id: personDelegate
        Rectangle{
            anchors.fill: parent
            height: 20
            color: ListView.isCurrentItem ? "skyblue" : "white"

        }
    }

    ListView{
        id: listView
        anchors.top: row.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        anchors.margins: 5

        model: shownModel.getObjectsModel()

        delegate: Rectangle{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5
            color: ListView.isCurrentItem ? "skyblue" : "white"
            height: 20
            Text{
                anchors.fill: parent
                //color: "blue"
                id: someText
                //Объекты представленные в этом списке должны реализовывать CustomRecord
                text: qsTr(modelData.nameForList)
                verticalAlignment: Text.AlignVCenter
                //horizontalAlignment: Text.AlignHCenter
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onClicked: {

                    switch(mouse.button){
                    case Qt.RightButton:
                        //contextMenu.popup()
                        break
                    default:
                        listView.currentIndex = index
                        choosenElement = listView.model[index]
                        break
                    }
                }
                //Нужно передавать бланк редактор
                //Должен получаться через какую-либо зависимость
                //Например свойство
                onDoubleClicked: {
                    editBlank.editEntry(index)
                }

            }
        }
        Component.onCompleted: {
            choosenElement = listView.model[listView.currentIndex];
        }

        highlight: Rectangle {color: "lightsteelblue"; radius: 5}

    }
}
