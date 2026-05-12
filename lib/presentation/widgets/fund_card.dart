import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/fund_providers.dart';
import 'subscription_form.dart';

/// Tarjeta visual que representa un fondo individual en el catálogo.
/// Permite al usuario ver detalles básicos y realizar acciones de vinculación/desvinculación.
class FundCard extends ConsumerWidget {
  final Fund fund;

  const FundCard({super.key, required this.fund});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fund.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Categoría: ${fund.category.name.toUpperCase()}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  currencyFormatter.format(fund.minimumAmount),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ],
            ),
            const Divider(height: 24),
            SizedBox(
              width: double.infinity,
              child: fund.isSubscribed
                  ? OutlinedButton(
                      onPressed: () => _showCancelConfirmation(context, ref),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Desvincularse'),
                    )
                  : ElevatedButton(
                      onPressed: () => _showSubscriptionDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Vincularse'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Muestra el diálogo que contiene el formulario de suscripción y validación.
  void _showSubscriptionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Suscripción a ${fund.name}'),
        content: SingleChildScrollView(
          child: SubscriptionForm(
            minimumAmount: fund.minimumAmount,
            onConfirm: (method, contact) {
              _subscribe(context, ref, method);
            },
          ),
        ),
      ),
    );
  }

  /// Ejecuta la suscripción delegando la lógica al notifier de fondos.
  /// Maneja la respuesta visual (éxito o error) mediante SnackBars.
  Future<void> _subscribe(BuildContext context, WidgetRef ref, NotificationMethod method) async {
    Navigator.of(context).pop(); // Cierra el diálogo de formulario
    try {
      await ref.read(fundsProvider.notifier).subscribe(fund, method);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Suscripción exitosa a ${fund.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Muestra un diálogo de confirmación antes de proceder con la desvinculación.
  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desvincularse'),
        content: Text('¿Está seguro que desea desvincularse de ${fund.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(fundsProvider.notifier).cancelSubscription(fund);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Se ha desvinculado de ${fund.name}')),
                );
              }
            },
            child: const Text('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
