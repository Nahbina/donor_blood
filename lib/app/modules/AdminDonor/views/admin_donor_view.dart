import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_donor_controller.dart';

class AdminDonorView extends GetView<AdminDonorController> {
  const AdminDonorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final AdminDonorController controller = Get.put(AdminDonorController());

    return Scaffold(
      body: Column(
        // Wrap with Column
        crossAxisAlignment: CrossAxisAlignment.start, // Align to start
        children: [
          Obx(
            () {
              if (controller.donors.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Donor ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Blood Type')),
                      DataColumn(label: Text('Birth Date')),
                      DataColumn(label: Text('Last Donation Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.donors.map((donor) {
                      return DataRow(cells: [
                        DataCell(Text(donor.donorId.toString())),
                        DataCell(Text(donor.fullName ?? '')),
                        DataCell(Text(donor.bloodType ?? '')),
                        DataCell(Text(donor.birthDate?.toString() ?? '')),
                        DataCell(Text(donor.lastDonationDate ?? '')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Implement edit functionality here
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Implement delete functionality here
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
