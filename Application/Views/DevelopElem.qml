import QtQuick 2.0

Item {
    anchors.fill: parent

    Text {
        anchors.fill: parent
        id: developText
        text: qsTr("Находится в разработке")
        font.pixelSize: 40
        rotation: 45
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

}
