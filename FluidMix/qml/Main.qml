import Felgo 3.0
import QtQuick 2.11
import QtQuick.Layouts 1.0

App {
    id: root

    property bool ready: false

    Storage {
        id: storage
    }

    NavigationStack {
        Page {
            title: qsTr("Blandingskalkulator")

            Grid {
                id: colContent
                columns: 1
                spacing: 20
                topPadding: 20

                horizontalItemAlignment: Grid.AlignHCenter

                width: root.width

                RowLayout {
                    id: rowCups

                    WaterCup {
                        id: sourceControl1
                        title: qsTr("Blandevann 1")

                        onValueChanged: {
                            doCalc()
                        }
                    }

                    WaterCup {
                        id: sourceControl2
                        title: qsTr("Blandevann 2")

                        Layout.leftMargin: 20

                        onValueChanged: {
                            doCalc()
                        }
                    }
                }

                SliderSelector {
                    id: targetControl
                    title: qsTr("Ønsket mengde og temperatur:")

                    onValueChanged: {
                        doCalc()
                    }

                    Component.onCompleted: {
                        loadValues();
                        ready = true;
                    }
                }

                AppText {
                    text: "\nGlass 1 har " + sourceControl1.volume + " ml vann med temp " + sourceControl1.temperature + " C"
                          + "\nGlass 2 har " + sourceControl2.volume + " ml vann med temp " + sourceControl2.temperature + " C"
                          + "\n\nDette gir ferdig blanding på " + Math.round(targetControl.volume) + " ml vann med temp " + targetControl.temperature + " C";

                    fontSize: 12
                    width: root.width

                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    function loadValues()
    {
        sourceControl1.setTemp(storage.getValue("temp1"));
        sourceControl1.setVolume(storage.getValue("volume1"));

        sourceControl2.setTemp(storage.getValue("temp2"));
        sourceControl2.setVolume(storage.getValue("volume2"));

        targetControl.setTemp(storage.getValue("temp"));
        targetControl.setVolume(storage.getValue("volume"));

        console.log("LOAD")
        console.log("temp1: " + storage.getValue("temp1"))
        console.log("volume1: " + storage.getValue("volume1"))
        console.log("temp2: " + storage.getValue("temp2"))
        console.log("volume2: " + storage.getValue("volume2"))
        console.log("temp: " + storage.getValue("temp"))
        console.log("volume: " + storage.getValue("volume"))
    }

    function saveValues()
    {
        storage.setValue("temp1", sourceControl1.getTemp())
        storage.setValue("volume1", sourceControl1.getVolume())

        storage.setValue("temp2", sourceControl2.getTemp())
        storage.setValue("volume2", sourceControl2.getVolume())

        storage.setValue("temp", targetControl.getTemp())
        storage.setValue("volume", targetControl.getVolume())

        console.log("SAVE")
        console.log("temp1: " + sourceControl1.getTemp())
        console.log("volume1: " + sourceControl1.getVolume())
        console.log("temp2: " + sourceControl2.getTemp())
        console.log("volume2: " + sourceControl2.getVolume())
        console.log("temp: " + targetControl.getTemp())
        console.log("volume: " + targetControl.getVolume())
    }

    function doCalc()
    {
        if (!ready)
            return;

        var m = targetControl.getVolume();
        var t = targetControl.getTemp();
        var t1 = sourceControl1.temperature;
        var t2 = sourceControl2.temperature;

        var m2 = calcFluidsM2(m, t, t1, t2);
        var m1 = calcFluidsM1(m, m2);

        sourceControl1.setVolume(m1);
        sourceControl2.setVolume(m2);

        saveValues();
    }

    function calcFluidsM2(m, t, t1, t2) {
        var m2 = ( m * (t - t1) ) / (t2 - t1);

        if (m2 > m)
            m2 = m;

        if (m2 < 0)
            m2 = 0;

        return m2;
    }

    function calcFluidsM1(m, m2)
    {
        var m1 = m - m2;

        if (m1 > m)
            m1 = m;

        if (m1 < 0)
            m1 = 0;

        return m1;
    }

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"
}
