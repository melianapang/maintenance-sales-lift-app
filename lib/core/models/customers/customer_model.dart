class Customer {
  Customer({
    required this.customerId,
    required this.customerName,
    required this.customerType,
    required this.customerNumber,
    required this.customerNeed,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.dataSource,
    required this.note,
    required this.companyName,
    required this.status,
  });

  int customerId;
  String customerName;
  int customerType;
  String customerNumber;
  String customerNeed;
  String email;
  String phoneNumber;
  String city;
  int dataSource;
  String note;
  String companyName;
  int? status;
}

enum CustomerStatus {
  Loss,
  Win,
  Hot,
  In_Progress,
}

String mappingCustomerTypeToString(int value) {
  switch (value) {
    case 0:
      return "Individual";
    case 1:
    default:
      return "Perusahaan";
  }
}

String mappingDataSourceToString(int value) {
  switch (value) {
    case 0:
      return "Leads";
    case 1:
    default:
      return "Non-Leads";
  }
}

String mappingCustomerNeedToString(int value) {
  switch (value) {
    case 0:
      return "Pembelian Unit";
    case 1:
    default:
      return "Perawatan/Troubleshooting";
  }
}
