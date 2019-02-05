import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1

Item {
    property var locDate: new Date()
    signal selected()
    function getVal(){
        return locDate;
    }

    function setVal(date){
        locDate = date;
    }

    TextField{
        anchors.fill: parent
        id: date
        //Layout.columnSpan: 2
        //Layout.preferredWidth: 300
        MouseArea{
            anchors.fill: parent
            onClicked: {
                dialogCalendar.show(locDate)
            }
        }
    }
    Dialog{
        id: dialogCalendar

        width: 250
        height: 300

        contentItem: Rectangle{
            id: dialogRect
            color: "#f7f7f7"

            CustomCalendar{
                id: calendar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: row.top
            }

            Row{
                    id: row
                    height: 48
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    Button{
                        id: dialogButtonCancel

                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        width: parent.width / 2 - 1

                        style: ButtonStyle{
                            background: Rectangle{
                                color: control.pressed ? "#d7d7d7" : "#f7f7f7"
                                border.width: 0
                            }

                            label: Text {
                                text: qsTr("Cancel")
                                font.pixelSize: 14
                                color: "#34aadc"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        onClicked: dialogCalendar.close()

                    }

                    Rectangle{
                        id: dividerVertical
                        width: 2
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        color: "#d7d7d7"
                    }

                    Button{
                        id: dialogButtonOk
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        width: parent.width / 2 - 1

                        style: ButtonStyle{
                            background: Rectangle{
                                color: control.pressed ? "#d7d7d7" : "#f7f7f7"
                                border.width: 0
                            }

                            label: Text {
                                text: qsTr("Ok")
                                font.pixelSize: 14
                                color: "#34aadc"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        onClicked: {
                            var tempDate = calendar.getDate();
                            tempDate.setHours(locDate.getHours());
                            tempDate.setMinutes(locDate.getMinutes());
                            locDate = tempDate;
                            //targetObject.date = locDate;
                            console.log(tempDate);
                            date.text = Qt.formatDate(locDate, "dd.MM.yyyy");
                            dialogCalendar.close();
                            selected();
                        }
                    }
                }

        }
        function show(x){
            calendar.setDate(x)
            dialogCalendar.open()
        }
    }
}