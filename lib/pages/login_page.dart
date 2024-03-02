import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scd_tool/main.dart';

import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
 const LoginPage({
  Key ? key
 }): super(key: key);

 @override
 _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State < LoginPage > {
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
  final loginBloc = BlocProvider.of < LoginBloc > (context);

  return Scaffold(
   appBar: AppBar(
    title: const Text('Login Screen'),
   ),
   body: BlocListener < LoginBloc, LoginState > (
    listener: (context, state) {
     if (state is LoginFailure) {
      ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(
       content: Text(state.error),
       duration: const Duration(seconds: 3),
      ));
     }
     if (state is LoginSuccess) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage(title: "SCD Tool")));
     }
    },
    child: BlocBuilder < LoginBloc, LoginState > (
     builder: (context, state) {
      return Padding(
       padding: const EdgeInsets.all(16.0),
        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: < Widget > [
          TextFormField(
           controller: _emailController,
           decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
           ),
          ),
          const SizedBox(height: 16),
           TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
             labelText: 'Password',
             border: OutlineInputBorder(),
            ),
           ),
           const SizedBox(height: 16),
            ElevatedButton(
             onPressed: state is!LoginLoading ?
             () {
              loginBloc.add(
               LoginButtonPressed(
                email: _emailController.text,
                password: _passwordController.text,
               ),
              );
             } :
             null,
             child: const Text('Login'),
            ),
            if (state is LoginLoading)
             const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
             ),
         ],
        ),
      );
     },
    ),
   ),
  );
 }
}