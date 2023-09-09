String mappingCustomerFileTypeToString(int value) {
  switch (value) {
    case 1:
      return "Purchase Order";
    case 2:
      return "Quotation";
    case 3:
      return "Dokumen Perjanjian Kerja Sama";
    case 4:
    default:
      return "Lainnya";
  }
}

enum DocumentType {
  FollowUp,
  PO,
  Quotation,
  Kwitansi,
}
