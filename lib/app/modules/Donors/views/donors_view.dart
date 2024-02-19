import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/donors_controller.dart';

class DonorFormView extends StatelessWidget {
  const DonorFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Donor'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DonorForm(),
      ),
    );
  }
}

class DonorForm extends StatefulWidget {
  const DonorForm({Key? key}) : super(key: key);

  @override
  _DonorFormState createState() => _DonorFormState();
}

class _DonorFormState extends State<DonorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _lastDonationDateController =
      TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(); // Added

  String? _selectedBloodType; // Added

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _phoneNumberController, // Added
              decoration: InputDecoration(labelText: 'Phone Number'), // Added
              keyboardType: TextInputType.phone, // Added
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number'; // Updated
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              decoration: InputDecoration(labelText: 'Blood Type'),
              items: ['A', 'B', 'O']
                  .map((type) => DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodType = value;
                  _bloodTypeController.text = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select the blood type';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _birthDateController,
              decoration: InputDecoration(labelText: 'Birth Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your birth date';
                }
                // You can add more specific validation logic here
                return null;
              },
            ),
            TextFormField(
              controller: _lastDonationDateController,
              decoration: InputDecoration(labelText: 'Last Donation Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the last donation date';
                }
                // You can add more specific validation logic here
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Handle form submission here
                  final String fullName = _fullNameController.text;
                  final String bloodType = _bloodTypeController.text;
                  final String birthDate = _birthDateController.text;
                  final String lastDonationDate =
                      _lastDonationDateController.text;
                  final String phoneNumber =
                      _phoneNumberController.text; // Added

                  // Call your controller's method to add the donor
                  Get.find<DonorsController>().addDonor(
                    fullName: fullName,
                    bloodType: bloodType,
                    birthDate: birthDate,
                    lastDonationDate: lastDonationDate,
                    phoneNumber: phoneNumber, // Added
                  );

                  // Navigate back after adding donor
                  Get.back();
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Set button color to red
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bloodTypeController.dispose();
    _birthDateController.dispose();
    _lastDonationDateController.dispose();
    _phoneNumberController.dispose(); // Added
    super.dispose();
  }
}
