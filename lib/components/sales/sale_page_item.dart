import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SalePageItem extends StatefulWidget {
  const SalePageItem(this.sale, {super.key});

  final Sale sale;

  @override
  State<SalePageItem> createState() => _SaleItemState();
}

class _SaleItemState extends State<SalePageItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 3,
        child: Column(
          children: [
            ListTile(
              visualDensity: VisualDensity(vertical: 4),
              leading: Icon(Icons.receipt_long_rounded, color: Colors.grey),
              title: Row(
                children: [
                  Text(DateFormat('dd/MM').format(widget.sale.date)),
                  SizedBox(width: 4),
                  Icon(Icons.circle, size: 4),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('HH:mm').format(widget.sale.date),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.sale.paymentMethod != null &&
                      widget.sale.paymentMethod.toString() != '')
                    Row(
                      children: [
                        Icon(
                          AppUtils.getPaymentIcon(widget.sale.paymentMethod!),
                          color: Colors.grey[700],
                          size: 20,
                        ),
                        SizedBox(width: 6),
                        Text(
                          AppUtils.getPaymentName(widget.sale.paymentMethod!),
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  if (widget.sale.clientName != null ||
                      widget.sale.clientName != '' ||
                      widget.sale.clientName!.isNotEmpty)
                    Text(
                      widget.sale.clientName!,
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
                          AppUtils.formatPrice(widget.sale.total),
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
            _isExpanded
                ? AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 10, top: 5),
                      shrinkWrap: true,
                      itemCount: widget.sale.products.length,
                      itemBuilder: (ctx, index) {
                        final product = widget.sale.products[index];
                        return ListTile(
                          title: Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${product.quantity} x ${AppUtils.formatPrice(product.unitPrice)}',
                          ),

                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ProductImage(
                              product: Provider.of<ProductProvider>(
                                context,
                              ).getProductById(product.productId),
                              height: 90,
                              width: 80,
                            ),
                          ),
                          trailing: Text(
                            AppUtils.formatPrice(
                              product.unitPrice * product.quantity,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
