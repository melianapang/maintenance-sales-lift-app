import 'package:json_annotation/json_annotation.dart';

part 'reminder_dto.g.dart';

//region create reminder
@JsonSerializable()
class CreateReminderRequest {
  CreateReminderRequest({
    this.customerId,
    this.maintenanceId,
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    this.remindedNote,
    this.afterRemindedNote,
  });

  factory CreateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderRequestToJson(this);

  @JsonKey(name: "customer_id")
  final int? customerId;

  @JsonKey(name: "maintenance_id")
  final String? maintenanceId;

  @JsonKey(name: "reminder_date")
  final String reminderDate;

  @JsonKey(name: "reminder_time")
  final String reminderTime;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "reminded_note")
  final String? remindedNote;

  @JsonKey(name: "after_reminded_note")
  final String? afterRemindedNote;
}

@JsonSerializable()
class CreateReminderResponse {
  CreateReminderResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CreateReminderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReminderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReminderResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final CreatedReminderIdResponse data;
}

@JsonSerializable()
class CreatedReminderIdResponse {
  CreatedReminderIdResponse({
    required this.reminderId,
  });

  factory CreatedReminderIdResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedReminderIdResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedReminderIdResponseToJson(this);

  @JsonKey(name: "reminder_id")
  final int reminderId;
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
    required this.maintenanceId,
    required this.customerId,
    required this.customerName,
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    required this.remindedNote,
    required this.afterReminderNote,
  });

  factory ReminderData.fromJson(Map<String, dynamic> json) =>
      _$ReminderDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderDataToJson(this);

  @JsonKey(name: "reminder_id")
  final String reminderId;

  @JsonKey(name: "user_name")
  final String userName;

  @JsonKey(name: "maintenance_id")
  final String? maintenanceId;

  @JsonKey(name: "customer_id")
  final String? customerId;

  @JsonKey(name: "customer_name")
  final String? customerName;

  @JsonKey(name: "reminder_date")
  final String reminderDate;

  @JsonKey(name: "reminder_time")
  final String reminderTime;

  @JsonKey(name: "description")
  final String description;

  @JsonKey(name: "reminded_note")
  final String? remindedNote;

  @JsonKey(name: "after_reminded_note")
  final String? afterReminderNote;
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
    required this.reminderDate,
    required this.reminderTime,
    required this.description,
    required this.remindedNote,
    required this.afterRemindedNote,
  });

  factory UpdateReminderRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReminderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateReminderRequestToJson(this);

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