import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2

Item {
    visible: true


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
                var component = Qt.createComponent("EditStudent.qml");
                var obj = component.createObject(parent);
                obj.editEntry(-1)
            }
        }

        Button{
            id: closeTable
            text: qsTr("Close")
            width: 150
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignRight

            onClicked: {
                mainFrame.sourceComponent = defaultElement
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
            role: "ID"
            title: "ID"
        }

        TableViewColumn{
            role: "person"
            title: "Person ID"
        }

        TableViewColumn{
            role: "personName"
            title: "Person"
        }

        TableViewColumn{
            role: "classNum"
            title: "Class"
        }

        TableViewColumn{
            role: "subjectName"
            title: "Subject"
        }

        model: StudentsModel

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
                        studentsContextMenu.popup()
                        break
                    default:
                        break
                    }
                }

                onDoubleClicked: {
                    var component = Qt.createComponent("EditStudent.qml");
                    var obj = component.createObject(parent);
                    obj.editEntry(styleData.row)
                }

            }
        }

        Menu{
            id: studentsContextMenu

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
                StudentsModel.remove(tableView.currentRow);
                StudentsModel.updateModel()
            }
        }
    }
}
