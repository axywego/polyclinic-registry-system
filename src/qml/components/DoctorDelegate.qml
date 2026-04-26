import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    width: ListView.view.width
    height: 48
    color: mouseArea.containsMouse ? "#F0F4F8" : "transparent"
    radius: 6
    
    required property var doctorData
    required property var popupRef
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        Rectangle {
            width: 32; height: 32; radius: 16
            color: "#4CAF50"; opacity: 0.12
            Text {
                anchors.centerIn: parent
                text: "👨‍⚕️"
                font.pixelSize: 14
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: doctorData ? (doctorData.doctor_name || "—") : "—"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                color: "#2C3E50"
                elide: Text.ElideRight
            }
            Text {
                text: doctorData ? ((doctorData.specialty_name || "—") + " · Каб. " + (doctorData.room_number || "—")) : "—"
                font.pixelSize: 11
                color: "#7F8C8D"
            }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (doctorData) {
                root.selectedDoctor = doctorData
            }
            if (popupRef) popupRef.close()
        }
    }
}