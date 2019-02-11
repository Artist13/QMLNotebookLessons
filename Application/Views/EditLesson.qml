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

    QtObject{
        id: data;
        property int targetIndex : -1
        property var targetObject;
        property var locDate;//Дублирует данные из модели занятия //Пока не обрабатываются моменты когда объек = undefined
        property var locTime;
    }

    property bool isNew: false
    property string nameBl: "Edit"

    function create(targetDate){
        isNew = true;
        nameBl = "Добавить занятие";
        setDefaulValue();
        data.locDate = targetDate;
        date.setVal(data.locDate);
        data.targetObject = LessonsModel.newLesson();
        editBylessonId(-1);
    }

    function setDefaulValue(){
        setDefaultTime();
        setDefaultDate();
        setEmptySubject();
        //data.targetObject = Object.create(null);
    }

    function setDefaultDate(){
        data.locDate = new Date();
        date.setVal(data.locDate);
    }

    function setDefaultTime(){
        data.locTime = new Date();
        data.locTime.setHours(12);
        data.locTime.setMinutes(0);
        time.setVal(data.locTime);
    }

    function setEmptySubject(){
        //data.locSubject = Object.create(null);
        subject.setVal(Object.create(null));
        //subjectID.text = "";
        //subjectName.text = "";
    }

    function mergeDateAndTime(){
        var tempDate = data.locDate;
        tempDate.setHours(data.locTime.getHours());
        tempDate.setMinutes(data.locTime.getMinutes());
        return tempDate;
    }

    //Очищаются ли поля
    //Нужно проработать mapper для использования с объектами, а не таблицами
    function editBylessonId(id){
        setDefaulValue();
        data.targetIndex = id;
        //data.targetObject = Object.create(LessonsModel.getLessonByID(id));
        if(id == -1){
            isNew = true;
            nameBl = "New lesson";
            data.targetObject = LessonsModel.newLesson();
        }else{
            isNew = false;
            nameBl = "Edit lesson"
            data.targetObject = Object.create(LessonsModel.getLessonByID(id));
            if(isNaN(data.targetObject.date) == false){
                data.locDate = data.targetObject.date;
                data.locTime = new Date;
                data.locTime.setHours(data.locDate.getHours());
                data.locTime.setMinutes(data.locDate.getMinutes());
            }
            if(data.targetObject.subject !== null){
                //data.locSubject = data.targetObject.subject;
                subject.setVal(data.targetObject.subject);
            }
            longs.currentIndex = longs.find(data.targetObject.longs.toString());
            date.setVal(data.locDate);
            time.setVal(data.locTime);
        }
        open();
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
        }
        else{
            editBylessonId(LessonsModel.getId(row));
        }
    }

    contentItem: Rectangle{
        id: form
        implicitHeight: 220
        implicitWidth: 480

        readonly property color baseTextColor: "white"
        readonly property color baseBGColor: "#2e2f30"
        readonly property int fontSize: 16
        color: baseBGColor

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

            DateField{
                id: date
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                onSelected: {
                    data.locDate = getVal();
                    data.targetObject.date = mergeDateAndTime();
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
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                onSelected: {
                   var tempVal = getVal();
                   data.locTime.setHours(tempVal.getHours());
                   data.locTime.setMinutes(tempVal.getMinutes());
                   data.targetObject.date = mergeDateAndTime();
                }
            }

            BaseText {
                text: qsTr("Предмет")
                Layout.fillWidth: true
            }

            ChoosenField{
                id: subject
                innerList{
                    shownModel: SubjectsModel
                }
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                onChanged: {
                    console.log(getVal());
                    console.log(data.targetObject);
                    var tempSubj = getVal();
                    data.targetObject.subject = tempSubj;
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
                    data.targetObject.longs = currentText;
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
                    save();
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
    //При сохранении локальные переменные переносятся в объект
    //Можно использовать сам объект для хранения локальных данных, но структура не совсем совпадает
    function save(){
        //console.log(locSubject.ID);
        //data.targetObject.date = mergeDateAndTime();
        //data.targetObject.longs = longs.currentText;
        //data.targetObject.subject = data.locSubject;
        data.targetObject.save();
        LessonsModel.updateModel();
    }
}

