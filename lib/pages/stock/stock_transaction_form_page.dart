import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/components/stock/stock_page_item.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _quantity = 0;
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
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

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
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: 0.6,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_quantity > 1) _quantity -= 1;
                                      _quantityController.text = _quantity
                                          .toString();
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.remove_rounded, size: 20),
                                  ),
                                ),
                              ),

                              // Campo numérico expansível
                              Expanded(
                                flex: 4,
                                child: TextFormField(
                                  controller: _quantityController,
                                  maxLength: 3,

                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Informe a quantidade';
                                    }
                                    final n = int.tryParse(value);
                                    if (n == null || n <= 0) {
                                      return 'Quantidade inválida';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _quantity += 1;
                                      _quantityController.text = _quantity
                                          .toString();
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.add, size: 20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
