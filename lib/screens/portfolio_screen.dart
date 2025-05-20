import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PortfolioProvider>(context);
    final items = provider.portfolioItems;
    final balance = provider.virtualBalance;

    return Scaffold(
      appBar: AppBar(title: const Text('Your Portfolio')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Balance", style: TextStyle(fontSize: 18)),
                Text("₹${balance.toStringAsFixed(2)}",
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text("No holdings yet"))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final livePrice = provider.livePrices[item.symbol] ?? item.currentPrice;
                      return ListTile(
                        title: Text(item.symbol),
                        subtitle: Text(
                            "Qty: ${item.quantity}, Avg Price: ₹${item.avgPrice.toStringAsFixed(2)}"),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("₹${(item.quantity * livePrice).toStringAsFixed(2)}"),
                            Text("Live: ₹${livePrice.toStringAsFixed(2)}",
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
//   }
// }
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: items.length,