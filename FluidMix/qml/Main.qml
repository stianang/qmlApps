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
                        doCalc();
                    }
                }

                AppText {
                    text: "\nGlass 1 har " + sourceControl1.volume + " ml vann med temp " + sourceControl1.temperature + " C"
                          + "\nGlass 2 har " + sourceControl2.volume + " ml vann med temp " + sourceControl2.temperature + " C"
                          + "\n\nDette gir ferdig blanding på " + Math.round(targetControl.getVolume()) + " ml vann med temp " + targetControl.getTemp() + " C";

                    fontSize: 12
                    width: root.width

                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }

    function load(val, initVal)
    {
        var value = storage.getValue(val);

        if (!value || value < 0) {
            value = initVal;
        }

        return value;
    }

    function loadValues()
    {
        sourceControl1.setTemp(load("temp1", 4));
        sourceControl1.setVolume(load("volume1", 100));

        sourceControl2.setTemp(load("temp2", 96));
        sourceControl2.setVolume(load("volume2", 100));

        targetControl.setTemp(load("temp", 50));
        targetControl.setVolume(load("volume", 200));
    }

    function saveValues()
    {
        storage.setValue("temp1", sourceControl1.getTemp())
        storage.setValue("volume1", sourceControl1.getVolume())

        storage.setValue("temp2", sourceControl2.getTemp())
        storage.setValue("volume2", sourceControl2.getVolume())

        storage.setValue("temp", targetControl.getTemp())
        storage.setValue("volume", targetControl.getVolume())
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
}
