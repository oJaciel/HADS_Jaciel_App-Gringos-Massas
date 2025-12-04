import 'package:app_gringos_massas/components/sales/sale_or_service_selector.dart';
import 'package:app_gringos_massas/components/sales/sale_products_selector.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/models/service.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
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
  final serviceDescriptionController = TextEditingController();
  final serviceValueController = TextEditingController();

  bool _isLoading = false;
  bool _isInit = true;
  bool _isSale = true;

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
        //Se vier args e for uma venda, preenche os campos de venda
        if (args is Sale) {
          final sale = args;

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
          //Se for serviço, preenche os campos de serviço
        } else if (args is Service) {
          _isSale = false;

          final service = args;
          setState(() {
            selectedDate = service.date;
            paymentMethod = service.paymentMethod;
            clientController.text = service.clientName ?? '';
            serviceDescriptionController.text = service.description ?? '';
            serviceValueController.text =
                'R\$ ${service.total.toStringAsFixed(2).replaceAll('.', ',')}';
          });
        }
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

    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final saleItemProvider = Provider.of<SaleItemProvider>(
      context,
      listen: false,
    );

    final serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );

    Future<void> submitSale() async {
      setState(() {
        _isLoading = true;
      });

      final existingSale = ModalRoute.of(context)?.settings.arguments as Sale?;

      if (saleItemProvider.items.values.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_rounded),
                SizedBox(width: 6),
                Text('Erro!'),
              ],
            ),
            content: Text('Adicione produtos a venda!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Ok'),
              ),
            ],
          ),
        );
        return;
      }

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

    Future<void> submitService() async {
      setState(() {
        _isLoading = true;
      });

      final existingService =
          ModalRoute.of(context)?.settings.arguments as Service?;

      // Validações do formulário
      if (!formKey.currentState!.validate()) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (existingService != null) {
        Service updatedService = Service(
          id: existingService.id,
          total: AppUtils.parsePrice(serviceValueController.text),
          date: selectedDate,
          clientName: clientController.text,
          description: serviceDescriptionController.text,
          paymentMethod: paymentMethod,
        );
        await serviceProvider.updateService(updatedService);
        Navigator.of(context).pop();
      } else {
        await serviceProvider.addService(
          context,
          serviceDescriptionController.text,
          clientController.text,
          paymentMethod,
          AppUtils.parsePrice(serviceValueController.text),
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
            onPressed: _isSale ? submitSale : submitService,
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

                    SaleOrServiceSelector(
                      isSale: _isSale,
                      onSelectSale: () => setState(() => _isSale = true),
                      onSelectService: () => setState(() => _isSale = false),
                      isEdit: isEdit,
                    ),

                    SizedBox(height: 8),

                    _isSale
                        ? SaleProductsSelector(
                            isEdit: isEdit,
                            existingSale: isEdit ? args as Sale : null,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Descrição',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 4),
                              TextFormField(
                                controller: serviceDescriptionController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição do serviço (opcional)',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),

                    const SizedBox(height: 16),

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
                    Text(
                      _isSale ? 'Resumo da venda' : 'Resumo do serviço',
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
                            _isSale
                                ? Text(
                                    AppUtils.formatPrice(
                                      isEdit
                                          ? (args as Sale).total
                                          : Provider.of<SaleItemProvider>(
                                              context,
                                            ).totalAmount,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  )
                                : Expanded(
                                    child: TextFormField(
                                      controller: serviceValueController,
                                      decoration: const InputDecoration(
                                        //labelText: 'Valor do serviço',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                      inputFormatters: [
                                        CurrencyInputFormatter(
                                          leadingSymbol: 'R\$',
                                          useSymbolPadding: true,
                                          thousandSeparator:
                                              ThousandSeparator.Period,
                                          mantissaLength: 2,
                                        ),
                                      ],
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Preencha o valor do serviço';
                                        }
                                        // Remove R$, espaços, pontos e converte vírgula em ponto
                                        String cleaned = value
                                            .replaceAll('R\$', '')
                                            .replaceAll('.', '')
                                            .replaceAll(',', '.')
                                            .trim();
                                        double? parsed = double.tryParse(
                                          cleaned,
                                        );
                                        if (parsed == null) {
                                          return 'Preço inválido';
                                        }
                                        if (parsed <= 0) {
                                          return 'Preço deve ser maior que zero';
                                        }
                                        return null;
                                      },
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
                        onPressed: _isSale ? submitSale : submitService,
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
