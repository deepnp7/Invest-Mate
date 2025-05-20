import 'package:flutter/material.dart';
import 'package:investmate/models/portfolio_item.dart';
import 'package:investmate/services/stock_service.dart';

class PortfolioProvider extends ChangeNotifier {
  final List<PortfolioItem> _portfolioItems = [];
  final Map<String, double> _livePrices = {};
  final List<double> _balanceHistory = [];

  double _virtualBalance = 10000000.0; // ₹1 Crore

  List<PortfolioItem> get portfolioItems => _portfolioItems;
  Map<String, double> get livePrices => _livePrices;
  double get virtualBalance => _virtualBalance;
  List<double> get balanceHistory => _balanceHistory;

  Future<void> fetchLivePrice(String symbol) async {
    final price = await StockService.getLivePrice(symbol);
    _livePrices[symbol] = price;
    _updateCurrentPrices();
    _recordBalance();
    notifyListeners();
  }

  void _updateCurrentPrices() {
    for (var item in _portfolioItems) {
      if (_livePrices.containsKey(item.symbol)) {
        item.currentPrice = _livePrices[item.symbol]!;
      }
    }
  }

  void _recordBalance() {
    double totalValue = _virtualBalance;
    for (var item in _portfolioItems) {
      totalValue += item.quantity * item.currentPrice;
    }
    _balanceHistory.add(totalValue);
  }

  void buyStock(String symbol, String name, int quantity, double price) {
    final totalCost = quantity * price;
    if (_virtualBalance >= totalCost) {
      final index = _portfolioItems.indexWhere((item) => item.symbol == symbol);
      if (index == -1) {
        _portfolioItems.add(PortfolioItem(
          symbol: symbol,
          name: name,
          quantity: quantity,
          buyPrice: price,
          currentPrice: price,
        ));
      } else {
        final existing = _portfolioItems[index];
        final newQty = existing.quantity + quantity;
        final newAvgPrice = ((existing.quantity * existing.buyPrice) + totalCost) / newQty;
        _portfolioItems[index] = PortfolioItem(
          symbol: symbol,
          name: name,
          quantity: newQty,
          buyPrice: newAvgPrice,
          currentPrice: price,
        );
      }
      _virtualBalance -= totalCost;
      _recordBalance();
      notifyListeners();
    }
  }

  void sellStock(String symbol, int quantity, double price) {
    final index = _portfolioItems.indexWhere((item) => item.symbol == symbol);
    if (index != -1 && _portfolioItems[index].quantity >= quantity) {
      final sellValue = quantity * price;
      _portfolioItems[index].quantity -= quantity;
      _virtualBalance += sellValue;

      if (_portfolioItems[index].quantity == 0) {
        _portfolioItems.removeAt(index);
      }
      _recordBalance();
      notifyListeners();
    }
  }
}
