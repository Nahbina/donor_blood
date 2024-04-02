import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_request_controller.dart';

class AdminRequestView extends GetView<AdminRequestController> {
  const AdminRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final AdminRequestController controller = Get.put(AdminRequestController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Obx(
          () {
            if (controller.requests.isEmpty) {
              return const CircularProgressIndicator();
            } else {
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Request ID')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Donor ID')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Request Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: controller.requests.map((request) {
                  return DataRow(cells: [
                    DataCell(Text(request.requestId.toString())),
                    DataCell(Text(request.userId.toString())),
                    DataCell(Text(request.donorId.toString())),
                    DataCell(Text(request.status ?? '')),
                    DataCell(Text(request.requestDate?.toString() ?? '')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality here
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Implement delete functionality here
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
