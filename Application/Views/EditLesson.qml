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
    property var locSubject;
    property var locDate;//Дублирует данные из модели занятия //Пока не обрабатываются моменты когда объек = undefined
    property var locTime;

    function create(targetDate){
        isNew = true;
        nameBl = "Добавить занятие";
        setDefaulValue();
        locDate = targetDate;
        date.setVal(locDate);
        open()
    }

    function setDefaulValue(){
        setDefaultTime();
        setDefaultDate();
        setEmptySubject();
        targetObject = Object.create(null);
    }

    function setDefaultDate(){
        locDate = new Date();
        date.setVal(locDate);
    }

    function setDefaultTime(){
        locTime = new Date();
        locTime.setHours(12);
        locTime.setMinutes(0);
        time.setVal(locTime);
    }

    function setEmptySubject(){
        locSubject = Object.create(null);
        subject.setVal(locSubject);
        //subjectID.text = "";
        //subjectName.text = "";
    }

    function mergeDateAndTime(){
        var tempDate = locDate;
        tempDate.setHours(locTime.getHours());
        tempDate.setMinutes(locTime.getMinutes());
        return tempDate;
    }

    //Очищаются ли поля
    //Нужно проработать mapper для использования с объектами, а не таблицами
    function editBylessonId(id){
        setDefaulValue();
        targetIndex = id;
        targetObject = Object.create(LessonsModel.getLessonByID(id));
        if(id == -1){
            isNew = true;
            nameBl = "New lesson"
        }else{
            isNew = false;
            nameBl = "Edit lesson"
            if(isNaN(targetObject.date) == false){
                locDate = targetObject.date
                locTime = new Date;
                locTime.setHours(locDate.getHours());
                locTime.setMinutes(locDate.getMinutes());
            }
            if(targetObject.subject !== null){
                locSubject = targetObject.subject;
                //subjectID.text = targetObject.subject.ID;
                //subjectName.text = targetObject.subject.getFullName();
                subject.setVal(targetObject.subject);
            }
            longs.currentIndex = longs.find(targetObject.longs.toString());
            date.setVal(locDate);
            time.setVal(locTime);
        }
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


            DateField{
                id: date
                Layout.columnSpan: 2
                Layout.preferredWidth: 300
                Layout.fillHeight: true
                onSelected: {
                    locDate = getVal();
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
                   locTime.setHours(tempVal.getHours());
                   locTime.setMinutes(tempVal.getMinutes());
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
                    var tempVal = getVal();
                    locSubject = tempVal;
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
    //При сохранении локальные переменные переносятся в объект
    //Можно использовать сам объект для хранения локальных данных, но структура не совсем совпадает
    function simpleSave(){
        console.log(locSubject.ID);
        targetObject.date = mergeDateAndTime();
        targetObject.longs = longs.currentText;
        targetObject.subject = locSubject;
        targetObject.save();
    }

    function save()
    {
        console.log("save new lesson");
        LessonsModel.add(locDate.toLocaleString(Qt.locale(), "dd.MM.yyyy hh:mm"), subjectID.text, longs.text)
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
        //Нужно унифицировать. Вид общий разная только модель и бланк редактор.
        //В форме выбора бланк редактор можно опустить
        ListForChoosen{
            //var component = Qt.createComponent("EditStudent.qml");
            //var obj = component.createObject(parent);
            shownModel: SubjectsModel
            id: listSubjects
            anchors.fill: parent
            Component.onCompleted: {
                var component = Qt.createComponent("EditSubject.qml");
                var obj = component.createObject(parent);
                editBlank = obj;
            }
            onSelected: {
                listSubjectsForChoose.accept();
            }
        }

        onVisibleChanged: {
            SubjectsModel.updateModel()
        }

        onAccepted: {
            //Могу возвращать сразу объект
            //var locIndex = listSubjects.choosenElement;
            //var locSubjID = SubjectsModel.getId(locIndex);
            locSubject = listSubjects.choosenElement;//SubjectsModel.getSubjectByID(locSubjID);
            subjectID.text = locSubject.ID;
            subjectName.text = locSubject.getFullName();
        }
    }

}

