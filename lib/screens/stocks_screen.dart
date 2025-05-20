import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../providers/watchlist_provider.dart';

class StocksScreen extends StatefulWidget {
  const StocksScreen({super.key});

  @override
  State<StocksScreen> createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _searchedSymbol;
  bool _isLoading = false;
  String? _error;

  Future<void> _searchStock(String symbol, PortfolioProvider provider) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _searchedSymbol = symbol;
    });

    try {
      await provider.fetchLivePrice(symbol);
      if (provider.livePrices[symbol] == null ||
          provider.livePrices[symbol]! <= 0) {
        throw Exception("Invalid or unavailable stock price");
      }
    } catch (e) {
      setState(() {
        _error = "Failed to load stock data. Please check the symbol.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = context.watch<PortfolioProvider>();
    final watchlistProvider = context.watch<WatchlistProvider>();
    final price = _searchedSymbol != null
        ? portfolioProvider.livePrices[_searchedSymbol!]
        : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40), // Pushes the search bar down
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Search Stock (e.g., INFY)',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) =>
                _searchStock(value.toUpperCase(), portfolioProvider),
          ),
          const SizedBox(height: 30),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(_error!, style: const TextStyle(color: Colors.red))
          else if (_searchedSymbol != null && price != null)
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Symbol: $_searchedSymbol',
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text('Live Price: ₹${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            portfolioProvider.buyStock(
                              _searchedSymbol!,
                              _searchedSymbol!, // Using symbol as placeholder for name
                              1,
                              price,
                            );
                          },
                          child: const Text('Buy 1'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            portfolioProvider.sellStock(
                              _searchedSymbol!,
                              1,
                              price,
                            );
                          },
                          child: const Text('Sell 1'),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.bookmark_add),
                          onPressed: () {
                            watchlistProvider.addToWatchlist(_searchedSymbol!);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
