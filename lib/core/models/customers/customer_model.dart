class Customer {
  Customer({
    required this.customerName,
    required this.customerType,
    required this.customerNumber,
    required this.email,
    this.phoneNumber,
    this.city,
    this.dataSource = DataSource.Leads,
    this.note,
    this.companyName,
    this.status,
  });

  final String customerName;
  final int customerType;
  final String customerNumber;
  final String email;
  final String? phoneNumber;
  final String? city;
  final DataSource dataSource;
  final String? note;
  final String? companyName;
  final int? status;
}

enum DataSource {
  Leads,
  NonLeads,
}
