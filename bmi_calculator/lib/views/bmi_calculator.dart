// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:bmi_calculator/dtos/person.dart';
import 'package:flutter/material.dart';

import 'calculated_page.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key, required this.title});

  final String title;

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  double _currentHeight = 150;
  String gender = "MALE";
  int _weight = 50;
  int _age = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(child: Text(widget.title)),
      ),
      body: Column(
        children: [
          _buildGender(),
          Expanded(child: Container()),
          _buildHeight(),
          Expanded(child: Container()),
          _buildIndicator(),
          Expanded(child: Container()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(40),
              shape: BeveledRectangleBorder(),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculatedPage(
                      person: Person(
                        age: _age,
                        gender: gender,
                        height: _currentHeight,
                        weight: _weight,
                      ),
                    ),
                  ));
            },
            child: Container(
                margin: EdgeInsets.all(15),
                child: Text(
                  'CALCULATE',
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Container _buildHeight() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "HEIGHT",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _currentHeight.toStringAsFixed(1),
                    style: TextStyle(fontSize: 30),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text('cm'),
                  ),
                ],
              ),
              Slider(
                value: _currentHeight,
                min: 50,
                max: 300,
                onChanged: (value) {
                  setState(() {
                    _currentHeight = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGender() {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
      ),
      children: [
        GridTile(
          child: radioMaterialButton("MALE"),
        ),
        GridTile(
          child: radioMaterialButton("FEMALE"),
        ),
      ],
    );
  }

  Widget radioMaterialButton(label) {
    var color1 = Theme.of(context).cardColor.withGreen(100);
    var color2 = Theme.of(context).cardColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: MaterialButton(
        onPressed: () {
          gender = label;
          setState(() {});
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15.0), // Adjust the border radius as needed
        ),
        color: gender == label ? color1 : color2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(label == "MALE" ? Icons.male : Icons.female, size: 75),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          Card(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "WEIGHT",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _weight.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('kg'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: CircleBorder(),
                      color: Colors.white,
                      onPressed: () => setState(() {
                        _weight--;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.remove),
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
                      color: Colors.white,
                      onPressed: () => setState(() {
                        _weight++;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AGE",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _age.toString(),
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: CircleBorder(),
                      color: Colors.white,
                      onPressed: () => setState(() {
                        _age--;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.remove),
                      ),
                    ),
                    MaterialButton(
                      shape: CircleBorder(),
                      color: Colors.white,
                      onPressed: () => setState(() {
                        _age++;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
