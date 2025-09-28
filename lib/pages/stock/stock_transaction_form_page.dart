import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockTransactionFormPage extends StatefulWidget {
  const StockTransactionFormPage({super.key});

  @override
  State<StockTransactionFormPage> createState() => _StockTransactionState();
}

class _StockTransactionState extends State<StockTransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  Product? _selectedProduct;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submitForm(TransactionType transactionType) {
    // Validações do formulário
    if (!_formKey.currentState!.validate()) return;

    final qty = int.tryParse(_quantityController.text);

    final productProvider = context.read<ProductProvider>();

    context.read<StockProvider>().addTransaction(
      productProvider,
      _selectedProduct!,
      qty!,
      transactionType,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final transactionType =
        ModalRoute.of(context)!.settings.arguments as TransactionType;

    final productList = context.watch<ProductProvider>().products;

    return Scaffold(
      appBar: AppBar(title: const Text('Transação de Estoque')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                transactionType == TransactionType.entry
                    ? 'Nova Transação de Entrada'
                    : 'Nova Transação de Saída',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Product>(
                decoration: const InputDecoration(labelText: 'Produto'),
                value: _selectedProduct,
                items: productList.map((product) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecione um produto' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  hintText: 'Informe a quantidade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quantidade';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Digite um número válido';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _submitForm(transactionType),
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
