import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:scd_tool/main.dart';

part 'login_event.dart';
part 'login_state.dart';

Future<int> login() async{
  final response = await http.post(Uri.parse('http://127.0.0.1:5000/session'));
  return response.statusCode;
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(): super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        // Make login api call
        login().then(
          (response) {
            if(response == 200){
              emit(LoginSuccess());
            }
            emit(const LoginFailure(error: "L + ratio"));
          }
        );
      } catch(error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}