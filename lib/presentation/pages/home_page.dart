import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/balance_provider.dart';
import '../providers/fund_providers.dart';
import '../providers/history_provider.dart';
import '../widgets/fund_card.dart';
import '../widgets/transaction_history_list.dart';

/// Página principal de la aplicación que muestra el saldo del usuario y el catálogo de fondos.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha de los estados globales necesarios para la UI
    final balanceAsync = ref.watch(balanceProvider);
    final fundsAsync = ref.watch(fundsProvider);
    
    // Formateador de moneda para pesos colombianos
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG Pactual - Mis Fondos'),
        actions: [
          // Botón para abrir el historial de transacciones
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
        // Permite recargar los datos deslizando hacia abajo
        onRefresh: () async {
          ref.invalidate(balanceProvider);
          ref.invalidate(fundsProvider);
        },
        child: CustomScrollView(
          slivers: [
            // Cabecera con el saldo actual del usuario
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
            
            // Título de la sección de fondos
            const SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Catálogo de Fondos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            // Lista dinámica de fondos disponibles
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
