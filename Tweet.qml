import QtQuick 2.0
import QtGraphicalEffects 1.0
import "twitter-stream.js" as TwitterStream

Rectangle {
    x: 5

    width: parent.width - 10
    color: "white"
    anchors.margins: 10

    height: row1.height

    function refreshTime() {
        time.text = TwitterStream.parseTwitterDate(created)
    }

    Timer {
         interval: 30000; running: true; repeat: true
         onTriggered: refreshTime()
     }

    Text {
        id: time
        text: TwitterStream.parseTwitterDate(created)
        color: "gray"
        anchors.right: parent.right
    }
    Row {
        id: row1
        anchors.topMargin: 10
        spacing: 10
        width: parent.width
        height: texts.height > profileImg.height ? texts.height : profileImg.height

        Image {
            id: profileImg
            source: img
            width: 40
            fillMode: Image.PreserveAspectFit
            smooth: true
            visible: false
        }
        Rectangle {
                id: mask
                width: profileImg.width
                height: profileImg.height
                color: "black"
                radius: 5
                clip: true
                visible: false
            }

        OpacityMask {

            source: profileImg
            width: profileImg.width
            height: profileImg.height

            maskSource: mask
        }
        Column {
            id: texts
            width: parent.width - profileImg.width - 4
            spacing: 2
            Row {
                spacing: 2
                Text {
                    id: authorName
                    text: name
                    color: "black"
                    font.bold: true
                }
                Text {
                    id: author
                    text: "@"+screenName
                    color: "gray"

                }

            }
            Text {

                id: tweetContent
                text: tweetText
                color: "#000000"
                textFormat: Text.StyledText
                width: parent.width
                wrapMode: Text.Wrap

            }
        }
    }
    Rectangle {
        border.width: 1
        border.color: "lightgray"
        height:1
        color: "transparent"
        width: parent.width
        y: parent.height + 5
    }
}
