// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:im_stepper/stepper.dart';
import 'package:scd_tool/components/personality_slider.dart';
import 'package:scd_tool/pages/login_page.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

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
  'Discontinued high-school',
  'High School Graduate/GED Degree',
  'Associate\'s Degree',
  'Bachelor\'s Degree',
  'Master\'s Degree',
  'Doctorate Degree',
  'Other'
];
List<String> transportation = ['Driving', 'Transit', 'Other'];
String? selectedEthnicity = 'Other';
String? selectedInsurance = 'Other';
String? selectedTransportation = 'Other';
String? selectedEducation = 'Other';
double selectedConciseOutgoing = 5;
double selectedCompassionateAnalytical = 5;
double selectedOrganizedFlexible = 5;
double selectedRespectfulCurious = 5;
double selectedHumbleAmbitious = 5;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int activeIndex = 0;
  int totalIndex = 3;
  Map userData = {};
  String _income = "";
  String _travelTime = "";
  String _firstName = "";
  String _lastName = "";
  String _email = "";
  String _password = "";
  String _phoneNumber = "";
  String _DoB = "";
  String _address = "";
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> demographicFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> personalFormKey = GlobalKey<FormState>();

  late final TextEditingController _incomeController;
  late final TextEditingController _travelTimeController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _DoBController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController()
      ..addListener(() {
        setState(() {
          _income = _incomeController.text.trim();
        });
      });
    _travelTimeController = TextEditingController()
      ..addListener(() {
        setState(() {
          _travelTime = _travelTimeController.text.trim();
        });
      });
    _firstNameController = TextEditingController()
      ..addListener(() {
        setState(() {
          _firstName = _firstNameController.text.trim();
        });
      });
    _lastNameController = TextEditingController()
      ..addListener(() {
        setState(() {
          _lastName = _lastNameController.text.trim();
        });
      });
    _emailController = TextEditingController()
      ..addListener(() {
        setState(() {
          _email = _emailController.text.trim();
        });
      });
    _passwordController = TextEditingController()
      ..addListener(() {
        setState(() {
          _password = _passwordController.text.trim();
        });
      });
    _phoneNumberController = TextEditingController()
      ..addListener(() {
        setState(() {
          _phoneNumber = _phoneNumberController.text.trim();
        });
      });
    _DoBController = TextEditingController()
      ..addListener(() {
        setState(() {
          _DoB = _DoBController.text.trim();
        });
      });
    _addressController = TextEditingController()
      ..addListener(() {
        setState(() {
          _address = _addressController.text.trim();
        });
      });
  }

  Future<void> _submitForm() async {
    final String email = _email;
    final String password = _password;
    final String first_name = _firstName;
    final String last_name = _lastName;
    final String dob = _DoB;
    final String phone_number = _phoneNumber;
    final String address = _address;
    final String formatted_ethnicity = selectedEthnicity!;
    final String formatted_education =
        (education.indexOf(selectedEducation!) + 1).toString();
    final String formatted_insurance;
    final int income = int.parse(_income);
    final int max_travel_time = int.parse(_travelTime);
    final String preferred_transportation =
        selectedTransportation!.toLowerCase();
    final double attribute1 = selectedConciseOutgoing / 10;
    final double attribute2 = selectedCompassionateAnalytical / 10;
    final double attribute3 = selectedOrganizedFlexible / 10;
    final double attribute4 = selectedRespectfulCurious / 10;
    final double attribute5 = selectedHumbleAmbitious / 10;

    if (selectedInsurance != 'UnitedHealth Group') {
      formatted_insurance =
          selectedInsurance!.toLowerCase().replaceAll(' ', '_');
    } else {
      formatted_insurance = 'unitedHealth_group';
    }

    final response = await http.post(Uri.parse('http://127.0.0.1:5000/user'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
          "first_name": first_name,
          "last_name": last_name,
          "DoB": dob,
          "phone_number": phone_number,
          "address": address,
          "ethnicity": formatted_ethnicity,
          "education": formatted_education,
          "insurance": formatted_insurance,
          "income": income,
          "max_travel_time": max_travel_time,
          "preferred_transportation": preferred_transportation,
          "attribute1": attribute1,
          "attribute2": attribute2,
          "attribute3": attribute3,
          "attribute4": attribute4,
          "attribute5": attribute5,
        }));

    if (response.statusCode == 201) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registration Page'),
        ),
        body: bodyBuilder());
  }

  Widget bodyBuilder() {
    switch (activeIndex) {
      case 0:
        return basicDetails();
      case 1:
        return demographicDetails();
      case 2:
        return personalDetails();
      default:
        return basicDetails();
    }
  }

  Widget personalDetails() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: personalFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: DotStepper(
                activeStep: activeIndex,
                dotCount: totalIndex,
                dotRadius: 16.0,
                shape: Shape.pipe,
                spacing: 10.0,
                onDotTapped: ((tappedDotIndex) {
                  setState(() {
                    activeIndex = tappedDotIndex;
                  });
                }),
              ),
            ),
            Text(
              "Step ${activeIndex + 1} of $totalIndex",
              style: const TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Center(),
            ),
            const Text(
              'Please describe yourself by following these prompts',
              style: TextStyle(fontSize: 20),
            ),
            PersonalitySlider(
                title: 'Concise vs Outgoing',
                value: selectedConciseOutgoing,
                onChanged: (double value) {
                  setState(() {
                    selectedConciseOutgoing = value;
                  });
                }),
            PersonalitySlider(
                title: 'Compassionate vs Analytical',
                value: selectedCompassionateAnalytical,
                onChanged: (double value) {
                  setState(() {
                    selectedCompassionateAnalytical = value;
                  });
                }),
            PersonalitySlider(
                title: 'Organized vs Flexible',
                value: selectedOrganizedFlexible,
                onChanged: (double value) {
                  setState(() {
                    selectedOrganizedFlexible = value;
                  });
                }),
            PersonalitySlider(
                title: 'Respectful vs Curious',
                value: selectedRespectfulCurious,
                onChanged: (double value) {
                  setState(() {
                    selectedRespectfulCurious = value;
                  });
                }),
            PersonalitySlider(
                title: 'Humble vs Ambitious',
                value: selectedHumbleAmbitious,
                onChanged: (double value) {
                  setState(() {
                    selectedHumbleAmbitious = value;
                  });
                }),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                child: ElevatedButton(
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                    onPressed: () {
                      if (personalFormKey.currentState?.validate() ?? false) {
                        _submitForm();
                      }
                    }),
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
            )),
          ],
        ),
      ),
    ));
  }

  Widget demographicDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: demographicFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: DotStepper(
                  activeStep: activeIndex,
                  dotCount: totalIndex,
                  dotRadius: 16.0,
                  shape: Shape.pipe,
                  spacing: 10.0,
                  onDotTapped: ((tappedDotIndex) {
                    setState(() {
                      activeIndex = tappedDotIndex;
                    });
                  }),
                ),
              ),
              Text(
                "Step ${activeIndex + 1} of $totalIndex",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Ethnicity',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedEthnicity,
                      isExpanded: true,
                      items: ethnicity
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal))))
                          .toList(),
                      onChanged: (item) =>
                          setState(() => selectedEthnicity = item)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Education Level',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedEducation,
                      isExpanded: true,
                      items: education
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal))))
                          .toList(),
                      onChanged: (item) =>
                          setState(() => selectedEducation = item)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Insurance',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: selectedInsurance,
                      isExpanded: true,
                      items: insurance
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal))))
                          .toList(),
                      onChanged: (item) =>
                          setState(() => selectedInsurance = item)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Income',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _incomeController,
                    decoration: const InputDecoration(
                        hintText: 'Enter yearly income',
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  )),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('How much travel time are you willing to allocate?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _travelTimeController,
                  decoration: const InputDecoration(
                      hintText: 'Enter time in total minutes',
                      errorStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius:
                              BorderRadius.all(Radius.circular(9.0)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('What\s your preferred mode of transportation?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedTransportation,
                        items: transportation
                            .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal))))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedTransportation = item))),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: ElevatedButton(
                    child: const Text(
                      'Next page',
                      style: TextStyle(color: Colors.red, fontSize: 22),
                    ),
                    onPressed: () {
                      if (demographicFormKey.currentState?.validate() ??
                          false) {
                        // next
                        setState(() {
                          activeIndex++;
                        });
                      }
                    },
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget basicDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
            key: basicFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: DotStepper(
                    activeStep: activeIndex,
                    dotCount: totalIndex,
                    dotRadius: 16.0,
                    shape: Shape.pipe,
                    spacing: 10.0,
                    onDotTapped: ((tappedDotIndex) {
                      setState(() {
                        activeIndex = tappedDotIndex;
                      });
                    }),
                  ),
                ),
                Text(
                  "Step ${activeIndex + 1} of $totalIndex",
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _firstNameController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter first name')]),
                    decoration: const InputDecoration(
                        hintText: 'Enter first Name',
                        labelText: 'First name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _lastNameController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter last name')]),
                    decoration: const InputDecoration(
                        hintText: 'Enter last Name',
                        labelText: 'Last name',
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _DoBController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter Date of Birth')]),
                    decoration: const InputDecoration(
                        hintText: 'yyyy-mm-dd',
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.red,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _addressController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter Address')]),
                    decoration: const InputDecoration(
                        hintText: '123 Main St, City, State, Zipcode',
                        labelText: 'Address',
                        prefixIcon: Icon(
                          Icons.home,
                          color: Colors.green,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Enter email address'),
                      EmailValidator(
                          errorText: 'Please enter a valid email address'),
                    ]),
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.lightBlue,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter password')]),
                    decoration: const InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.password,
                          color: Colors.red,
                        ),
                        errorStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9.0)))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    validator: MultiValidator(
                        [RequiredValidator(errorText: 'Enter mobile number')]),
                    decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        labelText: 'Phone Number',
                        prefixIcon: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius:
                                BorderRadius.all(Radius.circular(9)))),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    child: ElevatedButton(
                      child: const Text(
                        'Next page',
                        style: TextStyle(color: Colors.red, fontSize: 22),
                      ),
                      onPressed: () {
                        if (basicFormKey.currentState?.validate() ?? false) {
                          // next
                          setState(() {
                            activeIndex++;
                          });
                        }
                      },
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                  ),
                )),
              ],
            )),
      ),
    );
  }
}
