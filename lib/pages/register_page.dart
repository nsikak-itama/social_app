import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/My_button.dart';
import 'package:social_app/components/My_text_field.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';
import 'package:social_app/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async{
    if(confirmPasswordController.text != passwordController.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords must match")));
      return;
    } final _authService = Provider.of<AuthService>(context, listen: false);
    try{
      await _authService.signUpWithEmailAndPassword(emailController.text, passwordController.text, nameController.text);
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  } 

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text("Meddle", style: TextStyle(fontSize: 40, fontFamily: "Inter"),),
            SizedBox(height: 50),
            Text("Welcome, We are happy to have you", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            SizedBox(height: 20),
            MyTextField(hintText: 'Name', controller: nameController, obscureText: false),
            SizedBox(height: 10),
            MyTextField(hintText: 'Email address', controller: emailController, obscureText: false),
            SizedBox(height: 10),
            MyTextField(hintText: 'Password', controller: passwordController, obscureText: true),
            SizedBox(height: 10),
            MyTextField(hintText: 'Confirm Password', controller: confirmPasswordController, obscureText: true),
            SizedBox(height: 10),
            MyButton(text: "Sign up", onTap: signUp),
            SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text("Already have an account?"),
              GestureDetector(
                onTap: widget.onTap,
                child: Text("sign in", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),)
              ),
              
              ],),
            )
          ],
          ),
        ),
      ), backgroundColor: Theme.of(context).colorScheme.background,

    );
  }
}