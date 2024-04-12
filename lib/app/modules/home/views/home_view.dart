import 'package:donor_blood/app/modules/DonationHistory/views/donation_history_view.dart';
import 'package:donor_blood/app/modules/payment/views/payment_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../Donors/views/donors_view.dart';

import '../controllers/home_controller.dart';
import '../../../components/donor_card.dart';
import '../../../models/donorModel.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Blood'),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () async {
              Get.toNamed(Routes.NOTIFICATIONS);
            },
            icon: const Icon(Icons.notifications),
          )
        ],
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          if (controller.donors == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.getDonors,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await showSearch(
                          context: context,
                          delegate: SearchView(),
                        );
                      },
                      child: Container(
                        height: 60,
                        padding: EdgeInsets.only(
                          right: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Color.fromRGBO(218, 218, 218, 1),
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 120,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // Adjust as needed
                        children: [
                          _buildFunctionalityContainer(
                              context, 'Become Donor', Icons.person_add, () {
                            // Navigate to Add Donor Screen
                            Get.to(() => DonorFormView());
                          }),
                          _buildFunctionalityContainer(
                              context, 'Donation History', Icons.request_page,
                              () {
                            Get.to(() => DonationHistoryView());
                          }),
                          _buildFunctionalityContainer(
                              context, 'Donation', Icons.favorite, () {
                            Get.to(
                              () => PaymentView(),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Donors List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: controller.donors?.donors?.length ??
                          0, // Correctly accessing the list of DonorElement objects
                      itemBuilder: (context, index) {
                        return DonorCard(
                            donor: controller.donors!.donors![
                                index]); // Correctly accessing the DonorElement object
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Functionality Container Widget
  Widget _buildFunctionalityContainer(BuildContext context, String title,
      IconData iconData, Function() onPressed) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Color.fromRGBO(218, 218, 218, 1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 40,
                color: Colors.red,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchView extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return null;
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var homeController = Get.find<HomeController>();
    List<DonorElement> suggestions =
        []; // Change this line to use List<DonorElement>

    var newQuery = query.toLowerCase().trim();
    // Assuming homeController.donors is of type Donor and contains the list of DonorElement objects
    suggestions = homeController.donors?.donors
            ?.where(
              (donorElement) =>
                  (donorElement.fullName?.toLowerCase().contains(newQuery) ??
                      false) ||
                  (donorElement.bloodType?.toLowerCase().contains(newQuery) ??
                      false),
            )
            .toList() ??
        [];
    return suggestions.isEmpty
        ? Center(
            child: Text(
              'No Donor found ',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 250,
                  child: DonorCard(
                      donor: suggestions[
                          index])); // Now passing a DonorElement object
            },
          );
  }
}
