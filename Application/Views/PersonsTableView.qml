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
                var component = Qt.createComponent("EditPerson.qml");
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
            role: "secondName"
            title: "Second name"
            //width: parent.width / 4 - 3

        }

        TableViewColumn{
            role: "name"
            title: "Name"
            //width: parent.width / 4 - 3
        }

        TableViewColumn{
            role: "thirdName"
            title: "Third name"
            //width: parent.width / 4 - 3
        }

        TableViewColumn{
            role: "birthDay"
            title: "Birth day"
            //width: parent.width / 4 - 3
        }

        TableViewColumn{
            role: "phone"
            title: "Телефон"
            //width: parent.width / 4 - 3
        }

        model: PersonsModel

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
                        personsContextMenu.popup()
                        break
                    default:
                        break
                    }
                }

                onDoubleClicked: {
                    var component = Qt.createComponent("EditPerson.qml");
                    var obj = component.createObject(parent);
                    obj.editEntry(styleData.row);
                }

            }
        }

        Menu{
            id: personsContextMenu

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
                PersonsModel.remove(tableView.currentRow)
                PersonsModel.updateModel()
            }
        }
    }


}
