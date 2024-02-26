import "package:flutter/material.dart";

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.90, //Max width
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Selected By Users Like You',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                CenterCard(),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Matches For You',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                CenterCard(),
                SizedBox(height: 20.0),
                CenterCard(),
                SizedBox(height: 20.0),
                CenterCard(),
                SizedBox(height: 20.0),
                CenterCard(),
                SizedBox(height: 20.0),
                CenterCard(),
                SizedBox(height: 20.0),
                CenterCard(),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CenterCard extends StatelessWidget {
  const CenterCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CenterDetailsPage()),
        );
      },
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/rwj_cancer_institute.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
              ),
              borderRadius: BorderRadius.circular(5.0),
            ),
            width: double.infinity,
            height: 110.0,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Treatment Center Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Treatment Center Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class CenterDetailsPage extends StatelessWidget {
  const CenterDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Center Details Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          color: Colors.black26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('images/rwj_cancer_institute.jpeg',
                  fit: BoxFit.cover, height: 160.0),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Treatment Center Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '5.0',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Treatment Center Address',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.directions_walk,
                                color: Colors.blue, size: 36.0),
                            Text('30 Min'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.directions_car,
                                color: Colors.blue, size: 36.0),
                            Text('5 Min'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.directions_transit,
                                color: Colors.blue, size: 36.0),
                            Text('20 Min'),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.directions_bike,
                                color: Colors.blue, size: 36.0),
                            Text('15 Min'),
                          ],
                        ),
                      ],
                    ),
                    Text("Treatments Offered"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    Text("Insurances Accepted"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                        Container(
                          width: 110.0,
                          height: 70.0,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
