import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.0


ColumnLayout {
    id: controller

    property string title: qsTr("Target volume and temperature")
    property double volume: 100
    property double temperature: 100

    signal valueChanged()

    function setVolume(v)
    {
        if (v > 500) {
            v = 500;
        }

        if (v < 5) {
            v = 5;
        }

        volume = v;
    }

    function setTemp(t)
    {
        if (t > 100) {
            t = 100;
        }

        if (t < 0) {
            t = 0;
        }

        temperature = t;
    }

    function getVolume()
    {
        return Math.round(appSlider.value * 500)
    }

    function getTemp()
    {
        return Math.round(appSlider1.value * 100)
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
            stepSize: 0.01

            value: volume / 500

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

            value: temperature / 100

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
