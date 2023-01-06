import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Arithmetic Progress Generator',
    home: const APForm(),
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
            .copyWith(secondary: Colors.tealAccent)),
  ));
}

class APForm extends StatefulWidget {
  const APForm({super.key});

  @override
  State<StatefulWidget> createState() {
    return _APFormState();
  }
}

class _APFormState extends State<APForm> {
  final _formKey = GlobalKey<FormState>();

  var action = ['Print AP', 'Get nth term', 'Print Sum'];
  final minimumPadding = 5.0;
  late var currentAction = action[0];
  var displayResult = '';

  TextEditingController firstTermController = TextEditingController();
  TextEditingController cdController = TextEditingController();
  TextEditingController totalTermController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .titleMedium;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: const Text('Arithmetic Progress Generator'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(minimumPadding * 3),
            child: ListView(
              children: <Widget>[
                getAppIcon(),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 2, bottom: minimumPadding * 2),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: firstTermController,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter the first term!';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'First Term',
                        labelStyle: textStyle,
                        hintText: 'Enter the first term of AP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(minimumPadding),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 2, bottom: minimumPadding * 2),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: cdController,
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return 'Please enter the common difference!';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Common Difference',
                        labelStyle: textStyle,
                        hintText: 'Enter the common difference',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(minimumPadding),
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 2, bottom: minimumPadding * 2),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              style: textStyle,
                              controller: totalTermController,
                              validator: (String? value) {
                                if (value != null) {
                                  if (value.isEmpty) {
                                    return 'Please enter the total terms to be calculated!';
                                  } else if (int.parse(value) <= 1) {
                                    return 'Value must be > 1!';
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Total Terms',
                                labelStyle: textStyle,
                                hintText: 'Enter total terms',
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(minimumPadding),
                                ),
                              ),
                            )),
                        Container(
                          width: minimumPadding * 4,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                              items: action.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: currentAction,
                              onChanged: (String? newValueSelected) {
                                setState(() {
                                  onDropDownSelected(newValueSelected!);
                                });
                              },
                            ))
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: minimumPadding * 2, bottom: minimumPadding * 2),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme
                                    .of(context)
                                    .primaryColor,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                if (_formKey.currentState != null &&
                                    _formKey.currentState!.validate()) {
                                  displayResult = calculateAP();
                                } else {
                                  displayResult = '';
                                }
                              });
                            },
                            child: const Text(
                              'Calculate',
                              textScaleFactor: 1.2,
                            ),
                          )),
                      Container(width: minimumPadding),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              resetCalculator();
                            },
                            child: const Text(
                              'Reset',
                              textScaleFactor: 1.2,
                            )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: minimumPadding, bottom: minimumPadding),
                  child: Text(
                    displayResult,
                    style: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getAppIcon() {
    AssetImage assetImage = const AssetImage('images/calculator.png');
    Image image = Image(
      image: assetImage,
      width: 120.0,
      height: 120.0,
    );

    return Container(
      margin: EdgeInsets.all(minimumPadding * 10),
      child: image,
    );
  }

  void onDropDownSelected(String newValue) {
    setState(() {
      currentAction = newValue;
    });
  }

  String calculateAP() {
    var result = '';

    int a = int.parse(firstTermController.text);
    int d = int.parse(cdController.text);
    int n = int.parse(totalTermController.text);

    if (currentAction == action[0]) {
      result = 'The first $n terms of given AP are: \n';
      for(int i =1 ; i < n; i++){
        var data = a + (i-1)*d;
        result += '$data , ';
      }
      result += '${(a + (n-1)*d)}' '.';
    } else if (currentAction == action[1]) {
      var ans = a + (n - 1) * d;
      result = 'The ${getNTermString(n)} term of given Arithmetic progression is $ans';
    } else if (currentAction == action[2]) {
      var ans = (n / 2) * (2 * a + (n - 1) * d);
      result = 'The sum of $n terms of this Arithmetic progression is $ans';
    }

    return result;
  }

  void resetCalculator() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      firstTermController.text = '';
      cdController.text = '';
      totalTermController.text = '';
      displayResult = '';
    });
  }

  String getNTermString(int n){
    var term = '';
    switch(n){
      case 2 : {
        term = '2nd';
        break;
      }
      case 3 : {
        term = '3rd';
        break;
      }
      default:{
        term = '$n''th' ;
      }
    }
    return term;
  }
}
