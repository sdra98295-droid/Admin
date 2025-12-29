import 'package:admin/helpers/build_image_url.dart';
import 'package:admin/services/brose_apartment_service.dart';
import 'package:flutter/material.dart';
import '../../../models/apartment_browse_model.dart';
  
class CardApartmentWidget extends StatelessWidget {
  const CardApartmentWidget({
    super.key,
    required this.apartment,
    required this.onActionDone,
  });

  final ApartmentBrowseModel apartment;
  final VoidCallback onActionDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height:500,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 30,
              color: Colors.grey,
            ),
          ],
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID: ${apartment.id}"),
                  Row(
                    children: [
                      Icon(Icons.location_on,size: 20,color: Colors.grey,),
                      Text("Apartment Location :"),
                    ],
                  ),
                  Text("- City: ${apartment.city}"),
                  Text("- Country: ${apartment.country}"),
              
                  Row(
                    children: [
                      Icon(Icons.apartment,size: 20,color: Colors.grey,),
                      Text("Apartment Details :"),
                    ],
                  ),
                  Text("- Space: ${apartment.space}"),
                  Text("- Price: ${apartment.price}"),
                  Text("- Rooms: ${apartment.rooms}"),
                  Text("- Description :${apartment.description}"),
                  Row(
                    children: [
                      Icon(Icons.person,size: 20,color: Colors.grey,),
                      Text("Apartment Owner Details :"),
                    ],
                  ),
                  Text(
                    apartment.owner != null
                        ? "- Owner: ${apartment.owner!.firstName} ${apartment.owner!.lastName}"
                        : "Owner: Not assigned yet",
                  ),
                  const SizedBox(height: 10),
                  if(apartment.contractImage==null)...[
                    Icon(Icons.image_not_supported,color: Colors.grey)
              
                  ]else...[
                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Image Apartnent Contract : "),
                        Image.network(BuildImageUrl().buildImageUrl(apartment.contractImage!),height:150,width:150,fit: BoxFit.fill,),
                      ],
                    ),
                  ],
                  SizedBox(
                    height: 10,
                  ),
                  /// 🔹 Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if(apartment.status==0)...[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black
                            ),
                            onPressed: () async {
                              await BrowseApartmentService().acceptApartment(apartment.id);
                              if(onActionDone!=null){
                                onActionDone!();
                              }
                            },
                            child: Text("Accept", style: TextStyle(color: Colors
                                .white),)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff686767FF),
                            ),
                            onPressed: () async {
                              await BrowseApartmentService().rejectApartment(apartment.id);
                              if(onActionDone!=null){
                                onActionDone!();
                              }
                            },
                            child: Text("Reject",
                              style: TextStyle(color: Colors.white),)),
                      ]else ...[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () async {
                              await BrowseApartmentService().rejectApartment(apartment.id);
                              if(onActionDone!=null){
                                onActionDone!();
                              }
                            },
                            child: Text("Delet",
                              style: TextStyle(color: Colors.white),)),
                      ],
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}