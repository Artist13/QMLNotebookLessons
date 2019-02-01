import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import "../Helpers"
//import "MyTypes.Lesson"

Dialog{
    id: topElement
    title: nameBl
    height: 440
    width: 480

    property bool isNew: false
    property string nameBl: "Edit"
    property int targetIndex : -1
    property var targetObject;
    property var locDate;//Дублирует данные из модели занятия //Пока не обрабатываются моменты когда объек = undefined

    function create(targetDate){
        isNew = true;
        nameBl = "Добавить занятие"
        locDate = targetDate;
        LessonMapper.newData();
        date.text = locDate.toLocaleDateString(Qt.locale(), "dd.MM.yyyy");
        time.text = locDate.toLocaleTimeString(Qt.locale(), "hh:mm");
        open()
    }
    //Очищаются ли поля
    //Нужно проработать mapper для использования с объектами, а не таблицами
    function editBylessonId(id){
        targetIndex = id;
        targetObject = LessonsModel.getLessonByID(id);
        if(id == -1){
            isNew = true;
            nameBl = "New lesson"
            locDate = new Date();
            subjectID.text = -1;
            LessonMapper.newData();
        }else{
            isNew = false;
            nameBl = "Edit lesson"
            locDate = targetObject.date;
            //Идет обращение к свойству
            //subjectName.text = SubjectsModel.getNameByID(subjectID.text);
            if(targetObject.subject !== null){
                subjectID.text = targetObject.subject.ID;
                subjectName.text = targetObject.subject.name;
            }
            longs.currentIndex = longs.find(targetObject.longs.toString());
        }
        date.text = locDate.toLocaleString(Qt.locale(), "dd.MM.yyyy");
        time.setVal(locDate);
        open()
    }
    function formateTime(hours, minutes){
        return addZeros(hours) + ":" + addZeros(minutes);
    }
    function addZeros(val){
        val = val + "";
        while(val.length < 2){
            val = "0" + val;
        }
        return val;
    }

    //Изначально работа велась с моделью, в которой известен номер строки
    //По  нему и происходила индексация объектов
    //Он доступен в модели
    //Для реализации работы с id и ухода от привязки к конкретной модели добавил новые методы и перебросил вызовы в них
    function editEntry(row)
    {
        targetIndex = row
        if(row === -1){
            editBylessonId(-1);
            //visiters.openWithFilter(-1)
        }
        else{
            editBylessonId(LessonsModel.getId(row));
        }

        //open()
    }

    contentItem: Rectangle{
        id: form
        implicitHeight: 220
        implicitWidth: 480

        readonly property color baseTextColor: "white"
        readonly property color baseBGColor: "#2e2f30"
        readonly property int fontSize: 16
        color: baseBGColor

        property var tempDate: new Date();
        GridLayout{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 5

            rowSpacing: 10
            columnSpacing: 10
            rows: 7
            columns: 3

            BaseText {
                id: dateLabel
                text: qsTr("Дата")
                Layout.fillWidth: true
            }

            TextField{
                id: date
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        dialogCalendar.show(locDate)
                    }
                }
            }
            BaseText {
                id: timeLabel
                text: qsTr("Время")
                Layout.fillWidth: true
            }
            TimeField{
                id:time
                Layout.columnSpan: 2
                height: 30
                //Layout.fillHeight: true
                Layout.preferredWidth: 300
                onSelected: {
                   var tempVal = getVal();
                   locDate.setHours(tempVal.getHours());
                   locDate.setMinutes(tempVal.getMinutes());
                }
            }

//            BaseText {
//                id: timeLabel
//                text: qsTr("Время")
//                Layout.fillWidth: true
//            }

//            TextField{
//                id: time
//                Layout.columnSpan: 2
//                Layout.preferredWidth: 300
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: {
//                        tp.show();
//                        //dialogCalendar.show(locDate)
//                    }
//                }
//            }
//            Dialog{
//                id: tp
//                width: 300
//                height: 375
//                TimePicker{
//                    id:timepicker
//                    anchors.fill: parent

//                }
//                function show(){
//                    timepicker.setHours(targetObject.date.getHours());
//                    timepicker.setMinutes(targetObject.date.getMinutes());
//                    tp.open();
//                }

//                onAccepted: {
//                    locDate.setHours(timepicker.hours);
//                    locDate.setMinutes(timepicker.minutes);
//                    //targetObject.date = locDate;
//                    //console.log(targetObject.date.toString());
//                    time.text = locDate.toLocaleTimeString(Qt.locale(), "hh:mm");
//                }
//            }

            BaseText {
                text: qsTr("Предмет")
                Layout.fillWidth: true
            }

            TextField{
                id: subjectID
                visible: false
                Layout.preferredWidth: 300
                Layout.columnSpan: 2

            }

            TextField{
                id: subjectName
                readOnly: true
                Layout.preferredWidth: 200
            }

            Button{
                id: chooseSubject
                Layout.preferredWidth: 90
                text: qsTr("Выбрать")

                onClicked: {
                    listSubjectsForChoose.open();
                }
            }

            BaseText{
                text: qsTr("Длительность")
                Layout.fillWidth: true
            }

            ComboBox{
                id: longs
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
                model: [0.5, 1, 1.5]
                onActivated: {
                    targetObject.longs = currentText;
                }
            }
        }

        Rectangle{
            id: bottomButtons
            color: form.baseBGColor
            height: 40
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right

            Button{
                anchors.right: buttonCancel.left
                anchors.margins: 5
                id: buttonOk
                text: qsTr("Ok")
                width: 80
                onClicked: {
                    if(isNew){
                        save()
                    }else
                    {
                        simpleSave();
                    }
                    close()
                }
            }

            Button{
                anchors.right: parent.right
                anchors.margins: 5
                id: buttonCancel
                text: qsTr("Cancel")
                width: 80
                onClicked: {
                    close()
                }
            }
        }


        Component.onCompleted: {
            //LessonMapper.addMapping(date, (0x100 + 2), "text")
            //LessonMapper.addMapping(subjectID, (0x100 + 3), "text")
            //LessonMapper.addMapping(longs, (0x100 + 4), "text")
        }
    }
    //Эта ветвь при добавлении нового элемента

    function simpleSave(){
        targetObject.date = locDate;
        targetObject.save();
    }

    function save()
    {
        console.log("save new lesson");
        LessonsModel.add(date.text + " " + time.text, subjectID.text, longs.text)
        LessonsModel.updateModel()
    }

    Dialog{
        id: listSubjectsForChoose
        width: 480
        height: 640
        modality: Qt.ApplicationModal
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        function getChoosen(){
            return listSubjects.getChoosen();
        }

        SubjectListView{
            id: listSubjects
            anchors.fill: parent
        }

        onVisibleChanged: {
            SubjectsModel.updateModel()
        }

        onAccepted: {
            var locIndex = listSubjects.choosenElement;
            var locSubjID = SubjectsModel.getId(locIndex);
            targetObject.subject = SubjectsModel.getSubjectByID(locSubjID);
            subjectID.text = locSubjID;
            subjectName.text = SubjectsModel.getNameByID(locSubjID);
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
                            date.text = Qt.formatDate(locDate, "dd.MM.yyyy");
                            dialogCalendar.close();
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

