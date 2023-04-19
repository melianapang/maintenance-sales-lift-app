String mappingFollowUpStringNumericToString(String value) {
  switch (value) {
    case "0":
      return "Loss";
    case "1":
      return "Win";
    case "2":
      return "Hot";
    case "3":
    default:
      return "In Progress";
  }
}
