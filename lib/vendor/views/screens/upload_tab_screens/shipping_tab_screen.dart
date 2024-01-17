import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../controller/provider/product_provider.dart';

class ShippingScreeen extends StatefulWidget {
  @override
  State<ShippingScreeen> createState() => _ShippingScreeenState();
}

class _ShippingScreeenState extends State<ShippingScreeen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  bool? _chargeShipping = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            'Phí giao hàng',
            style: GoogleFonts.getFont(
              'Roboto',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              letterSpacing: 0,
            ),
          ),
          value: _chargeShipping,
          onChanged: (value) {
            setState(() {
              _chargeShipping = value;
              _productProvider.getFormData(chargeShipping: _chargeShipping);
            });
          },
        ),
        if (_chargeShipping == true)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Hãy điền phí giao hàng';
                } else {
                  return null;
                }
              },
              onChanged: (value) {
                _productProvider.getFormData(shippingCharge: int.parse(value));
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Phí giao hàng',
              ),
            ),
          )
      ],
    );
  }
}
