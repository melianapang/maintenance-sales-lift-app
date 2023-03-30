import 'package:json_annotation/json_annotation.dart';
import 'package:rejo_jaya_sakti_apps/core/models/customers/customer_model.dart';

part 'customer_dto.g.dart';

@JsonSerializable()
class UpdateCustomerRequest {
  UpdateCustomerRequest({
    required this.customerName,
    required this.customerType,
    required this.customerNumber,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.dataSource,
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

  @JsonKey(name: "customer_number")
  final String customerNumber;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "data_source")
  final int dataSource;

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
    required this.data,
  });

  factory UpdateCustomerResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateCustomerResponseToJson(this);

  @JsonKey(name: "Success")
  final bool isSuccess;

  @JsonKey(name: "Message")
  final String message;

  @JsonKey(name: "Data")
  final List<String> data;
}

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
    required this.result,
  });

  factory ListCustomerData.fromJson(Map<String, dynamic> json) =>
      _$ListCustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$ListCustomerDataToJson(this);

  @JsonKey(name: "result")
  final List<CustomerData> result;
}

@JsonSerializable()
class CustomerData {
  CustomerData({
    required this.customerId,
    required this.customerNumber,
    required this.userId,
    required this.customerType,
    required this.customerName,
    required this.companyName,
    required this.dataSource,
    required this.city,
    required this.phoneNumber,
    required this.email,
    required this.note,
    required this.status,
    required this.statusDeleted,
    required this.createdAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) =>
      _$CustomerDataFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerDataToJson(this);

  @JsonKey(name: "customer_id")
  final String customerId;

  @JsonKey(name: "customer_number")
  final String customerNumber;

  @JsonKey(name: "user_id")
  final String userId;

  @JsonKey(name: "customer_type")
  final String customerType;

  @JsonKey(name: "customer_name")
  final String customerName;

  @JsonKey(name: "company_name")
  final String companyName;

  @JsonKey(name: "data_source")
  final String dataSource;

  @JsonKey(name: "city")
  final String city;

  @JsonKey(name: "phone_number")
  final String phoneNumber;

  @JsonKey(name: "email")
  final String email;

  @JsonKey(name: "note")
  final String note;

  @JsonKey(name: "status")
  final String status;

  @JsonKey(name: "status_deleted")
  final String statusDeleted;

  @JsonKey(name: "created_at")
  final String createdAt;
}
