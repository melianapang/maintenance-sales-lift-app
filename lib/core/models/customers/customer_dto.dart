import 'package:json_annotation/json_annotation.dart';

part 'customer_dto.g.dart';

//region update customer
@JsonSerializable()
class UpdateCustomerRequest {
  UpdateCustomerRequest({
    required this.customerName,
    required this.customerType,
    required this.customerNeed,
    required this.dataSource,
    required this.isLead,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.note,
    required this.companyName,
    required this.status,
  });

  factory UpdateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCustomerRequestToJson(this);

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "customer_type")
  final int customerType;

  @JsonKey(name: "customer_need")
  final String customerNeed;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "is_lead")
  final int isLead;

  @JsonKey(name: "data_source")
  final String dataSource;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "company_name")
  final String companyName;

  @JsonKey(name: "status")
  final int status;
}

@JsonSerializable()
class UpdateCustomerResponse {
  UpdateCustomerResponse({
    required this.isSuccess,
    required this.message,
  });

  factory UpdateCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get all customer
@JsonSerializable()
class GetAllCustomerResponse {
  GetAllCustomerResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetAllCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAllCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final ListCustomerData data;
}

@JsonSerializable()
class ListCustomerData {
  ListCustomerData({
    required this.totalSize,
    required this.result,
  });

  factory ListCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerDataToJson(this);

  @JsonKey(name: "total_size")
  final String totalSize;

  @JsonKey(name: "result")
  final List<CustomerData> result;
}

@JsonSerializable()
class CustomerData {
  CustomerData({
    required this.customerId,
    required this.customerNumber,
    required this.customerType,
    required this.customerName,
    this.companyName,
    required this.customerNeed,
    required this.city,
    required this.phoneNumber,
    required this.email,
    required this.status,
    required this.isLead,
    required this.dataSource,
    required this.salesOwnedId,
    this.note,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_number")
  final String customerNumber;

  @JsonKey(name: "customer_type")
  final String customerType;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String? companyName;

  @JsonKey(name: "customer_need")
  final String customerNeed;

  @JsonKey(name: "is_lead")
  final String isLead;

  @JsonKey(name: "data_source")
  final String dataSource;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "note")
  final String? note;

  @JsonKey(name: "sales_owned_id")
  final String salesOwnedId;

  @JsonKey(name: "status")
  final String status;
}
//endregion

//region create customer
@JsonSerializable()
class CreateCustomerRequest {
  CreateCustomerRequest({
    required this.customerName,
    required this.customerType,
    required this.customerNeed,
    required this.isLead,
    required this.dataSource,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.note,
    required this.companyName,
    required this.status,
  });

  factory CreateCustomerRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerRequestToJson(this);

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "customer_type")
  final int customerType;

  @JsonKey(name: "customer_need")
  final String customerNeed;

  @JsonKey(name: "is_lead")
  final String isLead;

  @JsonKey(name: "data_source")
  final String dataSource;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "company_name")
  final String companyName;

  @JsonKey(name: "status")
  final int status;
}

@JsonSerializable()
class CreateCustomerResponse {
  CreateCustomerResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory CreateCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final CreateCustomerDataResponse data;
}

@JsonSerializable()
class CreateCustomerDataResponse {
  CreateCustomerDataResponse({
    required this.customerData,
  });

  factory CreateCustomerDataResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCustomerDataResponseToJson(this);

  @JsonKey(name: "customer")
  final CustomerData customerData;
}
//endregion

//region delete user
@JsonSerializable()
class DeleteCustomerResponse {
  DeleteCustomerResponse({
    required this.isSuccess,
    required this.message,
  });

  factory DeleteCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;
}
//endregion

//region get detail customer
@JsonSerializable()
class GetDetailCustomerResponse {
  GetDetailCustomerResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory GetDetailCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$GetDetailCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetDetailCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final CustomerData data;
}
//endregion
