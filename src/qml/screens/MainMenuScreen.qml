import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts

import Utils;
import Registrar.Services

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

        TextField {
            id: loginInput
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 16
            focus: true
            placeholderText: "login"
        }

        TextField {
            id: passwordInput
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 16
            placeholderText: "password"
        }

        Text {
            id: authError
            text: ""
        }

        Button {
            text: "Просмотр поликлиник"
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                const res = checkAuth()
                if(res.error === "false")
                    stackView.push("MainScreen.qml", {
                        "idPolyclinic": res.id_polyclinic
                    })
                else
                    authError.text = "Error"
            }
        }
    }

    function checkAuth() {
        const registrars = RegistrarService.search([
            {"field" : "login", "operator": "eq", "value": loginInput.text}
        ])
        if(registrars.length === 0)
            return {"id_polyclinic": -1, "error": "true"}
        const registrar = registrars[0]
        const hash = Utils.sha256(passwordInput.text)
        if(registrar.password_hash === hash)
            return {"id_polyclinic": registrar.id_polyclinic, "error": "false"}
        else 
            return {"id_polyclinic": -1, "error": "true"}
    }
}