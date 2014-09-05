#!/bin/sh
set -e

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
install_resource "WhirlyGlobeResources/base_maps/geography-class_medres.mbtiles"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_0x0.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_0x1.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_1x0.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_1x1.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_2x0.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_2x1.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_3x0.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_3x1.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_4x0.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_4x1.pvrtc"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb/lowres_wtb_info.plist"
install_resource "WhirlyGlobeResources/elevation/world_web_mercator.sqlite"
install_resource "WhirlyGlobeResources/LICENSE"
install_resource "WhirlyGlobeResources/maki icons/airfield-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/airport-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/alcohol-shop-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/america-football-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/art-gallery-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/bakery-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/bank-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/bar-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/baseball-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/basketball-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/beer-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/bicycle-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/building-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/bus-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/cafe-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/camera-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/campsite-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/car-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/cemetery-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/cinema-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/circle-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/circle-stroked-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/city-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/clothing-store-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/college-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/commercial-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/cricket-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/cross-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/dam-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/danger-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/disability-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/dog-park-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/embassy-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/emergency-telephone-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/farm-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/fast-food-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/ferry-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/fire-station-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/fuel-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/garden-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/golf-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/grocery-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/harbor-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/heliport-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/hospital-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/industrial-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/land-use-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/laundry-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/library-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/lighthouse-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/lodging-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/logging-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/london-underground-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/marker-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/marker-stroked-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/minefield-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/monument-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/museum-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/music-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/oil-well-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/park-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/park2-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/parking-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/parking-garage-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/pharmacy-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/pitch-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/place-of-worship-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/playground-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/police-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/polling-place-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/post-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/prison-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/rail-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/rail-above-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/rail-underground-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/religious-christian-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/religious-jewish-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/religious-muslim-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/restaurant-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/roadblock-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/rocket-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/school-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/shop-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/skiing-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/slaughterhouse-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/soccer-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/square-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/square-stroked-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/star-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/star-stroked-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/suitcase-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/swimming-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/telephone-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/tennis-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/theatre-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/toilets-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/town-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/town-hall-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/triangle-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/triangle-stroked-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/village-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/warehouse-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/waste-basket-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/water-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/wetland-24@2x.png"
install_resource "WhirlyGlobeResources/maki icons/zoo-24@2x.png"
install_resource "WhirlyGlobeResources/mapbox vectors/osm-bright.xml"
install_resource "WhirlyGlobeResources/mapzen vectors/MapzenStyles.json"
install_resource "WhirlyGlobeResources/README.md"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ABW.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AFG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AGO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AIA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ALA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ALB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AND.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ARE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ARG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ARM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ASM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ATA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ATF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ATG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AUS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AUT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/AZE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BDI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BEL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BEN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BES.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BFA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BGD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BGR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BHR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BHS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BIH.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BLM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BLR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BLZ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BMU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BOL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BRA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BRB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BRN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BTN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BVT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/BWA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CAF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CAN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CCK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CHE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CHL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CHN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CIV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CMR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/COD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/COG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/COK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/COL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/COM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CPV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CRI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CUB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CUW.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CXR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CYM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CYP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/CZE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DEU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DJI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DMA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DNK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DOM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/DZA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ECU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/EGY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ERI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ESH.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ESP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/EST.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ETH.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FIN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FJI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FLK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FRA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FRO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/FSM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GAB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GBR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GEO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GGY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GHA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GIB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GIN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GLP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GMB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GNB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GNQ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GRC.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GRD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GRL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GTM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GUF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GUM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/GUY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HKG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HMD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HND.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HRV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HTI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/HUN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IDN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IMN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IND.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IOT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IRL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IRN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/IRQ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ISL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ISR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ITA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/JAM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/JEY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/JOR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/JPN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KAZ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KEN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KGZ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KHM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KIR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KNA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KOR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/KWT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LAO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LBN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LBR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LBY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LCA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LIE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LKA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LSO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LTU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LUX.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/LVA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MAC.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MAF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MAR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MCO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MDA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MDG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MDV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MEX.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MHL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MKD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MLI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MLT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MMR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MNE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MNG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MNP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MOZ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MRT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MSR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MTQ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MUS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MWI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MYS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/MYT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NAM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NCL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NER.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NFK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NGA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NIC.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NIU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NLD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NOR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NPL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NRU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/NZL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/OMN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PAK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PAN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PCN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PER.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PHL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PLW.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PNG.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/POL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PRI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PRK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PRT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PRY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PSE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/PYF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/QAT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/REU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ROU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/RUS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/RWA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SAU.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SDN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SEN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SGP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SGS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SHN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SJM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SLB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SLE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SLV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SMR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SOM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SPM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SRB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SSD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/STP.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SUR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SVK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SVN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SWE.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SWZ.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SXM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SYC.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/SYR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TCA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TCD.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TGO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/THA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TJK.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TKL.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TKM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TLS.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TON.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TTO.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TUN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TUR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TUV.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TWN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/TZA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/UGA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/UKR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/UMI.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/URY.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/USA.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/UZB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VAT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VCT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VEN.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VGB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VIR.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VNM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/VUT.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/WLF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/WSM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/YEM.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ZAF.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ZMB.geojson"
install_resource "WhirlyGlobeResources/vectors/country_json_50m/ZWE.geojson"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.dbf"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.mbr"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.prj"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.shp"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.shx"
install_resource "WhirlyGlobeResources/vectors/sf_roads/tl_2013_06075_roads.sqlite"
install_resource "WhirlyGlobeResources/base_maps"
install_resource "WhirlyGlobeResources/base_maps/lowres_wtb"
install_resource "WhirlyGlobeResources/elevation"
install_resource "WhirlyGlobeResources/maki icons"
install_resource "WhirlyGlobeResources/mapbox vectors"
install_resource "WhirlyGlobeResources/mapzen vectors"
install_resource "WhirlyGlobeResources/vectors"
install_resource "WhirlyGlobeResources/vectors/country_json_50m"
install_resource "WhirlyGlobeResources/vectors/sf_roads"

rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ `xcrun --find actool` ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in 
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;  
  esac 
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi