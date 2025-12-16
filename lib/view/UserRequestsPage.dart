import 'package:flutter/material.dart';
import '../../../services/browse _users_service.dart';
import 'package:admin/models/users_browse_model.dart';
import 'card_user_widget.dart';

class UserRequestsPage extends StatefulWidget {
  UserRequestsPage({super.key});

  @override
  State<UserRequestsPage> createState() => _UserRequestsPageState();

}

class _UserRequestsPageState extends State<UserRequestsPage> {
  @override
  late Future<List<UsersBrowseModel>>waitingUsers;
  late Future<List<UsersBrowseModel>>approverUsers;

  void initState() {
    super.initState();
    refreshUsers();
  }
  void refreshUsers(){
    setState(() {
      waitingUsers= BrowseUsersService().getAllusers(isApproved:0 );
      approverUsers=BrowseUsersService().getAllusers(isApproved: 1);
    });
  }


  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme:IconThemeData(color: Colors.white),
          title: Text("show all request user",style: TextStyle(color: Colors.white),),backgroundColor: Colors.black,
          bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xffBDBDBDFF),
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelStyle: TextStyle(fontSize: 14),
              tabs:[
                Tab(
                  icon:Icon(Icons.pending_actions) ,
                  text:"Waiting",
                ),
                Tab(
                  icon:Icon(Icons.check_circle,color: Colors.white,),
                  text: "Approved",
                )
              ] ),),
        body: Container(
          child: TabBarView(children: [
            FutureBuilder<List<UsersBrowseModel>>(
              future: waitingUsers,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  List<UsersBrowseModel>users=snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context,index){
                      return CardUserWidget(user:users[index],
                        onAccept: refreshUsers,);
                    },
                  );
                } if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                      child: CircularProgressIndicator());
                }
                else{
                  return Center(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.account_circle_outlined,size: 24,),
                          SizedBox(width: 24,),
                          Text("No users found",style: TextStyle(fontSize:24,),),
                        ],
                      ),
                    ),
                  );
                }
              },

            ),
            FutureBuilder<List<UsersBrowseModel>>(
              future: approverUsers,
              builder: (context,snapshot){
                print("body:${snapshot.data}");
                if(snapshot.hasData){
                  List<UsersBrowseModel>users=snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context,index){
                      return CardUserWidget(user:users[index],onAccept:refreshUsers);
                    },
                  );
                }
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                      child: CircularProgressIndicator());
                }
                else{

                  return Center(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.account_circle_outlined,size: 24,),
                          SizedBox(width: 24,),
                          Text("No users found",style: TextStyle(fontSize:24,),),
                        ],
                      ),
                    ),
                  );

                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}