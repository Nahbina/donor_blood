import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/donorModel.dart';
import '../../../utils/constants.dart';
import '../controllers/donors_detail_controller.dart';

class DonorsDetailView extends GetView<DonorsDetailController> {
  const DonorsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var donor = Get.arguments as DonorElement?;
    return Scaffold(
      appBar: AppBar(
        title: Text(donor?.fullName ?? ''),
        centerTitle: true,
        backgroundColor: Colors.red, // Set AppBar color to red
      ),
      body: Column(children: [
        Expanded(
          flex: 2,
          child: Hero(
            tag: donor?.donorId.toString() ?? '',
            child: Image.network(
              getImageUrl(donor?.avatar ?? ''),
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name: ${donor?.fullName ?? ''}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Blood Type: ${donor?.bloodType ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Birth Date: ${donor?.birthDate != null ? donor!.birthDate!.toString() : ''}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Last Donation Date: ${donor?.lastDonationDate ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Phone Number: ${donor?.phoneNumber ?? ''}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ]),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 100,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  primary: Colors.red, // Set button color to red
                  onPrimary: Colors.white, // Set button text color to white
                ),
                onPressed: () {
                  controller.addBloodRequest(donor?.donorId.toString() ?? '');
                },
                child: const Text(
                  'Request',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
