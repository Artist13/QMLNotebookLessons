import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Item {
    id: appWindow
    visible: true
    property int lessonId: -1
    function getChoosen(){
        return choosenElement;
    }

    function openWithFilter(lessonId){
        VisitsModel.filterByLesson(lessonId)
    }
    function openVisitEditor(row){
        var component = Qt.createComponent("EditVisit.qml");
        var obj = component.createObject(parent);
        obj.editEntry(row, lessonId)
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
                openVisitEditor(-1)
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

        model: VisitsModel

        delegate: Rectangle{
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5
            color: ListView.isCurrentItem ? "skyblue" : "white"
            height: 20
            Text{
                anchors.fill: parent
                id: someText
                text: VisitsModel.getStringView(index)
                verticalAlignment: Text.AlignVCenter
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onClicked: {

                    switch(mouse.button){
                    case Qt.RightButton:
                        contextMenu.popup()
                        break
                    default:
                        listView.currentIndex = index
                        choosenElement = index
                        break
                    }
                }

                onDoubleClicked: {
                    openVisitEditor(index)
                    VisitsModel.updateModel("");
                }

            }
            Button{
                width: 100
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right

                text: qsTr("Delete")
                onClicked:{
                    VisitsModel.remove(index)
                    VisitsModel.updateModel("")
                }
            }
        }

        Menu{
            id: subjectContextMenu

            MenuItem{
                text: qsTr("Delete")
                onTriggered: {
                    dialogDelete.open()
                }
            }
        }
        highlight: Rectangle {color: "lightsteelblue"; radius: 5}
    }
}
