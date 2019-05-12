import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.0

ColumnLayout {
    id: cup

    property int maxVolume: 200
    property int maxTemp: 100
    property int minTemp: 0

    property int volume: 100
    property int temperature: 51

    property int width_: 140
    property int height_: 250

    property string title: qsTr("Title")

    signal valueChanged()

    function setVolume(v)
    {
        volume = v;
    }

    function setTemp(t)
    {
        temperature = t;
    }

    function getVolume()
    {
        return volume;
    }

    function getTemp()
    {
        return temperature;
    }

    Rectangle {
        id: container
        width: width_
        height: height_

        //color: "#ececec"

        gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.5; color: "#ececec" }
            }

        Rectangle {
            id: fill
            width: parent.width - 2
            height: parent.height * (volume / maxVolume)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom


            gradient: Gradient {
                    GradientStop { position: 0.0; color: "#4086f9" }
                    GradientStop { position: 1.0; color: "#0061ff" }
                }
        }

        Column {
            width: width_
            anchors.horizontalCenter: parent.horizontalCenter
            AppButton {
                id: tempText
                text: temperature.toString() + " C"

                flat: false
                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: InputDialog.inputTextSingleLine(root,
                                                          "Temperatur Celcius", //message text
                                                          "0 - 100",         //placeholder text
                                                          function(ok, text) {
                                                            if(ok) {
                                                              temperature = textToTemperatur(text);
                                                              valueChanged()
                                                            }
                                                          })
            }

            AppText {
                id: volumeText
                text: Math.round(volume).toString() + " ml"

                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

    }

    function textToTemperatur(text)
    {
        var t = 0;

        if (!isNaN(text))
        {
            t = parseInt(text)
        }

        if (t < 0)
        {
            t = 0;
        }
        else if (t > 100)
        {
            t = 100;
        }

        return t;
    }


}
