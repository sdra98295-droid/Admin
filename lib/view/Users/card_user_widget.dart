import 'package:admin/models/users_browse_model.dart';
import 'package:flutter/material.dart';
import '../../../services/browse _users_service.dart';
import 'package:admin/helpers/build_image_url.dart';

class CardUserWidget extends StatefulWidget {
  CardUserWidget ({required this.user,required this.onAccept});
  final UsersBrowseModel user;
  final VoidCallback ?onAccept;

  @override
  State<CardUserWidget> createState() => _CardUserWidgetState();
}

class _CardUserWidgetState extends State<CardUserWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10),
      child: Container(
        height:350,
        width: double.infinity,
        decoration:BoxDecoration(
          boxShadow:[
            BoxShadow(
              blurRadius:30,
              color: Colors.grey,
            )
          ],),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListView(
              children: [
                Text("ID:${widget.user.id} "),
                Row(
                  children: [
                    Icon(Icons.person,size:16,color: Colors.grey,),
                    Text("First Name : ${widget.user.first_name}"),
                  ],
                ),

                Row(children: [
                  Icon(Icons.person,size:16,color: Colors.grey,),
                  Text("Last Name : ${widget.user.last_name}"),
                ],),
                Row(children: [
                  Icon(Icons.phone,size:16,color: Colors.grey,),
                  Text("Mobil :${widget.user.mobile} "),
                ],),
               Row(children: [
                 Icon(Icons.calendar_month,size:16,color: Colors.grey,),
                 Text("Birth Date : ${widget.user.birth_date}"),
               ],
               ),
                Text("Created At :${widget.user.created_at}"),
                Text("Update At : ${widget.user.updated_at}"),
                SizedBox(height:10,),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                  children: [
                    if(widget.user.image==null)...[
                      Icon(Icons.image_not_supported,color: Colors.grey)

                    ]else...[
                      Image.network(BuildImageUrl().buildImageUrl(widget.user.image!),height: 100,width: 100,fit: BoxFit.fill,),
                    ],
                    if(widget.user.id_image==null)...[
                      Icon(Icons.image_not_supported,color: Colors.grey,)

                    ]else...[
                      Image.network(BuildImageUrl().buildImageUrl(widget.user.id_image!),height: 100,width: 100,fit: BoxFit.fill,),
                    ],
                   ],
                ),

                SizedBox(height:30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if(widget.user.is_approved==0)...[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black
                          ),
                          onPressed: () async {
                            await BrowseUsersService().acceptUser(widget.user.id);
                            if(widget.onAccept!=null){
                              widget.onAccept!();
                            }
                          },
                          child: Text("Accept", style: TextStyle(color: Colors
                              .white),)),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff686767FF),
                          ),
                          onPressed: () async {
                            await BrowseUsersService().rejectUser(widget.user.id);
                            if(widget.onAccept!=null){
                              widget.onAccept!();
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
                            await BrowseUsersService().rejectUser(widget.user.id);
                            if(widget.onAccept!=null){
                              widget.onAccept!();
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
    );
  }
}
