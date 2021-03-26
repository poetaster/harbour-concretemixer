import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    allowedOrientations: Orientation.Portrait

    property real zeroingIt
    property string shapeName : "slab"

    property real neededCement : 0
    property real neededSand : 0
    property real neededGravel : 0

    property real neededVolumeCement : 0
    property real neededVolumeSand : 0
    property real neededVolumeGravel : 0

    property real neededCement50kgBags : 0
    property real neededSand50kgBags : 0
    property real neededGravel50kgBags : 0
    property real neededWater : 0

    property real realAirVolume : 0
    property real realConcreteVolume : 0

    property real projectVolume : 0
    property real projectWeight : 0
    property real projectWeightExactly : 0
    property real projectKNm2

    // Standard Values International for quick calculation without considering the exact mix
    property real massReadyMixConcrete_m3 : 2130 // [kg/m³]

    // Presets, can be changed in Settings
    property real massCement_m3 : 1500 // [kg/m3]
    property real massSand_m3 : 1700 // [kg/m3]
    property real massGravel_m3 : 1650 // [kg/m3]

    //shrinking & mixing factor for each material
    property real gravityCement : 3.15
    property real gravitySand : 2.6
    property real gravityGravel : 2.6

    property real percentEntrainedAir : 2
    property real ratioWaterCement : 0.45



    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
