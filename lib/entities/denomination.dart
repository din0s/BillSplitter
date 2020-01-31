enum Denomination {
  CENT_10,
  CENT_20,
  CENT_50,
  EURO_1,
  EURO_2,
  EURO_5,
  EURO_10,
  EURO_20,
}

double denomModifier(Denomination denom) {
  switch (denom) {
    case Denomination.CENT_10:
      return 0.1;
    case Denomination.CENT_20:
      return 0.2;
    case Denomination.CENT_50:
      return 0.5;
    case Denomination.EURO_1:
      return 1;
    case Denomination.EURO_2:
      return 2;
    case Denomination.EURO_5:
      return 5;
    case Denomination.EURO_10:
      return 10;
    case Denomination.EURO_20:
      return 20;
    default:
      return 0;
  }
}

String denomLabel(Denomination denom) {
  switch (denom) {
    case Denomination.CENT_10:
      return "10c";
    case Denomination.CENT_20:
      return "20c";
    case Denomination.CENT_50:
      return "50c";
    case Denomination.EURO_1:
      return "1e";
    case Denomination.EURO_2:
      return "2e";
    case Denomination.EURO_5:
      return "2e";
    case Denomination.EURO_10:
      return "10e";
    case Denomination.EURO_20:
      return "20e";
    default:
      return "";
  }
}
