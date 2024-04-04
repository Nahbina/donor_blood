import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controllers/admin_request_controller.dart';
import '../../../models/requestModel.dart';
import '../../../utils/constants.dart';
import '../../../utils/memory.dart';

class AdminRequestView extends StatelessWidget {
  const AdminRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<AdminRequestController>(
          init: AdminRequestController(),
          builder: (controller) {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.error.value.isNotEmpty) {
              return Center(
                child: Text('Error: ${controller.error.value}'),
              );
            } else if (controller.requests.isEmpty) {
              return const Center(
                child: Text('No requests found.'),
              );
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