/*
        PullDownMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
        }
*/

        PushUpMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("calculate")
                onClicked: calculationBeamBetweenTwoSupports()
            }
        }





        // Main Page to display
        Column {
            id: column
            //width: page.width
            spacing: Theme.paddingSmall
            PageHeader {
                title: qsTr("CONCRETE MIXER")
            }

            //Combobox shape selector
            ComboBox {
                id: idComboBoxShape
                label: qsTr("object")
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("slab / plate")
                        onClicked: {
                            shapeName = "slab"
                            idGridSlab.visible = true
                            idGridCylinder.visible = false
                            allValuesZero()
                        }
                    }
                    MenuItem {
                        text: qsTr("cylinder")
                        onClicked:  {
                            shapeName = "cylinder"
                            idGridSlab.visible = false
                            idGridCylinder.visible = true
                            allValuesZero()
                        }
                    }

                }
            } // End Combobox shape selector





            // Load principal image
            Image {
                id: idImageConcrete
                x: Theme.paddingSmall
                width: page.width-2*Theme.paddingSmall
                height: sourceSize.height+ 2*Theme.paddingLarge
                source: "../img/concrete_" +  shapeName + ".png"
                fillMode: Image.PreserveAspectFit
                // change black/white according to light or dark theme
                layer.effect: ShaderEffect {
                    property color color: Theme.primaryColor
                    fragmentShader: "
                    varying mediump vec2 qt_TexCoord0;
                    uniform highp float qt_Opacity;
                    uniform lowp sampler2D source;
                    uniform highp vec4 color;
                    void main() {
                        highp vec4 pixelColor = texture2D(source, qt_TexCoord0);
                        gl_FragColor = vec4(mix(pixelColor.rgb/max(pixelColor.a, 0.00390625), color.rgb/max(color.a, 0.00390625), color.a) * pixelColor.a, pixelColor.a) * qt_Opacity;
                    } "
                }
                layer.enabled: true
                layer.samplerName: "source"
            }






            // Grid dimensions Slab
            Grid {
                id: idGridSlab
                visible: true
                columns: 3
                rows: 2
                spacing: Theme.paddingSmall

                TextField {
                    id: idTextSlabLength
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 999999 }
                    label: qsTr("length [m]")
                    labelVisible: true
                    text: zeroingIt
                    EnterKey.onClicked: idTextSlabLength.focus = false
                }
                TextField {
                    id: idTextSlabWidth
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 999999 }
                    label: qsTr("width [m]")
                    //EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextSlabWidth.focus = false
                }
                TextField {
                    id: idTextSlabHeight
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 999999 }
                    label: qsTr("height [m]")
                    //EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextSlabHeight.focus = false
                }
            } // End Grid Slab dimensions


            // Grid dimensions Cylinder
            Grid {
                id: idGridCylinder
                visible: false
                columns: 3
                rows: 2
                spacing: Theme.paddingSmall
                Label {
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    text: " "
                }

                TextField {
                    id: idTextCylinderRadius
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 999999 }
                    label: qsTr("radius [m]")
                    labelVisible: true
                    text: zeroingIt
                    EnterKey.onClicked: idTextCylinderRadius.focus = false
                }
                TextField {
                    id: idTextCylinderHeight
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhFormattedNumbersOnly //use "Qt.ImhDigitsOnly" for INT
                    validator: DoubleValidator { bottom: 0.01; decimals: 2; top: 999999 }
                    label: qsTr("height [m]")
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextCylinderHeight.focus = false
                }
            } // End Grid Cylinder dimensions





            Label {
                text: " "
            }
            Label {
                text: " "
            }





            //Combobox mix selector
            ComboBox {
                id: idComboBoxMix
                label: qsTr("mix-ratio")
                onClicked: {
                    idTextRatioSand.focus = false
                    idTextRatioGravel.focus = false
                }

                menu: ContextMenu {
                    MenuItem {
                        //padding: Theme.paddingLarge
                        text: qsTr("MANUAL")
                        onClicked: {
                            idTextRatioCement.text =  1
                            idTextRatioSand.text = 0
                            idTextRatioGravel.text = 0
                        }
                    }
                    MenuItem {
                        //padding: Theme.paddingLarge
                        textFormat: Text.RichText
                        text: qsTr("C10/M10 - weak, 10N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 3
                            idTextRatioGravel.text = 6
                        }
                    }
                    MenuItem {
                        //padding: Theme.paddingLarge
                        text: qsTr("C15/M15 - general purpose, 15N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 2
                            idTextRatioGravel.text = 4
                        }
                    }
                    MenuItem {
                        //padding: Theme.paddingLarge
                        text: qsTr("C20/M20 - normal, 20N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 1.5
                            idTextRatioGravel.text = 3
                        }
                    }
                    MenuItem {
                        //padding: Theme.paddingLarge
                        text: qsTr("C25/M25 - strong, 25N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 1
                            idTextRatioGravel.text = 2
                        }
                    }
                    MenuItem {
                        //padding: Theme.paddingLarge
                        text: qsTr("C30/M30 - 30N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 0.75
                            idTextRatioGravel.text = 1.5
                        }
                    }
                    MenuItem {
                        padding: Theme.paddingLarge
                        text: qsTr("C40/M40 - 40N/mm² after 28 days")
                        onClicked:  {
                            idTextRatioCement.text = 1
                            idTextRatioSand.text = 0.25
                            idTextRatioGravel.text = 0.5
                        }
                    }

                }
            } // End Combobox shape selector


            // Grid Mix
            Grid {
                columns: 3
                rows: 1
                spacing: Theme.paddingSmall
                TextField {
                    enabled: false
                    id: idTextRatioCement
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("cement")
                    labelVisible: true
                    text: "1" // always value of 1, because from this volume standard, all else will be calculated !!!!!
                }
                TextField {
                    id: idTextRatioSand
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhDigitsOnly //use "Qt.ImhFormattedNumbersOnly" for DEC, macht aber manchmal Probleme
                    validator: DoubleValidator { bottom: 0; decimals: 2; top: 10 }
                    label: qsTr("sand / fine") + "\n" + qsTr("aggregates") + "\n" + qsTr("< 4,75 mm")
                    labelVisible: true
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextRatioSand.focus = false
                    onActiveFocusChanged:   {
                        idComboBoxMix.currentIndex = 0 // if any manual input, select first item: manual
                    }
                }
                TextField {
                    id: idTextRatioGravel
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    inputMethodHints: Qt.ImhDigitsOnly //use "Qt.ImhFormattedNumbersOnly" for DEC, macht aber manchmal Probleme
                    validator: DoubleValidator { bottom: 0; decimals: 2; top: 10 }
                    label: qsTr("gravel / coarse") + "\n" + qsTr("aggregates") + "\n" + qsTr("> 4,75 mm")
                    labelVisible: true
                    EnterKey.enabled: text.length >= 0
                    text: zeroingIt
                    EnterKey.onClicked: idTextRatioGravel.focus = false
                    onActiveFocusChanged:   {
                        idComboBoxMix.currentIndex = 0 // if any manual input, select first item: manual
                    }
                }
            } // End Mix dimensions






            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("NECESSARY MATERIAL")
            }

            // Grid Results Material needed
            Grid {
                columns: 3
                rows: 1
                spacing: Theme.paddingSmall
                TextField {
                    id: idTextAmountCement
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("kg")
                    text: neededCement
                }
                TextField {
                    id: idTextAmountSand
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("kg")
                    text: neededSand
                }
                TextField {
                    id: idTextAmountGravel
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("kg")
                    text: neededGravel
                }
            } // End Results Material needed



            // Grid Results Volume needed
            Grid {
                columns: 3
                rows: 1
                spacing: Theme.paddingSmall
                TextField {
                    id: idTextVolumeCement
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("m³")
                    text: neededVolumeCement
                }
                TextField {
                    id: idTextVolumeSand
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("m³")
                    text: neededVolumeSand

                }
                TextField {
                    id: idTextVolumeGravel
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("m³")
                    text: neededVolumeGravel
                }
            } // End Results Volume needed



            // Grid Results Bags needed
            Grid {
                columns: 3
                rows: 1
                spacing: Theme.paddingSmall
                TextField {
                    id: idText50BagsCement
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("50kg bags")
                    text: neededCement50kgBags
                }
                TextField {
                    id: idText50BagsSand
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("50kg bags")
                    text: neededSand50kgBags

                }
                TextField {
                    id: idText50BagsGravel
                    enabled: false
                    color: Theme.highlightColor
                    horizontalAlignment: TextInput.AlignRight
                    width: page.width/3
                    label: qsTr("50kg bags")
                    text: neededGravel50kgBags
                }
            } // End Results Bags needed


            Label {
                text: " "
            }


            DetailItem {
                label: qsTr("amount of water to add to the mix [liter]")
                value: neededWater
            }
            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("VOLUME RESULTS")
            }
            DetailItem {
                label: qsTr("object volume [m³]") + "\n" + qsTr("CONCRETE TO ORDER")
                value: projectVolume
            }
            DetailItem {
                label: qsTr("of which ") + (100-percentEntrainedAir) + qsTr("% is material [m³]")
                value: realConcreteVolume
            }
            DetailItem {
                label: qsTr("and ") + percentEntrainedAir + qsTr("% is entrained air [m³]")
                value: realAirVolume
            }
            Label {
                text: " "
            }





            SectionHeader {
                text: qsTr("OTHER RESULTS")
            }
            DetailItem {
                label: qsTr("estimated weight as ready-mix [kg]")
                value: projectWeight
            }
            DetailItem {
                label: qsTr("calculated total weight [kg]")
                value: projectWeightExactly
            }
            DetailItem {
                label: qsTr("area load [kN/m²]")
                value: projectKNm2
            }





            Label {
                text: " "
            }

            Label {
                text: " "
            }

        } // End of full column

    } // End of Flickable











