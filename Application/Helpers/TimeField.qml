import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "../Helpers"

Item {
    id: element
    //Дублирование данных в из диалога
    property int hours
    property int minutes
    property var locTime: new Date();
    signal selected()
    function getVal(){
        return locTime;
    }
    function setVal(times){
        locTime = times;
        timepicker.setHours(locTime.getHours());
        timepicker.setMinutes(locTime.getMinutes());
        time.text = locTime.toLocaleTimeString(Qt.locale(), "hh:mm");
    }

    TextField{
        id: time
        anchors.fill: parent
        MouseArea{
                anchors.fill: parent
                onClicked: {
                    tp.show();
                    //dialogCalendar.show(locDate)
                }
            }
        }
        Dialog{
            id: tp
            width: 300
            height: 375
            TimePicker{
                id:timepicker
                anchors.fill: parent

            }
            function show(){
                timepicker.setHours(targetObject.date.getHours());
                timepicker.setMinutes(targetObject.date.getMinutes());
                tp.open();
            }

            onAccepted: {
                locTime.setHours(timepicker.hours);
                //hours = timepicker.hours;
                locTime.setMinutes(timepicker.minutes);
                //minutes = timepicker.minutes
                //targetObject.date = locDate;
                //console.log(targetObject.date.toString());
                time.text = locTime.toLocaleTimeString(Qt.locale(), "hh:mm");
                selected();
            }
        }


}
