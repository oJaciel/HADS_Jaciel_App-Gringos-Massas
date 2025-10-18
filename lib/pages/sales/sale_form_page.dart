import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/components/sales/sale_form_item.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SaleFormPage extends StatefulWidget {
  const SaleFormPage({super.key});

  @override
  State<SaleFormPage> createState() => _SaleFormPageState();
}

class _SaleFormPageState extends State<SaleFormPage> {
  DateTime selectedDate = DateTime.now();
  PaymentMethod? paymentMethod;
  final formKey = GlobalKey<FormState>();
  final clientController = TextEditingController();

  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;

      //Se não for edição, limpa a lista dos itens quando abrir a tela
      if (args == null) Provider.of<SaleItemProvider>(context).clear();

      if (args != null) {
        final sale = args as Sale;

        setState(() {
          selectedDate = sale.date;
          paymentMethod = sale.paymentMethod;
          clientController.text = sale.clientName ?? '';
          for (SaleItem saleItem in sale.products) {
            Provider.of<SaleItemProvider>(context, listen: false).addItem(
              Provider.of<ProductProvider>(
                context,
                listen: false,
              ).getProductById(saleItem.productId),
            );
          }
        });
      }
      _isInit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Limpando os campos quando fechar a tela
    clientController.dispose();
    Provider.of<SaleItemProvider>(context, listen: false).clear();
    paymentMethod = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    bool isEdit = args != null;
    final products = context.read<ProductProvider>().activeProducts;

    final saleProvider = Provider.of<SaleProvider>(context, listen: false);

    Future<void> submitForm() async {
      setState(() {
        _isLoading = true;
      });

      final existingSale = ModalRoute.of(context)?.settings.arguments as Sale?;

      // Validações do formulário
      if (!formKey.currentState!.validate()) return;

      if (existingSale != null) {
        Sale updatedSale = Sale(
          id: existingSale.id,
          products: existingSale.products,
          total: existingSale.total,
          date: selectedDate,
          clientName: clientController.text,
          paymentMethod: paymentMethod,
        );

        await saleProvider.updateSale(context, updatedSale);
      } else {
        await saleProvider.addSale(
          context,
          clientController.text,
          paymentMethod,
          selectedDate,
        );
      }

      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Venda'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Card da data
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.blueGrey,
                        ),
                        title: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: TextButton(
                          onPressed: () => _selectDate(context),
                          child: const Text(
                            'Alterar data',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    if (isEdit)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Produtos não podem ser editados!')],
                      ),

                    //Dropdown e lista de produtos
                    Opacity(
                      opacity: isEdit ? 0.4 : 1,
                      child: AbsorbPointer(
                        absorbing: isEdit,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Produtos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<Product>(
                              decoration: const InputDecoration(
                                labelText: 'Adicionar produto',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                              items: products.map((product) {
                                return DropdownMenuItem<Product>(
                                  value: product,
                                  child: Row(
                                    children: [
                                      ProductImage(
                                        product: product,
                                        height: 36,
                                        width: 36,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(product.name),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<SaleItemProvider>().addItem(
                                    value,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 12),

                            Consumer<SaleItemProvider>(
                              builder: (context, saleItems, _) {
                                final sale = isEdit ? args as Sale : null;
                                final itemsList = isEdit
                                    ? sale!.products
                                    : saleItems.items.values.toList();
                                if (itemsList.isEmpty) {
                                  return SizedBox(
                                    height: 120,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Nenhum produto adicionado',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: itemsList.length,
                                  itemBuilder: (ctx, i) =>
                                      SaleFormItem(itemsList[i]),
                                );
                              },
                            ),

                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),

                    // Informações do cliente
                    const Text(
                      'Informações do cliente',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: clientController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome do cliente (opcional)',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      keyboardType: TextInputType.name,
                    ),

                    const SizedBox(height: 24),

                    // Resumo da venda
                    const Text(
                      'Resumo da venda',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Text(
                              AppUtils.formatPrice(
                                Provider.of<SaleItemProvider>(
                                  context,
                                ).totalAmount,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<PaymentMethod>(
                      initialValue: paymentMethod,
                      decoration: const InputDecoration(
                        labelText: 'Forma de pagamento',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: PaymentMethod.values.map((method) {
                        String label = AppUtils.getPaymentName(method);
                        IconData icon = AppUtils.getPaymentIcon(method);
                        return DropdownMenuItem<PaymentMethod>(
                          value: method,
                          child: Row(
                            children: [
                              Icon(icon, size: 20),
                              SizedBox(width: 6),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            paymentMethod = value;
                            print(paymentMethod);
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: submitForm,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text(
                          'Salvar venda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
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
