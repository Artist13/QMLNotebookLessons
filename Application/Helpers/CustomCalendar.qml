import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import MyStatesEnum 1.0

Item {
    function getDate(){
        return internalcalendar.selectedDate;
    }

    function setDate(someDate){
        internalcalendar.selectedDate = someDate;
    }

    Calendar{
        id: internalcalendar

        anchors.fill: parent

        style: CalendarStyle{
            readonly property color sameMonthDateTextColor: "#444"
            readonly property color selectedDateColor: "#34aadc"
            readonly property color selectedDateTextColor: "white"
            readonly property color differentMonthDateTextColor: "#bbb"
            readonly property color invalidDateColor: "#dddddd"
            function compareDates(date1, date2){
                return (date1.getDate() == date2.getDate() && date1.getMonth() == date2.getMonth() && date1.getFullYear() == date2.getFullYear());
            }
            function getDateStyle(state){
                switch(state){
//                case DateStyle.BookedDate:
//                    return "yellow";
//                case DateStyle.SaleDate:
//                    return "red";
//                case DateStyle.ClearDate:
//                    return "transparent";
                default:
                    return "transparent";
                }
            }

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



            dayDelegate: Rectangle{
                function getTextStyle(state){
                    switch(state){
//                    case DateStyle.ClearDate:
//                    case DateStyle.BookedDate:
//                    case DateStyle.SaleDate:
//                        return styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;
                    default:
                        return styleData.visibleMonth ? sameMonthDateTextColor : differentMonthDateTextColor;;
                    }
                }

                anchors.fill: parent
                anchors.margins: styleData.selected ? -1 : 0

                property int state: 0;//DatesModel.getStateByDate(styleData.date)
                property bool showPopUpMenu: false
                color: {
                    var background = getDateStyle(state)
                    if (styleData.date !== undefined )
                    {
                       if (styleData.selected)
                       {
                          background = selectedDateColor
                       }
                    }
                    return background
                }

                Label{
                    id: dayDelegateText
                    text: styleData.date.getDate()
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 10

                    color:{
                        var theColor = invalidDateColor;
                        if (styleData.valid)
                        {
                            theColor = getTextStyle(parent.state);
                            if (styleData.selected)
                            {
                                theColor = selectedDateTextColor;
                            }

                            theColor;
                        }
                    }
                }
            }
        }

    }
}
