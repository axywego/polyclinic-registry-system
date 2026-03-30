import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.UI 1.0

Rectangle {
    id: root
    color: '#004065'

    property int currentIndex: 0

    ColumnLayout {
        width: parent.width

        spacing: 0

        Repeater {
            model: [
                { title: "Dashboard" },
            ]

            delegate: SidebarButton {
                title: modelData.title
                isActive: root.currentIndex === index

                onItemClicked: (index, title) => {
                    root.currentIndex = index
                }
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            background: Rectangle {
                color: '#660000'
            }

            contentItem: Text {
                text: "Выйти"
                color: '#fff'
                font.pixelSize: 18

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                stackView.pop()
            }
        }
    }
}