import 'package:app_gringos_massas/components/dialogs/delete_alert_dialog.dart';
import 'package:app_gringos_massas/models/service.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ServiceDetailsItem extends StatefulWidget {
  const ServiceDetailsItem(this.service, {super.key});

  final Service service;

  @override
  State<ServiceDetailsItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<ServiceDetailsItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ListTile(
            visualDensity: VisualDensity(vertical: 4),
            leading: Icon(
              Icons.miscellaneous_services_rounded,
              color: Colors.grey,
            ),
            title: Row(
              children: [
                Text(DateFormat('dd/MM').format(widget.service.date)),
                SizedBox(width: 4),
                Icon(Icons.circle, size: 4),
                SizedBox(width: 4),
                Text(
                  DateFormat('HH:mm').format(widget.service.date),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.service.paymentMethod != null &&
                    widget.service.paymentMethod.toString() != '')
                  Row(
                    children: [
                      Icon(
                        AppUtils.getPaymentIcon(widget.service.paymentMethod!),
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        AppUtils.getPaymentName(widget.service.paymentMethod!),
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                if (widget.service.clientName != null &&
                    widget.service.clientName != '' &&
                    widget.service.clientName!.isNotEmpty)
                  Text(
                    'Cliente: ${widget.service.clientName!}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppUtils.formatPrice(widget.service.total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Icon(
                  _isExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  color: Colors.grey[700],
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Column(
                      children: [
                        widget.service.description != null &&
                                widget.service.description != '' &&
                                widget.service.description!.isNotEmpty
                            ? ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    height: 90,
                                    width: 80,
                                    color: Colors.grey,
                                    child: Icon(
                                      Icons.miscellaneous_services_rounded,
                                      size: 45,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Descrição',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  widget.service.description ?? '',
                                ),
                              )
                            : SizedBox(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.SALE_FORM,
                                  arguments: widget.service,
                                );
                              },
                              icon: Icon(
                                Icons.edit_rounded,
                                color: Colors.grey[700],
                              ),
                              iconSize: 30,
                            ),
                            IconButton(
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => DeleteAlertDialog(
                                  title: 'Excluir a venda?',
                                  content: 'Deseja realmente excluir?',
                                  deleteMethod: () =>
                                      Provider.of<ServiceProvider>(
                                        context,
                                        listen: false,
                                      ).removeService(widget.service),
                                ),
                              ),
                              icon: Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
                              ),
                              iconSize: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
