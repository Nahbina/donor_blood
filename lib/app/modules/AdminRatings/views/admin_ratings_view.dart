import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the flutter_rating_bar package

import '../../../models/Ratings.dart';
import '../controllers/admin_ratings_controller.dart';

class AdminRatingsView extends GetView<AdminRatingsController> {
  const AdminRatingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensure that the AdminRatingsController is initialized and accessible
    Get.put(AdminRatingsController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () {
              if (controller.ratingsList.isEmpty) {
                return const Center(
                  child: Text('No ratings available'),
                );
              } else {
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('RatingId')),
                    DataColumn(label: Text('Rating')),
                    DataColumn(label: Text('Comment')),
                    DataColumn(label: Text('User')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: List<DataRow>.generate(
                    controller.ratingsList.length,
                    (index) {
                      final Rating rating = controller.ratingsList[index];
                      return DataRow(
                        cells: [
                          DataCell(Text(rating.ratingId ?? '')),
                          DataCell(
                            // Replace Text widget with RatingBar widget
                            RatingBar.builder(
                              initialRating: double.parse(rating.rating ?? '0'),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                // You can add functionality here if needed
                              },
                            ),
                          ),
                          DataCell(Text(rating.comment ?? '')),
                          DataCell(Text(rating.fullName ?? '')),
                          DataCell(Text(rating.email ?? '')),
                          DataCell(Text(rating.createdAt?.toString() ?? '')),
                          DataCell(
                            IconButton(
                              onPressed: () {
                                _confirmDelete(
                                    context, rating.ratingId!, rating.userId!);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String ratingId, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Rating'),
          content: const Text('Are you sure you want to delete this rating?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.find<AdminRatingsController>()
                    .deleteRatings(ratingId, userId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
