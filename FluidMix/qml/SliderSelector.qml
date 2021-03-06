import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.0


ColumnLayout {
    id: controller

    property string title: qsTr("Target volume and temperature")
    property double volume: 100
    property double temperature: 100
    property int maxVolume: 200
    property int maxTemp: 100
    property int minTemp: 0

    signal valueChanged()

    function setVolume(v)
    {
        if (v > maxVolume) {
            v = maxVolume;
        }

        if (v < 5) {
            v = 5;
        }

        volume = v;
    }

    function setTemp(t)
    {
        if (t > maxTemp) {
            t = maxTemp;
        }

        if (t < minTemp) {
            t = minTemp;
        }

        temperature = t;
    }

    function getVolume()
    {
        return Math.round(appSlider.value * maxVolume)
    }

    function getTemp()
    {
        return Math.round(appSlider1.value * maxTemp)
    }

    AppText {
        text: title
        fontSize: 12
        Layout.topMargin: 10
        Layout.bottomMargin: 10
    }

    RowLayout {
        AppSlider {
            id: appSlider
            stepSize: 0.025

            value: volume / maxVolume

            onValueChanged: {
                appText.text = getVolume().toString() + " ml"
                controller.valueChanged()
            }
        }

        AppText {
            id: appText
            text: getVolume().toString() + " ml"
        }
    }

    RowLayout {
        AppSlider {
            id: appSlider1

            value: temperature / maxTemp

            onValueChanged: {
                appText1.text = getTemp().toString() + " C"
                controller.valueChanged()
            }
        }

        AppText {
            id: appText1
            text: getTemp().toString() + " C"
        }
    }
}
