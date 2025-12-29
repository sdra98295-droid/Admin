import 'package:admin/services/brose_apartment_service.dart';
import 'package:flutter/material.dart';
import '../../../models/apartment_browse_model.dart';
 import 'card_apartment_widget.dart';

class ApartmentRequestsPage extends StatefulWidget {
  const ApartmentRequestsPage({super.key});

  @override
  State<ApartmentRequestsPage> createState() => _ApartmentRequestsPageState();
}

class _ApartmentRequestsPageState extends State<ApartmentRequestsPage> {
  late Future<List<ApartmentBrowseModel>> waitingApartment;
  late Future<List<ApartmentBrowseModel>> approverApartment;

  @override
  void initState() {
    super.initState();
    refreshApartments();
  }

  void refreshApartments() {
    setState(() {
      waitingApartment = BrowseApartmentService().getAllApartment(status: 0);
      approverApartment = BrowseApartmentService().getAllApartment(status: 1);
    });
  }

  Widget buildApartmentList(Future<List<ApartmentBrowseModel>> future) {
    return FutureBuilder<List<ApartmentBrowseModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final apartments = snapshot.data!;
          return ListView.builder(
            itemCount: apartments.length,
            itemBuilder: (context, index) {
              return CardApartmentWidget(
                apartment: apartments[index],
                onActionDone: refreshApartments,
              );
            },
          );
        } else {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.apartment, size: 24),
                SizedBox(width: 24),
                Text(
                  "No Apartment found",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Show All User Requests",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xffBDBDBDFF),
            labelStyle: TextStyle(fontSize: 18),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            tabs: [
              Tab(icon: Icon(Icons.pending_actions), text: "Waiting"),
              Tab(icon: Icon(Icons.check_circle, color: Colors.white), text: "Approved"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildApartmentList(waitingApartment),
            buildApartmentList(approverApartment),
          ],
        ),
      ),
    );
  }
}