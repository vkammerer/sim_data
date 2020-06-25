class SimData {
  final List<SimCard> cards;
  SimData(this.cards);

  static SimData fromJson(data) {
    return new SimData(data['cards'] != null && data['cards'] is List
        ? data['cards']
            .map<SimCard>((_card) => SimCard.fromJson(_card))
            .toList()
        : []);
  }
}

class SimCard {
  final String carrierName;
  final String countryCode;
  final String displayName;
  final bool isDataRoaming;
  final bool isNetworkRoaming;
  final int mcc;
  final int mnc;
  final int slotIndex;
  final String serialNumber;
  final int subscriptionId;
  SimCard(
      this.carrierName,
      this.countryCode,
      this.displayName,
      this.isNetworkRoaming,
      this.isDataRoaming,
      this.mcc,
      this.mnc,
      this.slotIndex,
      this.serialNumber,
      this.subscriptionId);

  static SimCard fromJson(dynamic card) {
    return SimCard(
        card['carrierName'],
        card['countryCode'],
        card['displayName'],
        card['isDataRoaming'],
        card['isNetworkRoaming'],
        card['mcc'],
        card['mnc'],
        card['slotIndex'],
        card['serialNumber'],
        card['subscriptionId']);
  }
}
