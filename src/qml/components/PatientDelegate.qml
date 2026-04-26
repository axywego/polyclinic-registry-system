import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    width: ListView.view.width
    height: 56
    color: mouseArea.containsMouse ? "#F0F4F8" : "transparent"
    radius: 6
    
    required property var patientData
    required property var popupRef
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        
        Rectangle {
            width: 36; height: 36; radius: 18
            color: "#1976D2"; opacity: 0.12
            Text {
                anchors.centerIn: parent
                text: "👤"
                font.pixelSize: 16
            }
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Text {
                text: patientData ? (patientData.full_name || "—") : "—"
                font.pixelSize: 13
                font.weight: Font.DemiBold
                color: "#2C3E50"
                elide: Text.ElideRight
            }
            Text {
                text: {
                    if (!patientData) return "—"
                    var d = patientData.birth_date
                    var dateStr = "—"
                    if (d) {
                        if (typeof d === "string" && d.indexOf("-") !== -1) {
                            var p = d.split("-")
                            dateStr = p[2] + "." + p[1] + "." + p[0]
                        } else if (d && d.getDate) {
                            dateStr = d.getDate().toString().padStart(2,'0') + "." + (d.getMonth()+1).toString().padStart(2,'0') + "." + d.getFullYear()
                        }
                    }
                    return "📅 " + dateStr + "  📞 " + (patientData.phone || "—")
                }
                font.pixelSize: 11
                color: "#7F8C8D"
                elide: Text.ElideRight
            }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (patientData) {
                root.selectedPatient = patientData
            }
            if (popupRef) popupRef.close()
        }
    }
}