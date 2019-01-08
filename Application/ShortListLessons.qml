import QtQml 2.0
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
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

                onClicked: {
                    lessonEditer.editBylessonId(parent.lessonId);
                }
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
