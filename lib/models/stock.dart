class Stock {
  final String symbol;
  final String name;

  Stock({required this.symbol, required this.name});

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
      };

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      name: json['name'],
    );
  }
}
