import QtQml 2.0
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import "Views"
import org.qtproject.examples.calendar 1.0

ApplicationWindow {
    visible: true
    width: 480
    height: 640
    id: mainWindow
    title: qsTr("Hello World")

    SystemPalette {
        id: systemPalette
    }

    SqlEventModel {
        id: eventModel
    }



    TabView {
        anchors.fill: parent
        Tab {
            title: "Главная"


            Flow{
                id: row
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                layoutDirection: "RightToLeft"



                Calendar{
                    width: (parent.width > parent.height ? parent.width * 0.6 - parent.spacing : parent.width)
                    height: (parent.height > parent.width ? parent.height * 0.6 - parent.spacing : parent.height)
                    id: mainCalendar
                    focus: true
                    //При удалении данных из бд нужно как-то перерисовать календарь.
                    //Пока не получилось
                    Timer{
                        interval: 500
                        repeat: true
                        running: true
                        onTriggered: {
                            console.log("calendar update")
                            mainCalendar.update()
                        }
                    }


                    style: CalendarStyle{
                        //background: "black"//systemPalette.window
                        navigationBar:Rectangle{
                            height: 48
                            color: "#f7f7f7"

                            Rectangle{
                                color: "#d7d7d7"
                                height: 1
                                width: parent.width
                                anchors.bottom: parent.bottom
                            }

                            Button{
                                id: prevMon
                                width: parent.height - 8
                                height: width
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 8

                                onClicked: control.showPreviousMonth()

                                style: ButtonStyle{
                                    background: Rectangle{
                                        color: "#f7f7f7"
                                        Image{
                                            source: control.pressed ? "left_arrow_disable.png" : "left_arrow.png"
                                            width: parent.width - 8
                                            height: width
                                        }
                                    }
                                }
                            }

                            Label{
                                id: dateText
                                text: styleData.title
                                color: "#34aadc"
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: prevMon.right
                                anchors.leftMargin: 2
                                anchors.right: nextMon.left
                                anchors.rightMargin: 2
                            }

                            Button{
                                id: nextMon
                                width: parent.height - 8
                                height: width
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right

                                onClicked: control.showNextMonth()

                                style: ButtonStyle{
                                    background: Rectangle{
                                        color: "#f7f7f7"
                                        Image{
                                            source: control.pressed ? "right_arrow_disable.png" : "right_arrow.png"
                                            width: parent.height - 8
                                            height: width
                                        }
                                    }
                                }
                            }
                        }


                        dayDelegate: Item{
                            readonly property color sameMonthDateTextColor: "#444"
                            readonly property color selectedDateColor: "#34aadc"
                            readonly property color selectedDateTextColor: "white"
                            readonly property color differentMonthDateTextColor: "#bbb"
                            readonly property color invalidDateColor: "#dddddd"

                            Rectangle{
                                anchors.fill: parent
                                border.color: "transparent"
                                color: styleData.date !== undefined && styleData.selected ? selectedDateColor : "transparent"
                                anchors.margins: styleData.selected ? -1 : 0
                            }

                            Image {
                                visible: LessonsModel.lessonsList(styleData.date).length > 0//eventModel.eventsForDate(styleData.date).length > 0
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.margins: -1
                                width: 12
                                height: width
                                source: "Files/eventindicator.png"
                            }

                            Label{
                                id: dayDelegatetText
                                text: styleData.date.getDate()
                                anchors.centerIn: parent
                                color:{
                                    var color = invalidDateColor;
                                    if (styleData.valid){
                                        color = styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                                        if (styleData.selecte)
                                            color = selectedDateTextColor;
                                    }
                                    color;
                                }
                            }
                        }
                    }
                }

                Component {
                    id: eventListHeader

                    Row {
                        id: eventDateRow
                        width: parent.width
                        height: eventDayLabel.height
                        spacing: 10

                        Label {
                            id: eventDayLabel
                            text: mainCalendar.selectedDate.getDate()
                            font.pointSize: 35
                            color: "black"
                        }

                        Column {
                            height: eventDayLabel.height

                            Label {
                                readonly property var options: { weekday: "long" }
                                text: Qt.locale().standaloneDayName(mainCalendar.selectedDate.getDay(), Locale.LongFormat)
                                font.pointSize: 18
                                color: "black"
                            }
                            Label {
                                text: Qt.locale().standaloneMonthName(mainCalendar.selectedDate.getMonth()) + " "
                                              + mainCalendar.selectedDate.toLocaleDateString(Qt.locale(), "yyyy")
                                font.pointSize: 12
                                color: "black"
                            }
                        }

                    }

                }
                EditLesson{
                    id: lessonEditer;
                }
                Rectangle{
                    width: (parent.width > parent.height ? parent.width * 0.4 - parent.spacing : parent.width)
                    height: (parent.height > parent.width ? parent.height * 0.4 - parent.spacing : parent.height)
                    border.color: Qt.darker(color, 1.2)


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
                        model: LessonsModel.lessonsList(mainCalendar.selectedDate)//eventModel.eventsForDate(mainCalendar.selectedDate)
                        delegate: Rectangle{
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
                                    text: modelData.date.toLocaleTimeString(mainCalendar.locale, Locale.ShortFormat)//Date.fromLocaleString(Qt.locale(), model.startDate, "dd.MM.yyyy hh:mm").toLocaleTimeString(mainCalendar.locale, Locale.ShortFormat)
                                    color: "#aaa"
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
                                lessonEditer.create(mainCalendar.selectedDate);
                            }
                        }
                    }
                }
            }

        }
        Tab {
            title: "Люди"
            PersonsTableView {
                id: personsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Ученики"
            StudentsTableView{
                id: studentsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Предметы"
            SubjectsTableView{
                id: subjectsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Занятия"
            LessonsTableView{
                id: lessonsTable
                anchors.fill: parent
            }
        }
        Tab {
            title: "Посещения"
            VisitsTableView{
                id: visitsList
                anchors.fill: parent
            }
        }
//        Tab {
//            title: "Green"
//            Rectangle { color: "green" }
//        }
    }
}
