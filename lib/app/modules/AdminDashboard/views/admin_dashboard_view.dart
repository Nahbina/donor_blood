// AdminDashboardView.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  _AdminDashboardViewState createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  late AdminDashboardController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(AdminDashboardController());
    // Fetch data initially
    _controller.getStats();
    // Start periodic data update every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      _controller.getStats();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: GetBuilder<AdminDashboardController>(
          init: _controller,
          builder: (controller) {
            if (controller.statsResponse != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreeting(controller),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildDataContainer(
                        'Total Events: ${controller.statsResponse!.stats!.noOfEvents}',
                      ),
                      _buildDataContainer(
                        'Total Income: ${controller.statsResponse!.stats!.totalIncome}',
                      ),
                      _buildDataContainer(
                        'Total Blood Requests: ${controller.statsResponse!.stats!.totalBloodRequests}',
                      ),
                      _buildDataContainer(
                        'Total Donors: ${controller.statsResponse!.stats!.totalDonors}',
                      ),
                      _buildDataContainer(
                        'Total Users: ${controller.statsResponse!.stats!.totalUsers}',
                      ),
                      _buildDataContainer(
                        'Unique Donors: ${controller.statsResponse!.stats!.totalUniqueDonors}',
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildColumnChart(controller),
                        ),
                        Expanded(
                          child: _buildPieChart(controller),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildDataContainer(String data) {
    return Card(
      elevation: 15,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(12.0),
        height: 80,
        child: Center(
          child: Text(
            data,
            style: TextStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(AdminDashboardController controller) {
    var now = DateTime.now();
    var formatter = DateFormat('HH');
    var hour = int.parse(formatter.format(now));

    String greeting = '';

    if (hour >= 5 && hour < 12) {
      greeting = 'Good morning';
    } else if (hour >= 12 && hour < 18) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    String fullName = controller.user?.user?.fullName ?? '';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            '$greeting, $fullName',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildColumnChart(AdminDashboardController controller) {
    List<Data> chartData = [
      Data('Events',
          double.parse(controller.statsResponse!.stats!.noOfEvents ?? '0')),
      Data('Income',
          double.parse(controller.statsResponse!.stats!.totalIncome ?? '0')),
      Data(
          'Blood Requests',
          double.parse(
              controller.statsResponse!.stats!.totalBloodRequests ?? '0')),
      Data('Donors',
          double.parse(controller.statsResponse!.stats!.totalDonors ?? '0')),
      Data('Users',
          double.parse(controller.statsResponse!.stats!.totalUsers ?? '0')),
      Data(
          'Unique Donors',
          double.parse(
              controller.statsResponse!.stats!.totalUniqueDonors ?? '0')),
    ];

    return Container(
      height: 400,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: BarChart(
        _createChartData(chartData),
        swapAnimationDuration: Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildPieChart(AdminDashboardController controller) {
    List<PieChartSectionData> pieChartData = [
      PieChartSectionData(
        value: double.parse(controller.statsResponse!.stats!.noOfEvents ?? '0'),
        color: Colors.blue,
        title: 'Events',
      ),
      PieChartSectionData(
        value: double.parse(controller.statsResponse!.stats!.totalUsers ?? '0'),
        color: Colors.red,
        title: 'Total Users',
      ),
      PieChartSectionData(
        value: double.parse(
            controller.statsResponse!.stats!.totalBloodRequests ?? '0'),
        color: Colors.green,
        title: 'Blood Requests',
      ),
      PieChartSectionData(
        value:
            double.parse(controller.statsResponse!.stats!.totalDonors ?? '0'),
        color: Colors.orange,
        title: 'Donors',
      ),
    ];

    return Container(
      height: 400,
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sections: pieChartData,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: pieChartData.map((data) {
                return Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: data.color,
                    ),
                    SizedBox(width: 5),
                    Text('${data.title}'),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData _createChartData(List<Data> chartData) {
    List<BarChartGroupData> barGroups = [];

    for (int i = 0; i < chartData.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              y: chartData[i].value,
              colors: [Colors.blue],
            ),
          ],
        ),
      );
    }

    return BarChartData(
      groupsSpace: 0,
      barGroups: barGroups,
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          margin: 16,
          getTitles: (double value) {
            if (value >= 0 && value < chartData.length) {
              return chartData[value.toInt()].category;
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
    );
  }
}

class Data {
  final String category;
  final double value;

  Data(this.category, this.value);
}
