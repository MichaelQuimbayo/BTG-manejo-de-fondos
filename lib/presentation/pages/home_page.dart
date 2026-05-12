import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/balance_provider.dart';
import '../providers/fund_providers.dart';
import '../providers/history_provider.dart';
import '../widgets/fund_card.dart';
import '../widgets/transaction_history_list.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    final fundsAsync = ref.watch(fundsProvider);
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG Pactual - Mis Fondos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) => const FractionallySizedBox(
                  heightFactor: 0.8,
                  child: TransactionHistoryList(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(balanceProvider);
          ref.invalidate(fundsProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Saldo Disponible',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    balanceAsync.when(
                      data: (balance) => Text(
                        currencyFormatter.format(balance),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      loading: () => const CircularProgressIndicator(color: Colors.white),
                      error: (err, _) => Text('Error: $err', style: const TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Catálogo de Fondos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            fundsAsync.when(
              data: (funds) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => FundCard(fund: funds[index]),
                    childCount: funds.length,
                  ),
                ),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('Error al cargar fondos: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
