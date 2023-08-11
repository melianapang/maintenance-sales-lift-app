String? mappingJenisUnit(String? value) {
  if (value == null) return null;

  switch (value) {
    case "1":
      return "MRL";
    case "2":
    default:
      return "MR";
  }
}

String? mappingTipeUnit(String? value) {
  if (value == null) return null;

  switch (value) {
    case "0":
      return "Lift Barang";
    case "1":
      return "Lift Penumpang";
    case "2":
      return "Dumbwaiter";
    case "3":
      return "Escalator";
    case "4":
      return "Lift Hydraulic";
    case "5":
      return "Lift Traction Backpack";
    case "6":
    default:
      return "Lain-Lain";
  }
}
