String mappingCustomerFileTypeToString(int value) {
  switch (value) {
    case 1:
      return "Purchase Order";
    case 2:
      return "Quotation";
    case 3:
      return "Dokumen Perjanjian Kerja Sama/Kwitansi";
    case 4:
      return "Konfirmasi";
    default:
      return "Berkas Pelanggan";
  }
}

enum DocumentType {
  FollowUp,
  PO,
  Quotation,
  Kwitansi,
}
