import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/history_provider.dart';

/// Widget que visualiza el historial de movimientos del usuario.
/// Se muestra usualmente dentro de un ModalBottomSheet para mayor fluidez.
class TransactionHistoryList extends ConsumerWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el provider del historial para reaccionar a cambios en las transacciones.
    final historyAsync = ref.watch(historyProvider);
    
    // Formateadores para moneda local y fechas legibles.
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          // Indicador visual de arrastre (handle) para el BottomSheet.
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Historial de Transacciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          
          Expanded(
            child: historyAsync.when(
              data: (transactions) {
                // Estado: No hay datos registrados.
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('No hay transacciones registradas todavía.'),
                  );
                }
                
                // Lista de transacciones con separadores.
                return ListView.separated(
                  itemCount: transactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isSubscription = tx.type == TransactionType.subscription;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSubscription 
                            ? Colors.blue.withValues(alpha: 0.1) 
                            : Colors.green.withValues(alpha: 0.1),
                        child: Icon(
                          isSubscription ? Icons.add_circle_outline : Icons.remove_circle_outline,
                          color: isSubscription ? Colors.blue : Colors.green,
                        ),
                      ),
                      title: Text(tx.fundName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateFormatter.format(tx.date)),
                          // Muestra el método de notificación seleccionado por el usuario.
                          if (tx.notificationMethod != NotificationMethod.none)
                            Text('Aviso por: ${tx.notificationMethod.name.toUpperCase()}', 
                                 style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                      trailing: Text(
                        // Muestra el monto con signo negativo para salidas y positivo para entradas.
                        '${isSubscription ? '-' : '+'}${currencyFormatter.format(tx.amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSubscription ? Colors.red : Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
              // Estado de carga inicial.
              loading: () => const Center(child: CircularProgressIndicator()),
              // Estado de error en la recuperación de datos.
              error: (err, _) => Center(child: Text('Error al cargar historial: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
