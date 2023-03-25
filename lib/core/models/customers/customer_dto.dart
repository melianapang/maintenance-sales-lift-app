import 'package:json_annotation/json_annotation.dart';

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
