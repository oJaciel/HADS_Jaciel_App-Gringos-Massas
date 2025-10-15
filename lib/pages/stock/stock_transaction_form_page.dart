import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/components/stock/stock_page_item.dart';
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
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  Product? _selectedProduct;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(TransactionType transactionType) async {
    setState(() {
      _isLoading = true;
    });

    // Validações do formulário
    if (!_formKey.currentState!.validate()) return;

    final qty = int.tryParse(_quantityController.text);

    final productProvider = context.read<ProductProvider>();

    await context.read<StockProvider>().addTransaction(
      context,
      productProvider,
      _selectedProduct!,
      qty!,
      transactionType,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionType =
        ModalRoute.of(context)!.settings.arguments as TransactionType;

    final productList = context.watch<ProductProvider>().activeProducts;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          transactionType == TransactionType.entry
              ? 'Transação de Entrada'
              : 'Transação de Saída',
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Produto',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    SizedBox(height: 4),
                    DropdownButtonFormField<Product>(
                      decoration: const InputDecoration(
                        labelText: 'Selecione um produto',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),

                      items: productList.map((product) {
                        return DropdownMenuItem<Product>(
                          value: product,
                          child: Row(
                            children: [
                              ProductImage(product: product),
                              SizedBox(width: 12),
                              Text(product.name),
                            ],
                          ),
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
                    if (_selectedProduct != null)
                      Column(
                        children: [
                          SizedBox(height: 10),

                          StockPageItem(_selectedProduct!),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Text(
                      'Quantidade',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Informe a quantidade',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a quantidade';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Digite um número válido';
                        }
                        if (int.tryParse(value)! <= 0) {
                          return 'Informe uma quantidade válida';
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _submitForm(transactionType),
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
