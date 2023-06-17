import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/loading.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

//using different library (OSM Flutter) than MapView
class MapViewParamV2 {
  MapViewParamV2({
    this.longitude,
    this.latitude,
    this.titleNote,
    this.dateTime,
    this.descNote,
  });

  final double? longitude;
  final double? latitude;
  final String? titleNote;
  final String? dateTime;
  final String? descNote;
}

class MapViewV2 extends StatefulWidget {
  const MapViewV2({
    required this.param,
    super.key,
  });

  final MapViewParamV2 param;

  @override
  State<MapViewV2> createState() => _MapViewV2State();
}

class _MapViewV2State extends State<MapViewV2> {
  late MapController controller;

  @override
  void initState() {
    super.initState();
    controller = MapController.withPosition(
      initPosition: GeoPoint(
        // latitude: widget.param.latitude ?? 0.0,
        // longitude: widget.param.longitude ?? 0.0,
        latitude: -7.32149490798,
        longitude: 112.771314374,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Peta",
        isBackEnabled: true,
      ),
      body: GestureDetector(
        onTapDown: (details) {
          _buildInfoCard(
            position: details.globalPosition,
          );
        },
        child: OSMFlutter(
          controller: controller,
          mapIsLoading: buildLoadingPage(),
          initZoom: 18,
          minZoomLevel: 10,
          staticPoints: [
            StaticPositionGeoPoint(
              "position",
              const MarkerIcon(
                icon: Icon(
                  PhosphorIcons.mapPinFill,
                  color: MyColors.redBackgroundMaintenanceCard,
                  size: 150,
                ),
              ),
              [
                GeoPoint(
                  latitude: widget.param.latitude ?? 0.0,
                  longitude: widget.param.longitude ?? 0.0,
                  // latitude: -7.32149490798,
                  // longitude: 112.771314374,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _buildInfoCard({required Offset position}) {
    final Size windowSize = MediaQueryData.fromWindow(window).size;
    late Offset screenOffset =
        Offset(windowSize.width / 2, windowSize.height / 2 - 10);

    BotToast.showAttachedWidget(
      target: screenOffset,
      attachedBuilder: (cancelFunc) {
        return Container(
          width: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              20.0,
            ),
            color: MyColors.darkBlack02,
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringUtils.removeZeroWidthSpaces(
                    widget.param.titleNote ?? "Judul",
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 600,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  StringUtils.removeZeroWidthSpaces(
                    widget.param.dateTime ?? "Waktu Pemeliharaan",
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 600,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  StringUtils.removeZeroWidthSpaces(
                    widget.param.descNote ?? "Deskripsi",
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: buildTextStyle(
                    fontSize: 14,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 400,
                  ),
                )
              ],
            ),
          ),
        );
      },
      duration: const Duration(
        seconds: 5,
      ),
    );
  }
}
