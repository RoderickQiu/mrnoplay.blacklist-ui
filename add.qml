import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
import AddTransfer 1.0

Window {
    id: add
    visible: true
	width: 207
	height: 100
	color: "#eeeeee"
	title: (Qt.platform.os == "mac" ? "" : " ") + qsTr("Mr Noplay Blacklist")

	flags: Qt.Window | Qt.FramelessWindowHint | Qt.WindowMinimizeButtonHint

    property string bundleId: "com.scrisstudio.exampleapp";

    AddTransfer {
        id: addtrans
        onSig_getFromTerminal: {
            bundleId = shellresult;
            main.toAddName = bundleId;
            add.close();
        }
    }

	FontLoader { id: sourceHan; source: "qrc:/assets/SourceHanSansSC-Regular.ttf" }

    Column {
        id: container
		x: 0
        y: 4
		width: 207
		height: 100
		anchors.top: parent.top
		anchors.topMargin: 0

		Button {
			height: 20
			width: 20
			anchors.right: parent.right
			anchors.rightMargin: 4
			anchors.top: parent.top
			anchors.topMargin: 4

			Image {
				id: imgWinClose
				source: "assets/delete.png"
				height: 12
				width: 12
				anchors.right: parent.right
				anchors.rightMargin: 4
				anchors.top: parent.top
				anchors.topMargin: 4
			}

			onClicked: {
				add.close()
			}
		}

        Row {
            id: titlebar
            y: 10
			width: 125
			height: 20

            Text {
                id: label02
                height: 20
				text: qsTr("Add an App")
				font.family: sourceHan.name
                font.bold: true
                rightPadding: 4
                topPadding: 0
                leftPadding: 15
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }
        }

        Column {
            id: column
            width: 320
            height: 400
            anchors.top: parent.top
            anchors.topMargin: 35

            Button {
                id: submit
                objectName: "submit"
                x: 110
                width: 80
                height: 30
				text: qsTr("Submit")
				font.family: sourceHan.name
                anchors.top: parent.top
                anchors.topMargin: 0
                onClicked: {
                    if(result.text.indexOf("Mr Noplay") != -1 || result.text.indexOf("mrnoplay") != -1) result.text = qsTr("Invalid.");
                    else addtrans.slot_getFromTerminal(result.text);
                }
            }

            FileDialog {
                id: filedialog
                title: "Please choose a file"
				folder: shortcuts.home
				nameFilters: Qt.platform.os !== "osx" ? "Executables (*.exe *.dll *.msi)" : ""
				onAccepted: {
					result.text = String(filedialog.fileUrl).slice(7);
                }
                visible: false
            }

            Button {
                id: choose
                x: 15
                width: 80
                height: 30
				text: qsTr("Choose")
				font.family: sourceHan.name
                anchors.top: parent.top
                anchors.topMargin: 0
                onClicked: filedialog.visible = true;
            }

            Text {
                id: result
				x: 15
				width: 175
				height: 26
				wrapMode: Text.WrapAnywhere
				fontSizeMode: Text.HorizontalFit
                elide: Text.ElideNone
                anchors.left: parent.left
                anchors.leftMargin: 15
                renderType: Text.QtRendering
                anchors.top: parent.top
                anchors.topMargin: 35
                visible: true
                font.bold: false
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
				font.pixelSize: 5
                rightPadding: 0
                topPadding: 0
                leftPadding: 0
            }
        }
    }

}

/*##^##
Designer {
	D{i:1;anchors_y:15}D{i:5;anchors_y:0}D{i:7;anchors_y:0}D{i:8;anchors_x:15}
}
##^##*/
