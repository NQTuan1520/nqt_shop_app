import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart' as rate;

class AllReviewsScreen extends StatelessWidget {
  final String productID;

  AllReviewsScreen({required this.productID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('productReviews')
            .where('productID', isEqualTo: productID)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No reviews available'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final reviewData = snapshot.data!.docs[index];
                final rating = reviewData['rating'];
                final reviewText = reviewData['review'];
                final buyerPhoto = reviewData['buyerPhoto'];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(buyerPhoto),
                  ),
                  title: Text(
                    reviewData['fullName'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rate.RatingBar.readOnly(
                        filledIcon: Icons.star,
                        emptyIcon: Icons.star_border,
                        size: 20,
                        initialRating: rating,
                        maxRating: 5,
                      ),
                      SizedBox(height: 8),
                      Text(reviewText),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


