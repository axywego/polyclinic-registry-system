import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    objectName: "menuScreen"

    color: '#c2faff'

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 10

        Text {
            text: "галоунае меню"
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "Просмотр поликлиник"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                stackView.push("PolyclinicSelectionScreen.qml")
            }
        }
    }
}