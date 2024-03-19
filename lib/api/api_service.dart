import 'dart:convert';
import 'package:scd_tool/models/login_model.dart';
import 'package:http/http.dart' as http;

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async{
    
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/session/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestModel)
    );
    // print(requestModel.toJson());
    if(response.statusCode == 200) {
      // print(response.headers['set-cookie']!.substring(9));
      return LoginResponseModel(token: response.headers['set-cookie']!.substring(9, response.headers['set-cookie']!.indexOf(';')), error: "");
    }
    else if(response.statusCode == 401){
      return LoginResponseModel(token: "", error: "Login Failed");
    } 
    else {
      throw Exception('Failed to load data!');
    }
  }
}