import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/requestModel.dart';
import '../controllers/request_controller.dart';

class RequestFormView extends StatelessWidget {
  final RequestController _requestController = Get.put(RequestController());

  RequestFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Request'),
      ),
      body: Obx(
        () {
          if (_requestController.bloodRequests.isEmpty) {
            // Show "No blood requests" message with animation
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Lottie.asset(
                  //   'assets/lottie/No.json',
                  //   height: 200,
                  //   repeat: true,
                  // ),
                  const SizedBox(height: 20),
                  Text(
                    'No blood requests',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            // Display blood requests
            return ListView.builder(
              itemCount: _requestController.bloodRequests.length,
              itemBuilder: (context, index) {
                final Request request = _requestController.bloodRequests[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      'Request ID: ${request.requestId}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Status: ${request.status}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text('Requester Name: ${request.requesterName}'),
                        // SizedBox(height: 4),
                        // Text(
                        //   'Requester Email: ${request.requesterEmail}',
                        //   style: TextStyle(color: Colors.grey[700]),
                        // ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          TextButton(
                            onPressed: () {
                              _requestController
                                  .acceptRequest(request.requestId.toString());
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          SizedBox(width: 8),
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          TextButton(
                            onPressed: () {
                              _requestController
                                  .cancelRequest(request.requestId.toString());
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
