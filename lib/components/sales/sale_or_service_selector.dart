import 'package:flutter/material.dart';

class SaleOrServiceSelector extends StatefulWidget {
  const SaleOrServiceSelector({
    super.key,
    required this.isSale,
    required this.onSelectSale,
    required this.onSelectService,
    required this.isEdit,
  });

  final bool isSale;
  final Function onSelectSale;
  final Function onSelectService;
  final bool isEdit;

  @override
  State<SaleOrServiceSelector> createState() => _SaleOrServiceSelectorState();
}

class _SaleOrServiceSelectorState extends State<SaleOrServiceSelector> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isEdit ? 0.4 : 1,
      child: AbsorbPointer(
        absorbing: widget.isEdit,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => widget.onSelectSale(),
                style: OutlinedButton.styleFrom(
                  shape: ContinuousRectangleBorder(),
                  backgroundColor: widget.isSale
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  foregroundColor: widget.isSale
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                label: Text('Venda'),
                icon: Icon(Icons.receipt_long_rounded),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => widget.onSelectService(),
                style: OutlinedButton.styleFrom(
                  shape: ContinuousRectangleBorder(),
                  backgroundColor: !widget.isSale
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  foregroundColor: !widget.isSale
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                label: Text('Serviço'),
                icon: Icon(Icons.miscellaneous_services_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
