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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: donor?.donorId.toString() ?? '',
              child: Image.network(
                getImageUrl(donor?.avatar ?? ''),
                width: double.infinity,
                fit: BoxFit.cover,
                height: 300, // Adjust image height
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.fullName ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Blood Type',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.bloodType ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Birth Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.birthDate != null
                        ? donor!.birthDate!.toString()
                        : '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Last Donation Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.lastDonationDate ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.phoneNumber ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    donor?.Address ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
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
    );
  }
}
