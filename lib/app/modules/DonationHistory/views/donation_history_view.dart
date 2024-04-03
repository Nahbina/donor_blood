import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/donation_history_controller.dart';

class DonationHistoryView extends GetView<DonationHistoryController> {
  const DonationHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final DonationHistoryController controller =
        Get.put(DonationHistoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.donationHistoryList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: controller.donationHistoryList.length,
              itemBuilder: (context, index) {
                final donation = controller.donationHistoryList[index];
                return ListTile(
                  title: Text('Donation ID: ${donation.donationHistoryId}'),
                  subtitle: Text('Donor ID: ${donation.donorId}'),
                  // Add more fields as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}
