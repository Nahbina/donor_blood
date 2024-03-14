import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/donors_controller.dart';

class DonorFormView extends StatelessWidget {
  const DonorFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DonorsController());
    var controller = Get.find<DonorsController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Donor'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 15,
          ),
          child: Form(
            key: controller.donorformKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller.donorBloodType,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Blood Type',
                    hintText: 'Enter donor Blood Type',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor Blood Type';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: controller.donorbirthDate,
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    hintText: 'Enter donor Birthdate',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor birthdate';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: controller.donorlastDonationDate,
                  decoration: const InputDecoration(
                    labelText: 'Last Donation Date',
                    hintText: 'Enter donor last donation date',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor last donation date';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controller.donorPhoneNumber,
                  decoration: const InputDecoration(
                    labelText: 'PhoneNumber',
                    hintText: 'Enter donor phone number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter donor phone number';
                    }
                    return null;
                  },
                ),
                GetBuilder<DonorsController>(
                  builder: (controller) => (controller.image == null ||
                          controller.imageBytes == null)
                      ? ElevatedButton(
                          onPressed: controller.pickImage,
                          child: const Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // Set button color to red
                            onPrimary:
                                Colors.white, // Set button text color to white
                          ),
                        )
                      : Stack(
                          children: [
                            Image.memory(
                              controller.imageBytes!,
                              height: 300,
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    controller.image = null;
                                    controller.imageBytes = null;
                                    controller.update();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: controller.addDonor,
                  child: const Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set button color to red
                    onPrimary: Colors.white, // Set button text color to white
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
