import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Polyclinic.UI 1.0
import Polyclinic.Services 1.0

Rectangle {
    objectName: "polyclinicSelection"

    color: '#4b4b4b'

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16

        Button {
            text: "Назад"
            onClicked: {
                stackView.pop()
            }
        }

        ListView {
            id: clinicsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: []

            spacing: 5

            ScrollBar.vertical: ScrollBar {
                active: true
                policy: ScrollBar.AsNeeded
            }
            
            delegate: Button {
                id: control
                width: parent.width
                height: 60
                
                background: Rectangle {
                    color: control.down ? '#cacaca' :
                            control.hovered ? '#e6e6e6' :
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

                onClicked: {
                    stackView.push("MainScreen.qml", {
                        "idPolyclinic": modelData.id,
                        "namePolyclinic": modelData.name
                    })
                }
            }
        }
        Text {
            Layout.alignment: Qt.AlignCenter
            text: "Нет записей."
            color: '#000000'
            font.pixelSize: 16
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