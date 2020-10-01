import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.LocalStorage 2.0

Window {
    id: main
    visible: true
    width: 320
    height: 480
	title: (Qt.platform.os == "mac" ? "" : " ") + qsTr("Mr Noplay Blacklist")

	flags: Qt.Dialog | Qt.MSWindowsFixedSizeDialogHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint

    property string toAddName: "appname.app";
    onToAddNameChanged: {
        listnames.append({name: toAddName})
        for (var i = 0; i <= listnames.count; i++) {
            if(listnames.get(i).name === toAddName) {
                listnames.remove(i);
            }
        }
        listnames.append({name: toAddName})
    }

	FontLoader { id: sourceHan; source: "qrc:/assets/SourceHanSansSC-Regular.ttf" }

    //way: 0=false=blacklist, 1=true=whitelist
    property int way: 0;

    property var db;
    function initDatabase() {
        db = LocalStorage.openDatabaseSync("mrnoplay-blacklist", "1.0", "The Blacklist", 100000);
        db.transaction( function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS blacklist(name TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS way(selection INTEGER)');
        });
    }
    function readData() {
        if(!db) { return; }
        db.transaction(function(tx) {
            var result = tx.executeSql('select * from blacklist');
            for(var i = 0; i < result.rows.length; i++) {
                listnames.append({name: result.rows[i].name});
            }
            var wayresult = tx.executeSql('select * from way');
            way = wayresult.rows[0].selection;
            combo.currentIndex = way;
        });
    }
    function storeData() {
        if(!db) { return; }
        db.transaction(function(tx) {
            tx.executeSql('DROP TABLE blacklist');
            tx.executeSql('CREATE TABLE IF NOT EXISTS blacklist(name TEXT)');
            for (var i = 0; i < listnames.count; i++) {
                tx.executeSql("INSERT INTO blacklist VALUES ('" + listnames.get(i).name + "')");
            }
            tx.executeSql('DROP TABLE way');
            tx.executeSql('CREATE TABLE IF NOT EXISTS way(selection INTEGER)');
            tx.executeSql("INSERT INTO way VALUES ('" + way + "')");
        });
    }

    function cut(original) {
        var result = original;
        if (Qt.platform.os !== "osx") {
            result = ".." + original.slice((original.length - 32) > 0 ? (original.length - 32) : 1 ,original.length);
        }
        return result;
    }

    Component.onCompleted: {
        initDatabase();
        readData();
    }
    Component.onDestruction: {
        storeData();
    }

    Column {
        id: container
        width: 320
        height: 400
        visible: true
        anchors.top: parent.top
        anchors.topMargin: 15

        Row {
            id: titlebar
            width: 320
            height: 20
            anchors.top: parent.top
            anchors.topMargin: 0

            Text {
                id: label01
                height: 20
                text: qsTr("Only Selected Apps are: ")
				font.family: sourceHan.name
                anchors.top: parent.top
                anchors.topMargin: 5
                rightPadding: 4
                topPadding: 0
                leftPadding: 15
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 14
            }

            ComboBox {
                id: combo
                width: 110
                height: 30
                font.pointSize: 9
                model: Qt.platform.os == "mac" ? [qsTr("Forbidden"), qsTr("Allowed")] : [qsTr("Forbidden")]
                onActivated: {
                    way = index;
                }
            }
        }

        Column {
            id: listfather
            width: 320
            height: 380
            anchors.top: parent.top
            anchors.topMargin: 40

            ListView {
                id: list
                width: 290
                height: 320
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 20
                model: ListModel {
                    id: listnames
                }

                delegate: Item {
                    x: 5
                    width: 290
                    height: 30

                    Row {
                        id: rowinlist

                        Column {
                            id: lefttextsinlist

                            Text {
                                text: cut(lefttextsinlist.children[1].text)
                                font.bold: Qt.platform.os !== "osx" ? true : false;
                                font.pixelSize: Qt.platform.os == "osx" ? 1 : 11;
								color: Qt.platform.os == "osx" ? "white" : "black";
                            }

                            Text {
                                text: name
                                font.bold: Qt.platform.os == "osx" ? true : false;
                                font.pixelSize: Qt.platform.os !== "osx" ? 5 : 13;
                                color: Qt.platform.os !== "osx" ? "grey" : "black";
                                anchors.top: parent.top;
								anchors.topMargin: Qt.platform.os !== "osx" ? 12 : 0;
                            }

                            height: 20
                            width: 250
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Button {
                            height: 20
                            width: 20

							Image {
                                id: imgdelete
                                source: "assets/delete.png"
                                height: 12
                                width: 12
                                anchors.left: parent.left
                                anchors.leftMargin: 4
                                anchors.top: parent.top
                                anchors.topMargin: 4
                            }

                            onClicked: {
                                for (var i = 0; i < listnames.count; i++) {
                                    if(listnames.get(i).name === name) {
                                        listnames.remove(i);
                                    }
                                }
                            }
                        }
                        spacing: 20
                    }
                }
            }
        }

        Row {
            id: addfather
            x: 15
            y: 400
            width: 290
            height: 60

            Button {
                id: add
                width: 90
                height: 30
                text: qsTr("Add an App")
				font.family: sourceHan.name
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                onClicked: {
                    var component = Qt.createComponent("add.qml");
                    component.createObject(add).show();
				}
			}

			Text {
				id: label02
				text: qsTr("Blocks are on only when Mr Noplay is running in workmode.")
				font.family: sourceHan.name
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 0
                font.pixelSize: 10
            }
        }
    }
}

/*##^##
Designer {
	D{i:1;anchors_y:15}D{i:5;anchors_y:60}D{i:2;anchors_y:10}
}
##^##*/
