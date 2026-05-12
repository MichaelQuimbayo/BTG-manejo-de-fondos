import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/fund_providers.dart';
import 'subscription_form.dart';

/// Tarjeta visual optimizada para cualquier tamaño de pantalla.
/// Se ha rediseñado para evitar desbordamientos y adaptarse a rejillas dinámicas.
class FundCard extends ConsumerWidget {
  final Fund fund;

  const FundCard({super.key, required this.fund});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormatter = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección superior: Nombre y Precio
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    fund.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  currencyFormatter.format(fund.minimumAmount),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Categoría
            Text(
              'Categoría: ${fund.category.name.toUpperCase()}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const Spacer(), // Empuja el botón hacia la parte inferior de la tarjeta
            
            // Botón de acción
            SizedBox(
              width: double.infinity,
              height: 40,
              child: fund.isSubscribed
                  ? OutlinedButton(
                      onPressed: () => _showCancelConfirmation(context, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Desvincularse',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => _showSubscriptionDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Vincularse',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

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

  Future<void> _subscribe(BuildContext context, WidgetRef ref, NotificationMethod method) async {
    Navigator.of(context).pop();
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
