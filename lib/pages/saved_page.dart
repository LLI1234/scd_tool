import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../components/match_card.dart';
import '../models/app_data.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  bool get wantKeepAlive => context.watch<AppData>().savedPhysicians.isNotEmpty;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AppData>().getSavedPhysicians();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppData>(
      builder: (context, appData, child) {
        if (appData.savedPhysicians.isEmpty && !appData.error) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(), // Loading spinner
            ),
          );
        } else if (appData.error) {
          return Text('Error: Failed to fetch saved physicians');
        } else {
          return Scaffold(
            body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Saved Physicians',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    ...appData.savedPhysicians.map((physician) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: MatchCard(
                          physician: physician,
                          hasScore: false,
                          hasVisited: true,
                        ),
                      );
                    }),
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
