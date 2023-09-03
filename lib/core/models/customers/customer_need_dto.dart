import 'package:json_annotation/json_annotation.dart';

part 'customer_need_dto.g.dart';

//region get all customer need
@JsonSerializable()
class GetAllCustomerNeedResponse {
  GetAllCustomerNeedResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllCustomerNeedResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllCustomerNeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCustomerNeedResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListCustomerNeedData data;
}

@JsonSerializable()
class ListCustomerNeedData {
  ListCustomerNeedData({
    required this.totalSize,
    required this.result,
  });

  factory ListCustomerNeedData.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerNeedDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerNeedDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<CustomerNeedData> result;
}

@JsonSerializable()
class CustomerNeedData {
  CustomerNeedData({
    required this.customerNeedId,
    required this.customerNeedName,
    required this.isActive,
  });

  factory CustomerNeedData.fromJson(Map<String, dynamic> json) =>
      _$CustomerNeedDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerNeedDataToJson(this);

  @JsonKey(name: "customer_need_id")
  final String customerNeedId;

  @JsonKey(name: "customer_need_name")
  final String customerNeedName;

  @JsonKey(name: "is_active")
  final String isActive;
}
//endregion

//region create customer need
@JsonSerializable()
class CreateCustomerNeedRequest {
  CreateCustomerNeedRequest({
    required this.customerNeedName,
  });

  factory CreateCustomerNeedRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerNeedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerNeedRequestToJson(this);

  @JsonKey(name: "customer_need_name")
  final String customerNeedName;
}

@JsonSerializable()
class CreateCustomerNeedResponse {
  CreateCustomerNeedResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateCustomerNeedResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerNeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerNeedResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region delete customer type
@JsonSerializable()
class DeleteCustomerNeedResponse {
  DeleteCustomerNeedResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteCustomerNeedResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteCustomerNeedResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCustomerNeedResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion