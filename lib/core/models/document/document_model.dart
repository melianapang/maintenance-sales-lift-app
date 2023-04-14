String mappingCustomerFileTypeToString(int value) {
  switch (value) {
    case 0:
      return "Purchase Order";
    case 1:
      return "Quotation";
    case 2:
      return "Dokumen Perjanjian Kerja Sama";
    default:
      return "Berkas Pelanggan";
  }
}
