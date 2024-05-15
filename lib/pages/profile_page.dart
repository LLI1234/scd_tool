import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

import '../models/login_data.dart';

List<String> ethnicity = [
  'Caucasian',
  'African-American',
  'Hispanic',
  'Asian',
  'Native American',
  'Other'
];
List<String> insurance = [
  'Centene Corporation',
  'Humana',
  'Molina Healthcare',
  'Cigna',
  'Blue Cross Blue Shield Corporation',
  'Health Care Service Corporation',
  'Anthem Inc',
  'Aetna',
  'UnitedHealth Group',
  'Kaiser Permanente',
  'Other'
];
List<String> education = [
  'Other',
  'Discontinued high-school',
  'High School Graduate/GED Degree',
  'Associate\'s Degree',
  'Bachelor\'s Degree',
  'Master\'s Degree',
  'Doctorate Degree',
];
List<String> transportation = ['Driving', 'Transit', 'Other'];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _index = 0;
  Map<String, dynamic> user = {};
  late Future<void> _fetchUserFuture;

  Future<void> fetchUser() async {
    String cookie = context.read<LoginData>().getCookie();
    final response = await http.get(
      Uri.parse('https://scd-tool-api.onrender.com/user/current'),
      headers: {'Cookie': cookie},
    );

    if (response.statusCode == 200) {
      setState(() {
        user = Map<String, dynamic>.from(json.decode(response.body));
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserFuture = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Loading spinner
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                color: Theme.of(context).colorScheme.background,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () {
                          context.read<LoginData>().logoutUser();
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ]),
                    Icon(
                      Icons.account_circle,
                      size: 120.0,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 10.0), //SizedBox
                    Text(
                      user['first_name'] + ' ' + user['last_name'],
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 25.0), //SizedBox
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              // Define a TextEditingController for each field
                              final firstNameController = TextEditingController(
                                  text: user['first_name']);
                              final lastNameController = TextEditingController(
                                  text: user['last_name']);
                              final emailController =
                                  TextEditingController(text: user['email']);
                              final phoneNumberController =
                                  TextEditingController(
                                      text: user['phone_number']);
                              final addressController =
                                  TextEditingController(text: user['address']);
                              final dobController =
                                  TextEditingController(text: user['DoB']);

                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Edit Info'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          TextField(
                                            controller: firstNameController,
                                            decoration: InputDecoration(
                                              hintText: 'First Name',
                                              labelText: 'First Name',
                                            ),
                                          ),
                                          TextField(
                                            controller: lastNameController,
                                            decoration: InputDecoration(
                                              hintText: 'Last Name',
                                              labelText: 'Last Name',
                                            ),
                                          ),
                                          TextField(
                                            controller: emailController,
                                            decoration: InputDecoration(
                                              hintText: 'Email',
                                              labelText: 'Email',
                                            ),
                                          ),
                                          TextField(
                                            controller: phoneNumberController,
                                            decoration: InputDecoration(
                                              hintText: 'Phone Number',
                                              labelText: 'Phone Number',
                                            ),
                                          ),
                                          TextField(
                                            controller: addressController,
                                            decoration: InputDecoration(
                                              hintText: 'Address',
                                              labelText: 'Address',
                                            ),
                                          ),
                                          TextField(
                                            controller: dobController,
                                            decoration: InputDecoration(
                                              hintText: 'Date of Birth',
                                              labelText: 'Date of Birth',
                                            ),
                                          ),
                                          // Add more TextFields for other info
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () async {
                                          // Make this function asynchronous
                                          // Collect the inputs
                                          String firstName =
                                              firstNameController.text;
                                          String lastName =
                                              lastNameController.text;
                                          String email = emailController.text;
                                          String phoneNumber =
                                              phoneNumberController.text;
                                          String address =
                                              addressController.text;
                                          String dob = dobController.text;

                                          // Create a map of the data
                                          Map<String, String> data = {
                                            'first_name': firstName,
                                            'last_name': lastName,
                                            'email': email,
                                            'phone_number': phoneNumber,
                                            'address': address,
                                            'DoB': dob,
                                          };

                                          // Convert the data to JSON
                                          String body = json.encode(data);

                                          String cookie = context
                                              .read<LoginData>()
                                              .getCookie();

                                          // Send the data to the backend
                                          var response = await http.put(
                                            Uri.parse(
                                                'https://scd-tool-api.onrender.com/user/current'), // Replace with your backend URL
                                            headers: {
                                              "Content-Type":
                                                  "application/json",
                                              "Cookie": cookie,
                                            },
                                            body: body,
                                          );

                                          // Check the status code of the response
                                          if (response.statusCode == 200) {
                                            print('Data sent successfully');
                                          } else {
                                            print('Failed to send data');
                                          }

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              'Edit Info',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['email'],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['phone_number'],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Text(
                                'Address',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          Flexible(
                              child: Text(
                            user['address'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0))),
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Date of Birth',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['DoB'],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0), //SizedBox
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Additional Information',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            final incomeController = TextEditingController(
                                text: user['income'].toString());
                            String selectedEthnicity = user["ethnicity"];
                            String selectedInsurance =
                                user["insurance"]["name"];
                            selectedInsurance =
                                selectedInsurance.replaceAll('_', ' ');
                            selectedInsurance =
                                selectedInsurance.split(' ').map((word) {
                              return word[0].toUpperCase() + word.substring(1);
                            }).join(' ');
                            String selectedTransportation =
                                user["preferred_transportation"];
                            selectedTransportation =
                                selectedTransportation[0].toUpperCase() +
                                    selectedTransportation.substring(1);
                            String selectedEducation =
                                education[int.parse(user['education'])];

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                    title: Text('Edit Info'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: 300,
                                            child: DropdownButton<String>(
                                              value: selectedEthnicity,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedEthnicity = newValue!;
                                                });
                                              },
                                              items: ethnicity.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            child: DropdownButton<String>(
                                              value: selectedInsurance,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedInsurance = newValue!;
                                                });
                                              },
                                              items: insurance.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            child: DropdownButton<String>(
                                              value: selectedTransportation,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedTransportation =
                                                      newValue!;
                                                });
                                              },
                                              items: transportation.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          Container(
                                            width: 300,
                                            child: DropdownButton<String>(
                                              value: selectedEducation,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedEducation = newValue!;
                                                });
                                              },
                                              items: education.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          TextField(
                                            controller: incomeController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: 'Income',
                                              labelText: 'Income',
                                            ),
                                          ),
                                          // Add more TextFields and DropdownButtons for other info
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Save'),
                                        onPressed: () async {
                                          // Collect the inputs and send them to the backend
                                          String formatted_insurance;
                                          if (selectedInsurance !=
                                              'UnitedHealth Group') {
                                            formatted_insurance =
                                                selectedInsurance
                                                    .toLowerCase()
                                                    .replaceAll(' ', '_');
                                          } else {
                                            formatted_insurance =
                                                'unitedHealth_group';
                                          }
                                          // Create a map of the data
                                          Map<String, dynamic> data = {
                                            'ethnicity': selectedEthnicity,
                                            'preferred_transportation':
                                                selectedTransportation
                                                    .toLowerCase(),
                                            'education': education
                                                .indexOf(selectedEducation)
                                                .toString(),
                                            'income': int.parse(
                                                incomeController.text),
                                          };

                                          // Convert the data to JSON
                                          String body = json.encode(data);

                                          print(body);

                                          String cookie = context
                                              .read<LoginData>()
                                              .getCookie();

                                          // Send the data to the backend
                                          var response = await http.put(
                                            Uri.parse(
                                                'https://scd-tool-api.onrender.com/user/current'), // Replace with your backend URL
                                            headers: {
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                              "Cookie": cookie,
                                            },
                                            body: body,
                                          );

                                          // Check the status code of the response
                                          if (response.statusCode == 200) {
                                            print('Data sent successfully');
                                          } else {
                                            print('Failed to send data');
                                            print(response.statusCode);
                                          }

                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                          },
                          child: Text(
                            'Edit Info',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Ethnicity',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['ethnicity'],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Insurance Provider',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['insurance']['name']
                                .split('_')
                                .map((str) =>
                                    '${str[0].toUpperCase()}${str.substring(1)}')
                                .join(' '),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Preferred Transportation',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['preferred_transportation'][0].toUpperCase() +
                                user['preferred_transportation'].substring(1),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Education',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            education[int.parse(user['education'])],
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              bottomRight: Radius.circular(10.0))),
                      margin: EdgeInsets.only(top: 3.0),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user['income'].toString(),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0), //SizedBox
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
