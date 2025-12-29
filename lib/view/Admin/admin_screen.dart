import 'package:admin/helpers/errors.dart';
import 'package:admin/services/log_in_admin_serve.dart';
import 'package:flutter/material.dart';
 import 'admin_page_request.dart';
class Admin extends StatefulWidget {
  Admin({super.key});
  @override
  State<Admin> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Admin> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle_rounded, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'Welcome back Nice to see you again',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Please Enter Name',
                          icon: Icon(Icons.account_box_rounded),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'the failed is required';
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          icon: Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        if(formKey.currentState!.validate()){
                       try {
                         await LogInAdminServe().logInAdmin(
                              nameAdmin:_emailController.text , password:_passwordController.text );
                          showSnackBar(context, "sucsses");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return AdminScreen();
                              },
                            ),
                          );
                       } on ApiException catch (e) {
                         showSnackBar(context, e.toString());
                       }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String massege) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.black,
            duration: Duration(seconds: 10),
            content: Text(massege)));
  }
}