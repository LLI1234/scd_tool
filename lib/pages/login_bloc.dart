import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scd_tool/api/api_service.dart';
import '../models/login_model.dart';

// import 'dart:io';
// import 'package:scd_tool/main.dart';

part 'login_event.dart';
part 'login_state.dart';

class APILogin {}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    APIService apiService = APIService();
    on<LoginButtonPressed>((event, emit) async {
      LoginRequestModel reqMod =
          LoginRequestModel(email: event.email, password: event.password);
      emit(LoginLoading());

      try {
        // Make login api call
        LoginResponseModel response = await apiService.login(reqMod);
        if (response.token.isNotEmpty) {
          emit(LoginSuccess(token: response.token));
        } else {
          emit(const LoginFailure(error: "fail"));
        }
      } catch (error) {
        emit(LoginFailure(error: error.toString()));
      }
    });
  }
}
