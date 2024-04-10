import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/viewPayment.dart';
import '../controllers/admin_payment_controller.dart';

class AdminPaymentView extends StatelessWidget {
  const AdminPaymentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: SingleChildScrollView(
            child: GetX<AdminPaymentController>(
              init: AdminPaymentController(), // Initialize the controller
              builder: (controller) {
                if (controller.payments.isEmpty) {
                  // Show a loading indicator if payments are still loading
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Build a table to display payment details
                  return DataTable(
                    columnSpacing: 16.0,
                    headingRowHeight: 48.0,
                    dataRowHeight: 64.0,
                    columns: [
                      DataColumn(label: Text('Payment ID')),
                      DataColumn(label: Text('User ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Payment Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Details')),
                    ],
                    rows: controller.payments.asMap().entries.map((entry) {
                      final index = entry.key;
                      final payment = entry.value;
                      final color =
                          index.isEven ? Colors.grey.shade200 : Colors.white;
                      return DataRow(
                        color:
                            MaterialStateColor.resolveWith((states) => color),
                        cells: [
                          DataCell(Text(payment.paymentId ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.userId ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.fullName ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.email ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.amount ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.paymentDate?.toString() ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.status ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                          DataCell(Text(payment.details ?? ''),
                              onTap: () => _onCellTap(context, payment)),
                        ],
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onCellTap(BuildContext context, Payment payment) {
    // Handle cell tap event here
    // For example, show a dialog with more details
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payment ID: ${payment.paymentId ?? ''}'),
                Text('User ID: ${payment.userId ?? ''}'),
                Text('Full Name: ${payment.fullName ?? ''}'),
                Text('Email: ${payment.email ?? ''}'),
                Text('Amount: ${payment.amount ?? ''}'),
                Text('Details: ${payment.details ?? ''}'),
                Text('Payment Date: ${payment.paymentDate?.toString() ?? ''}'),
                Text('Status: ${payment.status ?? ''}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
