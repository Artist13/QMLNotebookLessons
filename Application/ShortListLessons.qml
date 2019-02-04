import QtQml 2.0
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "Views"



Rectangle{
    width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
    height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
    border.color: Qt.darker(color, 1.2)
    property var connectedCalendar;
    property var connectedModel;

    ListView{
        id: eventsListView
        spacing: 4
        clip: true
        header: eventListHeader
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        anchors.margins: 10
        model: connectedModel
        delegate: Rectangle{
            function removeLesson(){
                LessonsModel.removeById(lessonId);
            }

            property int lessonId: modelData.ID
            width: eventsListView.width
            height: eventItemColumn.height
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle{
                width: parent.width
                height: 1
                color: "#eee"
            }

            Column{
                id: eventItemColumn
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.right: parent.right

                height: timeLabel.height + nameLabel.height + 8

                Label{
                    id: nameLabel
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: modelData.name
                    color: "black"
                }

                Label{
                    id: timeLabel
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: modelData.date.toLocaleTimeString(connectedCalendar.locale, Locale.ShortFormat)//Date.fromLocaleString(Qt.locale(), model.startDate, "dd.MM.yyyy hh:mm").toLocaleTimeString(mainCalendar.locale, Locale.ShortFormat)
                    color: "#aaa"
                }
            }

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.RightButton | Qt.LeftButton
                onClicked: {
                    switch(mouse.button){
                    case Qt.RightButton:
                        lessonContextMenu.popup()
                        break
                    default:
                        break
                    }
                }
                onDoubleClicked: {
                    lessonEditer.editBylessonId(parent.lessonId);
                }
            }
        }
        Menu{
            id: lessonContextMenu

            MenuItem{
                text: qsTr("Удалить")
                onTriggered: {
                    dialogDelete.open()
                }
            }
        }

        MessageDialog{
            id: dialogDelete
            title: qsTr("Удалить занятие")
            text: qsTr("Подтверждение удаления")
            icon: StandardIcon.Warning
            standardButtons: StandardButton.Ok | StandardButton.Cancel

            onAccepted: {
                //LessonsModel.removeById(eventsListView.currentItem.childAt())
                eventsListView.currentItem.removeLesson();
                LessonsModel.updateModel()
            }
        }

    }
    Rectangle{
        id: footer
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 20
        height: 25

        Button{
            text: "+"
            anchors.right: parent.right
            width: 35
            Layout.fillHeight: true
            onClicked: {
                lessonEditer.create(connectedCalendar.selectedDate);
            }
        }
    }
    EditLesson{
        id: lessonEditer;
    }
}
