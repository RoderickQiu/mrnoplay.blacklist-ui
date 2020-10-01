import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: notFromMr
    visible: true
    width: 320
    height: 480
	title: (Qt.platform.os == "mac" ? "" : " ") + "Oops!"

	flags: Qt.Dialog | Qt.MSWindowsFixedSizeDialogHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

	FontLoader { id: sourceHan; source: "/assets/SourceHanSansSC-Regular.ttf" }

    Text {
        id: onlyfrommr
		x: 0
		y: 174
		width: 320
		height: 13
        text: qsTr("This app can only be opened from Mr Noplay")
		font.family: sourceHan.name
		horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }
}
