import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/models/project/project_dto.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/string_utils.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/app_bars.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class ProjectLocationViewParam {
  ProjectLocationViewParam({
    this.projectData,
  });

  final ProjectData? projectData;
}

class ProjectLocationView extends StatefulWidget {
  const ProjectLocationView({
    required this.param,
    super.key,
  });

  final ProjectLocationViewParam param;

  @override
  State<ProjectLocationView> createState() => _ProjectLocationViewState();
}

class _ProjectLocationViewState extends State<ProjectLocationView> {
  late AnchorPos<dynamic> anchorPos;
  final mapController = MapController();
  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    anchorPos = AnchorPos.align(AnchorAlign.center);
    markers.add(
      Marker(
        width: 40,
        height: 40,
        point: LatLng(
          double.tryParse(widget.param.projectData?.latitude ?? "0.0") ?? 0.0,
          double.tryParse(widget.param.projectData?.longitude ?? "0.0") ?? 0.0,
        ),
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
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        context,
        title: "Peta Lokasi Proyek",
        isBackEnabled: true,
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          // center: LatLng(-7.250445, 112.768845),
          center: LatLng(
            double.tryParse(widget.param.projectData?.latitude ?? "0.0") ?? 0.0,
            double.tryParse(widget.param.projectData?.longitude ?? "0.0") ??
                0.0,
          ),
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
                  StringUtils.removeZeroWidthSpaces(
                    widget.param.projectData?.projectName ?? "Nama Proyek",
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
                    widget.param.projectData?.address ?? "Alamat Proyek",
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: buildTextStyle(
                    fontSize: 16,
                    fontColor: MyColors.lightBlack02,
                    fontWeight: 600,
                  ),
                ),
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
