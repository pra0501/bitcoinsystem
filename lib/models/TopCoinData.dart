class TopCoinData {
  String? diffRate;
  double? rate;
  int? bitcoinId;
  String? name;
  String? symbol;
  String? icon;

  TopCoinData({this.diffRate, this.rate, this.bitcoinId, this.name, this.symbol , this.icon});

  TopCoinData.fromJson(Map<String, dynamic> json) {
    diffRate = json['diffRate'];
    rate = json['rate'];
    bitcoinId = json['bitcoinId'];
    name = json['name'];
    symbol = json['symbol'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diffRate'] = this.diffRate;
    data['rate'] = this.rate;
    data['bitcoinId'] = this.bitcoinId;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['icon'] = this.icon;
    return data;
  }
}