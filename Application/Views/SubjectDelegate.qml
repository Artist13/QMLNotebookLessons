import QtQuick 2.0

Item {
    id: delegete
    width: delegete.ListView.view.width
    height: 30
    clip: true
    anchors.margins: 4
    Row{
        anchors.margins: 4
        anchors.fill: parent
        spacing: 4
        Text {
            text: id
            width: 50
        }
        Text{
            text: name
            width: 300
        }
        Text{
            text: classNum
            width: 50
        }
    }

}
