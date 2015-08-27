import QtQuick 2.3
import QtQuick.Controls 1.2
import Qt.WebSockets 1.0
import "twitter-stream.js" as TwitterStream

ApplicationWindow {
    id: app
    visible: true
    width: 480
    height: 800
    title: qsTr("Qt Developer Days 2014")
    color: "white"

    property bool loading: false

    Component.onCompleted: {
        TwitterStream.initItems(tweet)
        TwitterStream.openWebSocketConnection(socket)
    }


    WebSocket {
        id: socket

        active: true
        onTextMessageReceived: {
            console.log("Got new tweet")
            TwitterStream.insertTweet(tweet, TwitterStream.parseTweet(message))
        }
        onStatusChanged: {
            if (socket.status == WebSocket.Error) {
              console.log("Error: " + socket.errorString)
            } else if (socket.status == WebSocket.Open) {
              console.log("WebSocket connected")

            } else if (socket.status == WebSocket.Closed) {
              console.log("WebSocket closed")
            }
        }
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    ListModel {
        id: tweet
    }

    Rectangle {
        id: toolbar
        z: 10
        height: 40
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#777876"
            }

            GradientStop {
                position: 1
                color: "#142a01"
            }

        }

        border.width: 0
        border.color: "#00000000"

        anchors { top: parent.top; left: parent.left; right: parent.right }

        Image {
            id: logo
            anchors { top: parent.top; left: parent.left }
            height: parent.height * 0.7
            anchors.leftMargin: 10
            anchors.topMargin: 5
            fillMode: Image.PreserveAspectFit
            source: "images/qt-logo.png"
            smooth: true
        }

        Text {
            id: text1
            x: 308
            y: 13
            color: "#ffffff"
            text: qsTr("#QtDD2014")
            horizontalAlignment: Text.AlignHCenter
            anchors.centerIn: parent
            font.bold: true
            wrapMode: Text.NoWrap
            font.pixelSize: 20
        }
    }

    ListView {
        id: tweets
        width: parent.width
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        spacing: 15
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.top: toolbar.bottom
        anchors.topMargin: 1
        z: 1
        topMargin: 5
        clip: true
        model: tweet
        delegate: Tweet {}

        add: Transition {
                 //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 300 }
                 NumberAnimation { property: "y"; duration: 300 }
             }

        addDisplaced: Transition { NumberAnimation { property: "y"; duration: 300 } }
    }


}
