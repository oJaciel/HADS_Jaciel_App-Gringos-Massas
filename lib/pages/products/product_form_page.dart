import 'dart:math';

import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  bool _activeController = true;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      final product = args as Product;

      setState(() {
        _nameController.text = product.name;
        _priceController.text = AppUtils.formatPrice(product.price);
        _imageController.text = product.imageUrl;
        _activeController = product.isActive;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);

    Future<void> _submitForm() async {
      setState(() {
        _isLoading = true;
      });

      final args = ModalRoute.of(context)?.settings.arguments;
      final existingProduct = args as Product?;

      if (!_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      Product product = Product(
        id: existingProduct?.id ?? Random().nextDouble().toString(),
        name: _nameController.text,
        imageUrl: _imageController.text,
        price: AppUtils.parsePrice(_priceController.text),
        isActive: _activeController,
        stockQuantity: existingProduct?.stockQuantity ?? 0,
        hasMovement: existingProduct?.hasMovement ?? false,
      );

      if (existingProduct != null) {
        await provider.updateProduct(product);
      } else {
        await provider.addProduct(product);
      }

      Navigator.of(context).pop();

      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Produto'),
        actions: [IconButton(onPressed: _submitForm, icon: Icon(Icons.save))],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações do produto
                    const Text(
                      'Nome do Produto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome do produto',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value?.trim() == '') {
                          return 'Preencha o nome do produto';
                        }
                        if (value!.length <= 3) {
                          return 'Nome deve ter no mínimo 4 letras';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Preço',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Preço do produto',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        CurrencyInputFormatter(
                          leadingSymbol: 'R\$',
                          useSymbolPadding: true,
                          thousandSeparator: ThousandSeparator.Period,
                          mantissaLength: 2,
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Preencha o preço do produto';
                        }
                        // Remove R$, espaços, pontos e converte vírgula em ponto
                        String cleaned = value
                            .replaceAll('R\$', '')
                            .replaceAll('.', '')
                            .replaceAll(',', '.')
                            .trim();
                        double? parsed = double.tryParse(cleaned);
                        if (parsed == null) {
                          return 'Preço inválido';
                        }
                        if (parsed <= 0) {
                          return 'Preço deve ser maior que zero';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),

                    Text(
                      'URL da imagem',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    TextFormField(
                      controller: _imageController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 8),

                    if (ModalRoute.of(context)?.settings.arguments != null)
                      Column(
                        children: [
                          Text(
                            'Ativo / Inativo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: _activeController,
                            onChanged: (bool v) {
                              setState(() {
                                _activeController = v;
                              });
                            },
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.red,

                            thumbIcon: WidgetStateProperty.resolveWith<Icon?>((
                              Set<WidgetState> states,
                            ) {
                              if (states.contains(WidgetState.selected)) {
                                return const Icon(Icons.check);
                              } else {
                                return const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                );
                              }
                            }),
                          ),
                        ],
                      ),

                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _submitForm,
                        label: Text('Salvar'),
                        icon: Icon(Icons.save),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
