import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2
import "../Helpers"

Item {
    width: 300
    height: 300
    ListForChoosen{
        anchors.fill: parent
        shownModel: SubjectsModel
    }

}
