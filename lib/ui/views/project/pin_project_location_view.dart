import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

class PinProjectLocationViewParam {
  PinProjectLocationViewParam({
    this.longLat,
  });

  final Position? longLat;
}

class PinProjectLocationView extends StatefulWidget {
  const PinProjectLocationView({
    required this.param,
    super.key,
  });

  final PinProjectLocationViewParam param;

  @override
  State<PinProjectLocationView> createState() => _PinProjectLocationViewState();
}

class _PinProjectLocationViewState extends State<PinProjectLocationView>
    with OSMMixinObserver, TickerProviderStateMixin {
  // final pickerController = PickerMapController(
  //   initMapWithUserPosition: const UserTrackingOption(enableTracking: true),
  //   initPosition: GeoPoint(latitude: -7.250445, longitude: 112.768845),
  // );
  final controller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(enableTracking: true),
  );
  late MapController cont;
  GeoPoint? _selectedLocation;
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
    cont = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: widget.param.longLat?.latitude ?? 0,
        longitude: widget.param.longLat?.longitude ?? 0,
      ),
    );
    controller.addObserver(this);
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      isMapReady = isReady;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Peta Lokasi Proyek",
          style: buildTextStyle(
            fontSize: 16,
            fontWeight: 500,
            fontColor: MyColors.yellow01,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              _selectedLocation =
                  await cont.getCurrentPositionAdvancedPositionPicker();
              await cont.cancelAdvancedPositionPicker();
              print(
                'Longlat: ${_selectedLocation?.longitude},${_selectedLocation?.latitude}',
              );
              sendDataBack(context);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                PhosphorIcons.checkCircleBold,
              ),
            ),
          ),
        ],
        backgroundColor: MyColors.darkBlack02,
      ),
      body: OSMFlutter(
        controller: cont,
        osmOption: OSMOption(
          isPicker: true,
          // userTrackingOption: const UserTrackingOption(
          //   enableTracking: true,
          // ),
          zoomOption: const ZoomOption(
            initZoom: 15,
            minZoomLevel: 8,
          ),
          markerOption: MarkerOption(
            advancedPickerMarker: const MarkerIcon(
              icon: Icon(
                PhosphorIcons.mapPinFill,
                color: MyColors.redBackgroundMaintenanceCard,
                size: 150,
              ),
            ),
          ),
          enableRotationByGesture: true,
        ),
        mapIsLoading: const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(
              MyColors.yellow01,
            ),
          ),
        ),
        onMapIsReady: (bool isReady) {
          if (!isReady) return;

          isMapReady = isReady;
          setState(() {});
        },
      ),
    );
  }

  void sendDataBack(BuildContext context) async {
    Navigator.pop(
      context,
      LatLng(
        _selectedLocation?.latitude ?? 0,
        _selectedLocation?.longitude ?? 0,
      ),
    );
  }
}
