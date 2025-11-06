import 'package:flutter/material.dart';

class SaleOrServiceSelector extends StatefulWidget {
  const SaleOrServiceSelector({
    super.key,
    required this.isSale,
    required this.onSelectSale,
    required this.onSelectService,
  });

  final bool isSale;
  final Function onSelectSale;
  final Function onSelectService;

  @override
  State<SaleOrServiceSelector> createState() => _SaleOrServiceSelectorState();
}

class _SaleOrServiceSelectorState extends State<SaleOrServiceSelector> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
