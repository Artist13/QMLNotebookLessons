import QtQml 2.0
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1
import "Views"

Item{



    Flow{
        id: row
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20
        layoutDirection: "RightToLeft"



        Calendar{
            property var locModel;
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
                    //console.log("calendar update")
                    //mainCalendar.update()
                    //mainCalendar.locModel =
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
        ShortListLessons{
            id:shortList
            connectedCalendar: mainCalendar
            connectedModel: LessonsModel.lessonsList(shortList.connectedCalendar.selectedDate)
            //Обновляет список каждые 500мс
            Timer{
                interval: 500
                repeat: true
                running: true
                onTriggered: {
                    //console.log("calendar update")
                    //Костыль для обновления календаря
                    mainCalendar.showNextMonth();
                    mainCalendar.showPreviousMonth();
                    var tempModel = LessonsModel.lessonsList(shortList.connectedCalendar.selectedDate);
                    //Будут ошибки, если длинна не изменится, а содержимое да нужно проверять на стороне C++
                    if(tempModel.length != shortList.connectedModel.length)
                        shortList.connectedModel = tempModel;
                }
            }
        }
    }
}
