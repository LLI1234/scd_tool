// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:im_stepper/stepper.dart';
import 'package:scd_tool/components/personality_slider.dart';

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
  'Discontinued high-school (without completion)',
  'High School Graduate/GED Degree',
  'Associate\'s Degree',
  'Bachelor\'s Degree',
  'Master\'s Degree',
  'Doctorate Degree',
  'Other'
];
List<String> preferredTransporation = ['Driving', 'Transit', 'Other'];
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
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> demographicFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> personalFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create an account'),
          backgroundColor: Colors.transparent,
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
            const Center(
              child: Text(
                'Humble vs Ambitious',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Slider(
              value: selectedHumbleAmbitious,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (double value) {
                setState(() {
                  selectedHumbleAmbitious = value;
                });
              },
            ),
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
                'Ethnicity',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              DropdownButton<String>(
                  value: selectedEthnicity,
                  items: ethnicity
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child:
                              Text(item, style: const TextStyle(fontSize: 20))))
                      .toList(),
                  onChanged: (item) =>
                      setState(() => selectedEthnicity = item)),
              const Text(
                'Education Level',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              DropdownButton<String>(
                  value: selectedEducation,
                  items: education
                      .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child:
                              Text(item, style: const TextStyle(fontSize: 20))))
                      .toList(),
                  onChanged: (item) =>
                      setState(() => selectedEducation = item)),
              const Text(
                'Insurance',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Enter current insurance',
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)))),
              ),
              const Text(
                'Income',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Enter yearly income',
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)))),
              ),
              const Text('How much travel time are you willing to allocate?',
                  style: TextStyle(fontSize: 24.0)),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Enter time in total minutes',
                    errorStyle: TextStyle(fontSize: 18.0),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)))),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  child: ElevatedButton(
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
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
                        'Next',
                        style: TextStyle(color: Colors.blue, fontSize: 16),
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
