import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction_entity.dart';
import '../providers/fund_providers.dart';

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
                      onPressed: () => _showNotificationPicker(context, ref),
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

  void _showNotificationPicker(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notificación'),
        content: const Text('¿Cómo desea recibir la notificación de su vinculación?'),
        actions: [
          TextButton(
            onPressed: () => _subscribe(context, ref, NotificationMethod.email),
            child: const Text('Email'),
          ),
          TextButton(
            onPressed: () => _subscribe(context, ref, NotificationMethod.sms),
            child: const Text('SMS'),
          ),
        ],
      ),
    );
  }

  Future<void> _subscribe(BuildContext context, WidgetRef ref, NotificationMethod method) async {
    Navigator.of(context).pop(); // Cierra el diálogo
    try {
      await ref.read(fundsProvider.notifier).subscribe(fund, method);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suscripción exitosa a ${fund.name}')),
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
