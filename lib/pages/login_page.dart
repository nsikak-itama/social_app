import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/My_button.dart';
import 'package:social_app/components/My_text_field.dart';
import 'package:social_app/pages/register_page.dart';
import 'package:social_app/responsive/constrained_scaffold.dart';
import 'package:social_app/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInUser() async{
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(emailController.text, passwordController.text);
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
            Text("Welcome back! Please login to your account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.grey[700]),),
            SizedBox(height: 20),
            MyTextField(hintText: 'Email address', controller: emailController, obscureText: false),
            SizedBox(height: 10),
            MyTextField(hintText: 'Password', controller: passwordController, obscureText: true),
            SizedBox(height: 10),
            MyButton(text: "Sign in", onTap: signInUser),
            SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              Text("Don't have an account?"),
              GestureDetector(
                onTap: widget.onTap,
                child: Text("Sign Up", style: TextStyle(color: Colors.blue))
              )
              ],),
            )
          ],
          ),
        ),
      ), backgroundColor: Theme.of(context).colorScheme.background,

    );
  }
}