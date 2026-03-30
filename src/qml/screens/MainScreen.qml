import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0
import Polyclinic.UI 1.0 

Rectangle {
    objectName: "mainScreen"

    property int idPolyclinic: 0
    property string namePolyclinic: ""

    color: '#4b4b4b'

    RowLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        Sidebar {
            id: sidebar
            Layout.fillHeight: true
            Layout.preferredWidth: 250
        }

        ColumnLayout {
            Titlebar {
                title: namePolyclinic
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: sidebar.currentIndex

                DashboardView { }
            }
        }
        
    }
}