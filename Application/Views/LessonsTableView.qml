import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Item {
    visible: true

    function openLessonEditor(row){
        var component = Qt.createComponent("EditLesson.qml");
        var obj = component.createObject(parent);
        obj.editEntry(row);
    }

    RowLayout{
        id: topMenu

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
                openLessonEditor(-1)
            }
        }
    }

    TableView{
        id: tableView
        anchors.top: topMenu.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 5

        TableViewColumn{
            role: "id"
            title: "ID"
        }

        TableViewColumn{
            role: "lessonDate"
            title: "Дата"
            //width: parent.width / 4 - 3

        }

        TableViewColumn{
            role: "subjectName"
            title: "Предмет"
            //width: parent.width / 4 - 3
        }

        TableViewColumn{
            role: "long"
            title: "Длительность"
        }

        model: LessonsModel

        itemDelegate: Item {
            Text {
                anchors.verticalCenter: parent.verticalCenter
                color: "black";
                text: styleData.value
            }
        }

        rowDelegate: Rectangle{
            anchors.fill: parent
            color: styleData.selected ? "skyblue" : (styleData.alternate ? 'whitesmoke' : 'white');

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onClicked: {
                    tableView.selection.clear()
                    tableView.selection.select(styleData.row)
                    tableView.currentRow = styleData.row
                    tableView.focus = true

                    switch(mouse.button){
                    case Qt.RightButton:
                        lessonContextMenu.popup()
                        break
                    default:
                        break
                    }
                }

                onDoubleClicked: {
                    openLessonEditor(styleData.row)
                }

            }
        }

        Menu{
            id: lessonContextMenu

            MenuItem{
                text: qsTr("Delete")
                onTriggered: {
                    dialogDelete.open()
                }
            }
        }

        MessageDialog{
            id: dialogDelete
            title: qsTr("Delete record")
            text: qsTr("Confirm deleting from journal")
            icon: StandardIcon.Warning
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            onAccepted: {
                LessonsModel.remove(tableView.currentRow)
                LessonsModel.updateModel()
            }
        }
    }
}
