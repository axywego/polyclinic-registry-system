import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0
import Polyclinic.UI 1.0

Rectangle {
    id: root

    objectName: "mainScreen"

    property int idPolyclinic: 0
    property string namePolyclinic: ""

    color: '#4b4b4b'

    property var polyclinicNameCache: ({})

    function getPolyclinicName(id) {
        if (id <= 0) {
            return ""
        }

        if (polyclinicNameCache[id] !== undefined) {
            return polyclinicNameCache[id]
        }

        try {
            const polyclinics = PolyclinicService.search([
                {"field": "id", "operator": "eq", "value": id}
            ])
            
            if (polyclinics.length > 0) {
                const name = polyclinics[0].name || ""
                polyclinicNameCache[id] = name
                return name
            }
        } 
        catch (error) {
            console.error("Ошибка получения названия поликлиники:", error)
        }
        return "Название потерялось..."
    }

    onIdPolyclinicChanged: {
        namePolyclinic = getPolyclinicName(idPolyclinic)
    }

    Component.onCompleted: {
        if (idPolyclinic > 0) {
            namePolyclinic = getPolyclinicName(idPolyclinic)
        }
    }

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
            spacing: 0

            Titlebar {
                Layout.fillWidth: true
                title: namePolyclinic
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: sidebar.currentIndex

                DashboardView {
                    idPolyclinic: root.idPolyclinic
                }
            }
        }
    }
}