import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/balance_provider.dart';
import '../providers/fund_providers.dart';
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

    final screenWidth = MediaQuery.of(context).size.width;
    
    // Diseño responsivo usando MaxCrossAxisExtent para evitar roturas
    return Scaffold(
      appBar: AppBar(
        title: const Text('BTG Pactual - Mis Fondos'),
        centerTitle: screenWidth < 600,
        actions: [
          // Botón para abrir el historial de transacciones
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historial',
            onPressed: () => _showHistory(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        // Permite recargar los datos deslizando hacia abajo
        onRefresh: () async {
          ref.invalidate(balanceProvider);
          ref.invalidate(fundsProvider);
        },
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: CustomScrollView(
              slivers: [
                // Header con saldo
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(screenWidth > 600 ? 40.0 : 24.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: screenWidth > 600 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Saldo Disponible',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        balanceAsync.when(
                          data: (balance) => Text(
                            currencyFormatter.format(balance),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth > 600 ? 48 : 32,
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
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Catálogo de Fondos',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                
                // Grid responsivo profesional
                fundsAsync.when(
                  data: (funds) => SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400, // Cada tarjeta medirá máximo 400px
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        mainAxisExtent: 160, // Altura fija suficiente para el contenido
                      ),
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
                    child: Center(child: Text('Error: $err')),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHistory(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxWidth: width > 600 ? 500 : double.infinity,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: TransactionHistoryList(),
      ),
    );
  }
}
