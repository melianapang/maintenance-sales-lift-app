import 'package:json_annotation/json_annotation.dart';

part 'local_push_notif_payload.g.dart';

@JsonSerializable()
class LocalPushNotifPayload {
  LocalPushNotifPayload({
    required this.date,
    required this.time,
    required this.description,
    required this.note,
    required this.reminderId,
  });

  factory LocalPushNotifPayload.fromJson(Map<String, dynamic> json) =>
      _$LocalPushNotifPayloadFromJson(json);

  Map<String, dynamic> toJson() => _$LocalPushNotifPayloadToJson(this);

  String date;
  String time;
  String description;
  String note;
  String reminderId;
}
