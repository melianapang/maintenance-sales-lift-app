import 'package:json_annotation/json_annotation.dart';

part 'customer_type_dto.g.dart';

//region get all customer type
@JsonSerializable()
class GetAllCustomerTypeResponse {
  GetAllCustomerTypeResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllCustomerTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllCustomerTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCustomerTypeResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListCustomerTypeData data;
}

@JsonSerializable()
class ListCustomerTypeData {
  ListCustomerTypeData({
    required this.totalSize,
    required this.result,
  });

  factory ListCustomerTypeData.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerTypeDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<CustomerTypeData> result;
}

@JsonSerializable()
class CustomerTypeData {
  CustomerTypeData({
    required this.customerTypeId,
    required this.customerTypeName,
    required this.isActive,
  });

  factory CustomerTypeData.fromJson(Map<String, dynamic> json) =>
      _$CustomerTypeDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerTypeDataToJson(this);

  @JsonKey(name: "customer_type_id")
  final String customerTypeId;

  @JsonKey(name: "customer_type_name")
  final String customerTypeName;

  @JsonKey(name: "is_active")
  final String isActive;
}
//endregion

//region create customer type
@JsonSerializable()
class CreateCustomerTypeRequest {
  CreateCustomerTypeRequest({
    required this.customerTypeName,
  });

  factory CreateCustomerTypeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerTypeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerTypeRequestToJson(this);

  @JsonKey(name: "customer_type_name")
  final String customerTypeName;
}

@JsonSerializable()
class CreateCustomerTypeResponse {
  CreateCustomerTypeResponse({
    required this.isSuccess,
    required this.message,
  });

  factory CreateCustomerTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerTypeResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region delete customer type
@JsonSerializable()
class DeleteCustomerTypeResponse {
  DeleteCustomerTypeResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteCustomerTypeResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteCustomerTypeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCustomerTypeResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion