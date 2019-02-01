import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.1

//Рукодельная реализация timepickera
//Нужно сделать хорошую разметку и дизайн
Rectangle {
    function setHours(_hours){
        hours = _hours;
        console.log(hours);
    }

    function setMinutes(_minutes){
        minutes = _minutes;
        console.log(minutes)
    }

    function timeToString(){
        return addZeros(hours) + ":" + addZeros(minutes);
    }

    id: timepicker
    function addZeros(val){
        val = val + "";
        while(val.length < 2){
            val = "0" + val;
        }
        return val;
    }

    function minutesUp(){
        minutes = minutes + 15;
        if(minutes > 45){
            hoursUp();
            minutes = 0;
        }
    }

    function minutesDown(){
        minutes = minutes - 15;
        if(minutes < 0){
            hoursDown();
            minutes = minutes + 60;
        }
    }

    function hoursUp(){
        hours = hours + 1;
        if(hours > 23){
            hours = 0;
        }
    }

    function hoursDown(){
        hours = hours - 1;
        if(hours < 0){
            hours = hours + 24;
        }
    }


    property int hours: 12
    property int minutes: 0

    RowLayout{
        id: headRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            color: "green"
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    hoursUp();
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            color: "red"
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    minutesUp();
                }
            }
        }
    }
    RowLayout{
        id: mainRow
        anchors.top: headRow.bottom
        anchors.bottom: bottomRow.top
        anchors.left: parent.left
        anchors.right: parent.right
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            Text{
                font.pointSize: 24
                anchors.centerIn: parent
                text: addZeros(hours)
            }
            color: "blue"
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            Text{
                font.pointSize: 24
                anchors.centerIn: parent
                text: addZeros(minutes)
            }
            color: "yellow"
        }
    }
    RowLayout{
        id: bottomRow
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 100

        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            color: "green"
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    hoursDown();
                }
            }
        }


        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: 100
            color: "red"
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    minutesDown();
                }
            }
        }


    }




}
