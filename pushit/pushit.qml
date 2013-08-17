import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "components"

/*!
    \brief MainView with a Label and Button elements.
*/


MainView {

    id: root

    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"
    
    // Note! applicationName needs to match the .desktop filename
    applicationName: "pushit"

    property int __currentDeleteIndex
    property var __currentDeleteButton
    
    /* 
     This property enables the application to change orientation 
     when the device is rotated. The default is false.
    */
    automaticOrientation: true
    
    width: units.gu(50)
    height: units.gu(75)

    Component {
        id: removeDialogComponent
        Dialog {
            id: removeDialog
            title: i18n.tr("Remove button")
            text: i18n.tr("Do you want to remove %1?").arg(root.__currentDeleteButton.name)
            Button {
                text: i18n.tr("Cancel")
                color: "grey"
                onClicked: {
                    buttonList.model.insert(root.__currentDeleteIndex, root.__currentDeleteButton)
                    PopupUtils.close(removeDialog)
                }
            }
            Button {
                text: i18n.tr("Remove")
                color: UbuntuColors.orange
                onClicked: {
                   PopupUtils.close(removeDialog)
                }
            }
        }
   }


    Component {
        id: createDialogComponent
        Dialog {
            id: createDialog
            title: i18n.tr("Create button")
            TextField {
                id: buttonName
                width: parent.width
                placeholderText: i18n.tr("Button name")
                onTextChanged: {
                    errorLabel.visible = false
                }
                Keys.onEnterPressed: {
                    console.log("event.key")
                }
            }
            Text {
                id: errorLabel
                text: i18n.tr("Button name can not be empty")
                color: "red"
                visible: false
            }
            Button {
                text: i18n.tr("Cancel")
                color: "grey"
                onClicked: PopupUtils.close(createDialog)
            }
            Button {
                text: i18n.tr("Create")
                color: UbuntuColors.orange
                onClicked: {

                    // Validate non empty button name
                    if (!buttonName.text) {
                        errorLabel.visible = true
                        return
                    }

                    buttonList.model.append({name: buttonName.text, count: 0})
                    PopupUtils.close(createDialog)
                }
            }
        }
   }
    PageStack {
        id: pageStack
        Component.onCompleted: push(buttonListPage)

        Page {

        id: buttonListPage
        title: i18n.tr("Push It!")

        Column {
           id: lateralCol
           anchors {
               fill: parent
               margins: units.gu(1)
           }
           spacing: units.gu(1)

           Button {
                id: addButton
                objectName: "button"

                text: i18n.tr("New button")

                onClicked: {
                     PopupUtils.open(createDialogComponent)
                }
            }
            ListView {
                id: buttonList
                height: lateralCol.height - addButton.height - lateralCol.spacing
                width: parent.width
                clip: true
                model: ButtonModel {}

                delegate: ListItem.Standard {
                    text: name
                    progression: true
                    removable: true
                    UbuntuShape {
                        anchors {
                            top: parent.top
                            right: parent.right
                            margins: units.gu(1)
                            rightMargin: units.gu(6)
                        }
                        radius: "medium"
                        color: "gray"
                        height: parent.height - (anchors.margins * 2)
                        width: height
                        Label {
                            anchors.centerIn: parent
                            text: count
                            color: "white"
                            font.bold: true
                        }
                    }
                    onClicked: {
                        buttonView.x = 0
                    }
                    onItemRemoved: {
                        root.__currentDeleteButton = buttonList.model.get(index)
                        root.__currentDeleteIndex = index
                        PopupUtils.open(removeDialogComponent)
                    }
                }
            }

       }

    }
    }

    Rectangle {
        id: buttonView
        x: root.width
        width: root.width
        height: root.height - units.gu(8)
        anchors.top: parent.top
        anchors.topMargin: units.gu(10)
        Behavior on x {PropertyAnimation {duration: 200 }}
        MouseArea {
            anchors.fill: parent
        }
        Button {
            text: i18n.tr("Cancel")
            color: UbuntuColors.orange
            anchors.topMargin: units.gu(3)
            onClicked: {
                buttonView.x = root.width
            }
        }
        Rectangle {
            id: bigButton
            width: units.gu(30)
            height: units.gu(30)
            radius: units.gu(30)
            anchors {
                topMargin: parent.height - height
                leftMargin: parent.width - width
            }
            color: UbuntuColors.orange
        }
    }

}
