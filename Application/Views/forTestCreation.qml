import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Dialog {
    id: window
    function openEdit(row){
        console.log('try to open editor');
        elem.editEntry(row);
    }

    EditVisit{
        id: elem
    }


}
