import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_request_controller.dart';
import '../../../models/requestModel.dart';

class AdminRequestView extends StatelessWidget {
  const AdminRequestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<AdminRequestController>(
          init: AdminRequestController(),
          builder: (controller) {
            return controller.requests.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : DataTable(
                    columns: const [
                      DataColumn(label: Text('Request ID')),
                      DataColumn(label: Text('Requester Name')),
                      DataColumn(label: Text('Requester Email')),
                      DataColumn(label: Text('User ID')),
                      DataColumn(label: Text('Donor ID')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Request Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.requests.map((request) {
                      return DataRow(cells: [
                        DataCell(Text(request.requestId.toString())),
                        DataCell(Text(request.requesterName ?? '')),
                        DataCell(Text(request.requesterEmail ?? '')),
                        DataCell(Text(request.userId.toString())),
                        DataCell(Text(request.donorId.toString())),
                        DataCell(Text(request.status ?? '')),
                        DataCell(Text(request.requestDate?.toString() ?? '')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editRequest(context, request);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _confirmDelete(context, request.requestId!);
                              },
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  );
          },
        ),
      ),
    );
  }

  void _editRequest(BuildContext context, Request request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRequestPage(request: request),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int requestId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Request'),
          content: const Text('Are you sure you want to delete this request?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Get.find<AdminRequestController>().deleteRequest(requestId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class EditRequestPage extends StatefulWidget {
  final Request request;

  EditRequestPage({Key? key, required this.request}) : super(key: key);

  @override
  _EditRequestPageState createState() => _EditRequestPageState();
}

class _EditRequestPageState extends State<EditRequestPage> {
  late AdminRequestController _requestController;
  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController eventLocationController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestController = Get.find<AdminRequestController>();
    eventNameController.text = widget.request.requesterName ?? '';
    eventDateController.text = widget.request.requestDate?.toString() ?? '';
    eventLocationController.text = widget.request.requesterEmail ?? '';
    eventDescriptionController.text = widget.request.status ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Request'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: eventNameController,
                decoration: InputDecoration(labelText: 'Requester Name'),
              ),
              TextFormField(
                controller: eventDateController,
                decoration: InputDecoration(labelText: 'Request Date'),
                keyboardType: TextInputType.datetime,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.request.requestDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      eventDateController.text = pickedDate.toString();
                    });
                  }
                },
              ),
              TextField(
                controller: eventLocationController,
                decoration: InputDecoration(labelText: 'Requester Email'),
              ),
              TextField(
                controller: eventDescriptionController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Update the request with the edited data
          Request updatedRequest = Request(
            requestId: widget.request.requestId,
            userId: widget.request.userId,
            donorId: widget.request.donorId,
            status: eventDescriptionController.text,
            requestDate: DateTime.parse(eventDateController.text),
            requesterName: eventNameController.text,
            requesterEmail: eventLocationController.text,
          );
          // Call the editRequest method of the AdminRequestController to trigger the update
          _requestController.editRequest(updatedRequest);
          Navigator.of(context).pop();
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
