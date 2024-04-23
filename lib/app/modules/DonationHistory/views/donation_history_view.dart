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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 100,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No donation history found.',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: controller.donationHistoryList.length,
              itemBuilder: (context, index) {
                final donation = controller.donationHistoryList[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      'Donation ID: ${donation.donationHistoryId}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Donor ID: ${donation.donorId}'),
                        Text('Requester Name: ${donation.requesterName}'),
                        Text('Requester Email: ${donation.requesterEmail}'),
                        Text('Donation Date: ${donation.donationDate}'),
                        Text('Created At: ${donation.createdAt}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Add your delete functionality here
                        // You might want to show a confirmation dialog before deleting
                      },
                    ),
                    onTap: () {
                      // Add your onTap functionality here
                    },
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