/// Part for Functions /////////////////////////////////////////////////////////////
    function calculationBeamBetweenTwoSupports() {


        // Replace commas with dots in string - like from German to English
        // ... then make a number from that string)
        var SlabLength = Number((idTextSlabLength.text).replace(',', '.'))
        var SlabWidth = Number((idTextSlabWidth.text).replace(',', '.'))
        var SlabHeight = Number((idTextSlabHeight.text).replace(',', '.'))
        var CylinderRadius = Number((idTextCylinderRadius.text).replace(',', '.'))
        var CylinderHeight = Number((idTextCylinderHeight.text).replace(',', '.'))

        var RatioCement = Number((idTextRatioCement.text).replace(',', '.'))
        var RatioSand = Number((idTextRatioSand.text).replace(',', '.'))
        var RatioGravel = Number((idTextRatioGravel.text).replace(',', '.'))
        var RatioAll = RatioCement + RatioSand + RatioGravel



        // volume calculations
        if ( shapeName === "slab") {
            projectVolume = SlabLength * SlabWidth * SlabHeight
        }
        if ( shapeName === "cylinder") {
            projectVolume = Math.PI * ( CylinderRadius * CylinderRadius ) * CylinderHeight
        }


        // real colume of necessary fully compacted concrete with some 2%or so of entrained air
        realAirVolume = projectVolume * percentEntrainedAir / 100
        realConcreteVolume = projectVolume - realAirVolume

        // convert each materials dry volume-ratio to mass of cement (
        var massRatioCement = (RatioCement * massCement_m3) / massCement_m3
        var massRatioSand = (RatioSand * massSand_m3) / massCement_m3
        var massRatioGravel = (RatioGravel * massGravel_m3) / massCement_m3

        // Absolute Volume-formula for concrete depending on amount of CEMENT, considers all factors!!! -> gives m³
        var absoluteVolume_for_Concrete_Of_1Kg_Cement =   ( (ratioWaterCement*1) / 1000 )
                                                        + ( (massRatioCement*1) / (1000*gravityCement) )
                                                        + ( (massRatioSand*1) / (1000*gravitySand) )
                                                        + ( (massRatioGravel*1) / (1000*gravityGravel) )

        // quantity of cement [kg] required for project
        neededCement = realConcreteVolume / absoluteVolume_for_Concrete_Of_1Kg_Cement
        neededSand = RatioSand * neededCement
        neededGravel = RatioGravel * neededCement
        neededWater = ratioWaterCement * neededCement

        // quantity of 50kg bags required for project
        neededCement50kgBags = neededCement / 50
        neededSand50kgBags = neededSand / 50
        neededGravel50kgBags = neededGravel / 50

        // volume needed to order [m³]
        neededVolumeCement = neededCement / massCement_m3
        neededVolumeSand = neededSand / massSand_m3
        neededVolumeGravel = neededGravel / massGravel_m3



        // weight calculations
        projectWeight = massReadyMixConcrete_m3 * projectVolume
        projectWeightExactly = neededCement + neededSand + neededGravel + neededWater

        if ( shapeName === "slab") {
            projectKNm2 = projectWeightExactly * 9.81 / (1000 * (SlabWidth * SlabLength))
        }
        if ( shapeName === "cylinder") {
            projectKNm2 = projectWeightExactly * 9.81 / (1000 * (Math.PI * CylinderRadius * CylinderRadius))
        }





        // round some results to 3 places after comma
        projectVolume = (Math.round(projectVolume * 1000)/1000).toFixed(3) //rounding to 3 digits after comma1,
        neededCement = (Math.round(neededCement * 1000)/1000).toFixed(3)
        neededSand = (Math.round(neededSand * 1000)/1000).toFixed(3)
        neededGravel = (Math.round(neededGravel * 1000)/1000).toFixed(3)
        neededWater = (Math.round(neededWater * 1000)/1000).toFixed(3)
        projectWeight = (Math.round(projectWeight * 1000)/1000).toFixed(3)
        projectWeightExactly = (Math.round(projectWeightExactly * 1000)/1000).toFixed(3)
        projectKNm2 = (Math.round(projectKNm2 * 1000)/1000).toFixed(3)
        realConcreteVolume = (Math.round(realConcreteVolume * 1000)/1000).toFixed(3)
        realAirVolume = (Math.round(realAirVolume * 1000)/1000).toFixed(3)

        neededVolumeCement = (Math.round(neededVolumeCement * 1000)/1000).toFixed(3)
        neededVolumeSand = (Math.round(neededVolumeSand * 1000)/1000).toFixed(3)
        neededVolumeGravel = (Math.round(neededVolumeGravel * 1000)/1000).toFixed(3)





        // round some results to 2 places after comma
        neededCement50kgBags = (Math.round(neededCement50kgBags * 100)/100).toFixed(2)
        neededSand50kgBags = (Math.round(neededSand50kgBags * 100)/100).toFixed(2)
        neededGravel50kgBags = (Math.round(neededGravel50kgBags * 100)/100).toFixed(2)


    }




    function allValuesZero() {
        neededCement = 0
        neededSand = 0
        neededGravel = 0

        neededVolumeCement = 0
        neededVolumeSand = 0
        neededVolumeGravel = 0

        neededCement50kgBags = 0
        neededSand50kgBags = 0
        neededGravel50kgBags = 0
        neededWater = 0

        projectVolume = 0
        projectWeight = 0
        projectWeightExactly = 0
        projectKNm2 = 0

        realAirVolume = 0
        realConcreteVolume = 0
        projectVolume = 0
        projectWeight = 0
    }

} // End of Page

