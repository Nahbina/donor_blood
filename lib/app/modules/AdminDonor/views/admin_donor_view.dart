import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../models/donorModel.dart';
import '../controllers/admin_donor_controller.dart';

class AdminDonorView extends GetView<AdminDonorController> {
  const AdminDonorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AdminDonorController controller = Get.put(AdminDonorController());

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              if (controller.donors.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Donor ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Blood Type')),
                      DataColumn(label: Text('Birth Date')),
                      DataColumn(label: Text('Phone Number')),
                      DataColumn(label: Text('Address')),
                      DataColumn(label: Text('Last Donation Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.donors.map((donor) {
                      return DataRow(cells: [
                        DataCell(Text(donor.donorId.toString())),
                        DataCell(Text(donor.fullName ?? '')),
                        DataCell(Text(donor.bloodType ?? '')),
                        DataCell(Text(donor.birthDate?.toString() ?? '')),
                        DataCell(Text(donor.phoneNumber ?? '')),
                        DataCell(Text(donor.Address ?? '')),
                        DataCell(Text(donor.lastDonationDate ?? '')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showEditDialog(context, donor);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete Donor'),
                                      content: Text(
                                          'Are you sure you want to delete this donor?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            controller
                                                .deleteDonor(donor.donorId!);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
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

  void showEditDialog(BuildContext context, DonorElement donor) {
    TextEditingController idController =
        TextEditingController(text: donor.donorId.toString());
    TextEditingController bloodTypeController =
        TextEditingController(text: donor.bloodType ?? '');
    TextEditingController birthDateController =
        TextEditingController(text: donor.birthDate?.toString() ?? '');
    TextEditingController phoneNumberController =
        TextEditingController(text: donor.phoneNumber ?? '');
    TextEditingController addressController = TextEditingController(
        text: donor.Address ?? ''); // Changed to 'address'
    TextEditingController lastDonationDateController =
        TextEditingController(text: donor.lastDonationDate ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Donor'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              TextFormField(
                controller: idController,
                decoration: InputDecoration(labelText: 'Donor ID'),
              ),
              TextFormField(
                controller: bloodTypeController,
                decoration: InputDecoration(labelText: 'Blood Type'),
              ),
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: donor.birthDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null && picked != donor.birthDate) {
                    birthDateController.text = picked.toString();
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: birthDateController,
                    decoration: InputDecoration(labelText: 'Birth Date'),
                  ),
                ),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: lastDonationDateController,
                decoration: InputDecoration(labelText: 'Last Donation Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              DonorElement updatedDonor = DonorElement(
                donorId: int.parse(idController.text),
                bloodType: bloodTypeController.text,
                birthDate: DateTime.parse(birthDateController.text),
                phoneNumber: phoneNumberController.text,
                Address: addressController.text, // Changed to 'address'
                lastDonationDate: lastDonationDateController.text,
              );
              controller.editDonor(updatedDonor);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
