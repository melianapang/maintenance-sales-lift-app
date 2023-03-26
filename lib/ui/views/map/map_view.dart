import 'package:bot_toast/bot_toast.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late AnchorPos<dynamic> anchorPos;
  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    anchorPos = AnchorPos.align(AnchorAlign.center);
  }

  void _setAnchorAlignPos(AnchorAlign alignOpt) {
    setState(() {
      anchorPos = AnchorPos.align(alignOpt);
    });
  }

  void _setAnchorExactlyPos(Anchor anchor) {
    setState(() {
      anchorPos = AnchorPos.exactly(anchor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[
      Marker(
        width: 40,
        height: 40,
        point: LatLng(-7.250445, 112.768845),
        builder: (ctx) => GestureDetector(
          onTapDown: (details) {
            _buildInfoCard(
              position: details.globalPosition,
            );
          },
          child: const Icon(
            PhosphorIcons.mapPinFill,
            color: MyColors.darkBlack02,
            size: 42,
          ),
        ),
        anchorPos: anchorPos,
      ),
    ];

    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Peta",
        isBackEnabled: true,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(-7.250445, 112.768845),
          zoom: 13,
          maxZoom: 19,
          interactiveFlags: InteractiveFlag.all,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: [
          // TileLayer(
          //   wmsOptions: WMSTileLayerOptions(
          //     baseUrl: 'https://{s}.s2maps-tiles.eu/wms/?',
          //     layers: ['s2cloudless-2018_3857'],
          //   ),
          //   subdomains: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
          //   userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          // ),
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }

  void _buildInfoCard({required Offset position}) {
    BotToast.showAttachedWidget(
      target: Offset(position.dx, position.dy - 50),
      attachedBuilder: (cancelFunc) {
        return Container(
          height: 100,
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
              children: [
                Text(
                  'title',
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 600,
                  ),
                ),
                Spacings.vert(6),
                Text(
                  "descriptiondescription",
                  style: buildTextStyle(
                    fontSize: 16,
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
