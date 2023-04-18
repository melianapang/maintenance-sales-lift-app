import 'package:json_annotation/json_annotation.dart';

part 'reminder_dto.g.dart';

//region create reminder
@JsonSerializable()
class CreateReminderRequest {
  CreateReminderRequest({
    required this.customerId,
    required this.reminderType,
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    required this.remindedNote,
    required this.afterRemindedNote,
  });

  factory CreateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderRequestToJson(this);

  @JsonKey(name: "custemer_id")
  final int customerId;

  @JsonKey(name: "reminder_type")
  final String reminderType;

  @JsonKey(name: "reminder_date")
  final String reminderDate;

  @JsonKey(name: "reminder_time")
  final String reminderTime;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "reminded_note")
  final String remindedNote;

  @JsonKey(name: "after_reminded_note")
  final String afterRemindedNote;
}

@JsonSerializable()
class CreateReminderResponse {
  CreateReminderResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get all reminder
@JsonSerializable()
class GetAllReminderResponse {
  GetAllReminderResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllReminderResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListReminderData data;
}

@JsonSerializable()
class ListReminderData {
  ListReminderData({
    required this.totalSize,
    required this.result,
  });

  factory ListReminderData.fromJson(Map<String, dynamic> json) =>
      _$ListReminderDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListReminderDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<ReminderData> result;
}

@JsonSerializable()
class ReminderData {
  ReminderData({
    required this.reminderId,
    required this.userName,
    required this.customerName,
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    required this.remindedNote,
    required this.afterRemindedNote,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) =>
      _$ReminderDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderDataToJson(this);

  @JsonKey(name: "reminder_id")
  final String reminderId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "custemer_name")
  final String customerName;

  @JsonKey(name: "reminder_date")
  final String reminderDate;

  @JsonKey(name: "reminder_time")
  final String reminderTime;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "reminded_note")
  final String remindedNote;

  @JsonKey(name: "after_reminded_note")
  final String afterRemindedNote;
}
//endregion

//region delete reminder
@JsonSerializable()
class DeleteReminderResponse {
  DeleteReminderResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteReminderResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region update reminder
@JsonSerializable()
class UpdateReminderRequest {
  UpdateReminderRequest({
    required this.reminderType,
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    required this.remindedNote,
    required this.afterRemindedNote,
  });

  factory UpdateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReminderRequestToJson(this);

  @JsonKey(name: "reminder_type")
  final String reminderType;

  @JsonKey(name: "reminder_date")
  final String reminderDate;

  @JsonKey(name: "reminder_time")
  final String reminderTime;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "reminded_note")
  final String remindedNote;

  @JsonKey(name: "after_reminded_note")
  final String afterRemindedNote;
}

@JsonSerializable()
class UpdateReminderResponse {
  UpdateReminderResponse({
    required this.isSuccess,
    required this.message,
  });

  factory UpdateReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReminderResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get reminder detail
@JsonSerializable()
class ReminderDetailResponse {
  ReminderDetailResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ReminderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ReminderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderDetailResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ReminderData data;
}
//endregion