import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Image {
        id: bg
        source: "../img/concrete_cylinder.png"
        horizontalAlignment: Image.AlignLeft
        verticalAlignment: Image.AlignTop
        fillMode: Image.PreserveAspectFit
        anchors {
            topMargin: Theme.paddingLarge * 2
            bottom : parent.bottom
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Concrete") + "\n" + qsTr("Mixer")
    }

    CoverActionList {
        id: coverAction
        /*
        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
        */
    }

}
