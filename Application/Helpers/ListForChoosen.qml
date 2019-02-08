import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Item {
    property var shownModel
    visible: true
    function getChoosen(){
        return choosenElement;
    }

    property int choosenElement : 0

    RowLayout{
        id: row
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 5

        height: 35

        Button{
            id: addBut
            text: qsTr("Add")

            width: 150

            Layout.fillHeight: true

            onClicked: {
                var component = Qt.createComponent("EditStudent.qml");
                var obj = component.createObject(parent);
                obj.editEntry(-1)
            }
        }
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
                        choosenElement = index
                        break
                    }
                }

                onDoubleClicked: {
                    var component = Qt.createComponent("EditStudent.qml");
                    var obj = component.createObject(parent);
                    obj.editEntry(index)
                }

            }
        }
        highlight: Rectangle {color: "lightsteelblue"; radius: 5}

    }
}
