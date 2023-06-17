import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';

class PinProjectLocationView extends StatefulWidget {
  const PinProjectLocationView({
    super.key,
  });

  @override
  State<PinProjectLocationView> createState() => _PinProjectLocationViewState();
}

class _PinProjectLocationViewState extends State<PinProjectLocationView> {
  final pickerController = PickerMapController();
  bool isMapReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPickerLocation(
        controller: pickerController,
        onMapReady: (bool isReady) {
          if (!isReady) return;

          isMapReady = isReady;
          setState(() {});
        },
        appBarPicker: AppBar(
          centerTitle: true,
          title: Text(
            "Peta Lokasi Proyek",
            style: buildTextStyle(
              fontSize: 16,
              fontWeight: 500,
              fontColor: MyColors.yellow01,
            ),
          ),
          backgroundColor: MyColors.darkBlack02,
        ),
        topWidgetPicker: Padding(
            padding: const EdgeInsets.all(
              16,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => isMapReady ? sendDataBack(context) : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MyColors.darkBlack02,
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    child: Text(
                      "Simpan",
                      style: buildTextStyle(
                        fontSize: 16,
                        fontColor: MyColors.greenBackgroundStatusCard,
                        fontWeight: 600,
                      ),
                    ),
                  ),
                ),
              ],
            )),
        pickerConfig: CustomPickerLocationConfig(
          loadingWidget: buildLoadingPage(),
          initZoom: 15,
          minZoomLevel: 8,
          advancedMarkerPicker: const MarkerIcon(
            icon: Icon(
              PhosphorIcons.mapPinFill,
              color: MyColors.redBackgroundMaintenanceCard,
              size: 150,
            ),
          ),
        ),
      ),
    );
  }

  void sendDataBack(BuildContext context) async {
    GeoPoint point =
        await pickerController.getCurrentPositionAdvancedPositionPicker();
    Navigator.pop(
      context,
      LatLng(
        point.latitude,
        point.longitude,
      ),
    );
  }
}
