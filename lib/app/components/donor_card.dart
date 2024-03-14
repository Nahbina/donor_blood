import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/donorModel.dart';
import '../routes/app_pages.dart';
import '../utils/constants.dart';

class DonorCard extends StatelessWidget {
  final DonorElement donor;
  final bool showAnimation;
  const DonorCard({Key? key, required this.donor, this.showAnimation = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: donor.donorId.toString(),
              child: Image.network(
                getImageUrl(donor.avatar ?? ''),
                fit: BoxFit.cover,
                height: double.infinity,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    donor.fullName ?? '',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(donor.bloodType ?? '', style: TextStyle(fontSize: 16)),
                  Text(
                      donor.birthDate != null
                          ? donor.birthDate!.toString()
                          : '',
                      style: TextStyle(fontSize: 16)),
                  Text(donor.lastDonationDate ?? '',
                      style: TextStyle(fontSize: 16)),
                  Text(donor.phoneNumber ?? '', style: TextStyle(fontSize: 16)),

                  // View donor button
                  ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.DONORS_DETAIL, arguments: donor);
                    },
                    child: Text('View Donor'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
