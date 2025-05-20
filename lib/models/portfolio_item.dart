class PortfolioItem {
  final String symbol;
  final String name;
  int quantity;
  final double buyPrice;
  double currentPrice;

  PortfolioItem({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.buyPrice,
    required this.currentPrice,
  });

  double get avgPrice => buyPrice;
}
