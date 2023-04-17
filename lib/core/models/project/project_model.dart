String mappingProjectNeedTypeToString(int value) {
  switch (value) {
    case 0:
      return "Lift";
    case 1:
      return "Elevator";
    case 2:
      return "Lift dan Elevator";
    case 3:
    default:
      return "Lainnya";
  }
}

enum ProjectNeedStatus { Lift, Elevator, LiftAndElevator, Others }
