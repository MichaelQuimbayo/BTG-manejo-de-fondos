import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';

/// Formulario interactivo para la suscripción a un fondo.
/// Incluye validaciones de entrada y manejo de estado para el método de notificación.
class SubscriptionForm extends StatefulWidget {
  final Function(NotificationMethod method, String contact) onConfirm;
  final double minimumAmount;

  const SubscriptionForm({
    super.key,
    required this.onConfirm,
    required this.minimumAmount,
  });

  @override
  State<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends State<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  NotificationMethod _selectedMethod = NotificationMethod.email;
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }

    if (_selectedMethod == NotificationMethod.email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Ingrese un correo electrónico válido';
      }
    } else if (_selectedMethod == NotificationMethod.sms) {
      final phoneRegex = RegExp(r'^\d{10}$');
      if (!phoneRegex.hasMatch(value)) {
        return 'Ingrese un número de teléfono válido (10 dígitos)';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Método de notificación:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<NotificationMethod>(
            value: _selectedMethod,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: const [
              DropdownMenuItem(
                value: NotificationMethod.email,
                child: Text('Correo electrónico'),
              ),
              DropdownMenuItem(
                value: NotificationMethod.sms,
                child: Text('SMS (Teléfono)'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedMethod = value;
                  _contactController.clear();
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _contactController,
            decoration: InputDecoration(
              labelText: _selectedMethod == NotificationMethod.email
                  ? 'Correo electrónico'
                  : 'Número de celular',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                _selectedMethod == NotificationMethod.email
                    ? Icons.email_outlined
                    : Icons.phone_android_outlined,
              ),
            ),
            keyboardType: _selectedMethod == NotificationMethod.email
                ? TextInputType.emailAddress
                : TextInputType.phone,
            validator: _validateContact,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onConfirm(_selectedMethod, _contactController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirmar Suscripción'),
            ),
          ),
        ],
      ),
    );
  }
}
