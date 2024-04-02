// RequestFormView.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          if (_requestController.isLoading.value) {
            // Show circular indicator while loading
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Display blood requests
            return ListView.builder(
              itemCount: _requestController.bloodRequests.length,
              itemBuilder: (context, index) {
                final request = _requestController.bloodRequests[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(request.donorId.toString()),
                    ),
                    title: Text('Request ID: ${request.requestId}'),
                    subtitle: Text('Status: ${request.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          TextButton(
                            onPressed: () {
                              // Call acceptRequest with the request ID
                              _requestController
                                  .acceptRequest(request.requestId.toString());
                            },
                            child: Text('Accept'),
                          ),
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          SizedBox(width: 8),
                        if (request.status != 'accepted' &&
                            request.status != 'canceled')
                          TextButton(
                            onPressed: () {
                              // Call cancelRequest with the request ID
                              _requestController
                                  .cancelRequest(request.requestId.toString());
                            },
                            child: Text('Cancel'),
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
