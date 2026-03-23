import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import Polyclinic.Services 1.0

Window {
    width: 800
    height: 600
    visible: true
    title: "Polyclinics"

    color: '#c2faff'

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16

        ListView {
            id: clinicsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: []
            
            delegate: ItemDelegate {
                id: control
                width: parent.width
                height: 60
                
                background: Rectangle {
                    color: control.down ? '#9d9d9d' :
                            control.hovered ? '#d5d5d5' :
                            '#fff'
                    radius: 8
                    border.color: "#e0e0e0"
                    border.width: 1

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                contentItem: Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4
                    Text {
                        text: "<b>" + modelData.name + "</b>"
                        font.pixelSize: 16
                        color: '#000000'
                    }
                    Text {
                        text: modelData.address
                        font.pixelSize: 12
                        color: '#474768'
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignCenter
            text: "Нет записей."
            color: "#999"
            font.pixelSize: 14
            visible: clinicsList.model && clinicsList.model.length === 0
        }
    }

    function loadClinics() {
        console.log("Load data...");
        var clinics = PolyclinicService.getAll();
        clinicsList.model = clinics;
        console.log("Load rows:", clinics.length);
    }

    Component.onCompleted: {
        loadClinics();

        PolyclinicService.dataChanged.connect(() => {
            console.log("Data has been changed, updating the list");
            loadClinics();
        });
    }
}