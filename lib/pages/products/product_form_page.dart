import 'dart:math';

import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _imageController = TextEditingController();
    final bool? _activeController;

    void _submitForm() {
      if (_formKey.currentState!.validate()) ;

      Product product = Product(
        id: Random().nextDouble().toString(),
        name: _nameController.text,
        imageUrl: _imageController.text,
        price: double.parse(_priceController.text),
      );

      Provider.of<ProductProvider>(context, listen: false).addProduct(product);

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Formulário de Produto')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome do produto',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hint: Text('Insira o nome do produto'),
                  ),
                ),
                SizedBox(height: 8),

                Text(
                  'Preço',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(hint: Text('Insira o preço')),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                SizedBox(height: 8),

                Text(
                  'URL da imagem',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    hint: Text('Insira o URL da imagem'),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
                SizedBox(height: 8),
                Spacer(),
                ElevatedButton(onPressed: _submitForm, child: Text('Salvar')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
