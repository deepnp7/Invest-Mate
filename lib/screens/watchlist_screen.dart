import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watchlist_provider.dart';
import '../providers/portfolio_provider.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final watchlist = context.watch<WatchlistProvider>().watchlist;
    final livePrices = context.watch<PortfolioProvider>().livePrices;

    return ListView.builder(
      itemCount: watchlist.length,
      itemBuilder: (context, index) {
        final symbol = watchlist[index];
        final price = livePrices[symbol]?.toStringAsFixed(2) ?? 'Loading...';

        return ListTile(
          title: Text(symbol),
          subtitle: Text('₹ $price'),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              context.read<WatchlistProvider>().removeFromWatchlist(symbol);
            },
          ),
        );
      },
    );
  }
}
