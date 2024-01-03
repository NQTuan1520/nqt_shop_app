import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../vendor/controllers/vendorStoresController.dart';

class VendorStore extends StatelessWidget {
  const VendorStore({Key? key});

  @override
  Widget build(BuildContext context) {
    final VendorStoreController _vendorStoreController =
    Get.find<VendorStoreController>();

    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    'Top Stores',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      color: Colors.black,
                      fontSize: 18,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Always 4 columns
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0, // Adjust spacing as needed
            ),
            itemCount: _vendorStoreController.categories.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: screenWidth * 0.18,
                    height: screenWidth * 0.18,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF336699),
                      ),
                      borderRadius: BorderRadius.circular(
                        screenWidth * 0.09,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.network(
                        _vendorStoreController.categories[index].VendorImage,
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.18,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Text(
                        _vendorStoreController.categories[index].VendorName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          color: Colors.grey.shade600,
                          fontSize: 11,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      );
    });
  }
}
