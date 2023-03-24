import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineData {
  const TimelineData({
    required this.date,
    required this.note,
    this.onTap,
  });

  final String date;
  final String note;
  final VoidCallback? onTap;
}

class TimelineWidget extends StatelessWidget {
  const TimelineWidget({
    required this.listTimeline,
    super.key,
  });

  final List<TimelineData> listTimeline;

  Widget _buildTimelineHead(TimelineData data) {
    return TimelineTile(
      indicatorStyle: const IndicatorStyle(
        width: 14,
        height: 14,
        color: MyColors.yellow01,
      ),
      afterLineStyle: const LineStyle(
        thickness: 1,
        color: MyColors.yellow01,
      ),
      alignment: TimelineAlign.start,
      lineXY: 0.2,
      isFirst: true,
      endChild: _buildTimelineInfo(data),
    );
  }

  Widget _buildTimeline(TimelineData data) {
    return TimelineTile(
      indicatorStyle: const IndicatorStyle(
        width: 14,
        height: 14,
        color: MyColors.yellow01,
      ),
      beforeLineStyle: const LineStyle(
        thickness: 1,
        color: MyColors.yellow01,
      ),
      afterLineStyle: const LineStyle(
        thickness: 1,
        color: MyColors.yellow01,
      ),
      alignment: TimelineAlign.start,
      lineXY: 0.2,
      endChild: _buildTimelineInfo(data),
    );
  }

  Widget _buildTimelineTail(TimelineData data) {
    return TimelineTile(
      indicatorStyle: const IndicatorStyle(
        width: 14,
        height: 14,
        color: MyColors.yellow01,
      ),
      beforeLineStyle: const LineStyle(
        thickness: 1,
        color: MyColors.yellow01,
      ),
      alignment: TimelineAlign.start,
      lineXY: 0.2,
      isLast: true,
      endChild: _buildTimelineInfo(data),
    );
  }

  Widget _buildTimelineInfo(TimelineData data) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Spacings.vert(19),
          Text(
            data.date,
            style: buildTextStyle(
              fontSize: 16,
              fontWeight: 400,
              fontColor: MyColors.white,
            ),
          ),
          Spacings.vert(2),
          Text(
            'Hasil: ${data.note}',
            style: buildTextStyle(
              fontSize: 16,
              fontWeight: 700,
              fontColor: MyColors.lightBlack02,
            ),
          ),
          Spacings.vert(2),
          GestureDetector(
            onTap: data.onTap,
            child: Text(
              'Lihat selengkapnya',
              style: buildTextStyle(
                fontSize: 12,
                fontWeight: 400,
                fontColor: MyColors.blueLihatSelengkapnya,
                isUnderlined: true,
              ),
            ),
          ),
          Spacings.vert(19),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTimelineWidget = [];
    for (int i = 0; i < listTimeline.length; i++) {
      if (i == 0) {
        listTimelineWidget.add(_buildTimelineHead(listTimeline[i]));
      } else if (i > 0 && i != listTimeline.length - 1) {
        listTimelineWidget.add(_buildTimeline(listTimeline[i]));
      } else if (i == listTimeline.length - 1) {
        listTimelineWidget.add(_buildTimelineTail(listTimeline[i]));
      }
      ;
    }

    return Column(
      children: listTimelineWidget,
    );
  }
}
