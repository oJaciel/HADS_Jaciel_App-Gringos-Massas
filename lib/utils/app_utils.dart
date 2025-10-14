import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AppUtils {
  static String formatPrice(double price) {
    return toCurrencyString(
      price.toStringAsFixed(2),
      leadingSymbol: 'R\$ ',
      thousandSeparator: ThousandSeparator.Period,
      mantissaLength: 2,
    );
  }

  static double parsePrice(String price) {
    return double.tryParse(
          price
              .replaceAll('R\$ ', '') // remove o símbolo
              .replaceAll('.', '') // remove pontos dos milhares
              .replaceAll(',', '.'), // transforma vírgula em ponto decimal
        ) ??
        0.0;
  }

  static getPaymentName(PaymentMethod method) {
    if (method == PaymentMethod.Cash) {
      return 'Dinheiro';
    } else if (method == PaymentMethod.CreditCard) {
      return 'Cartão de Crédito';
    } else if (method == PaymentMethod.Pix) {
      return 'Pix';
    }
  }

  static getPaymentIcon(PaymentMethod method) {
    if (method == PaymentMethod.Cash) {
      return Icons.attach_money_rounded;
    } else if (method == PaymentMethod.CreditCard) {
      return Icons.payment_rounded;
    } else if (method == PaymentMethod.Pix) {
      return Icons.pix_rounded;
    }
  }
}
