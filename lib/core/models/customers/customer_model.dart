class Customer {
  Customer({
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

  String customerName;
  int customerType;
  String customerNumber;
  String email;
  String phoneNumber;
  String city;
  int dataSource;
  String note;
  String companyName;
  int? status;
}
