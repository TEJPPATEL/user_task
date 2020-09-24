import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:task/task.dart';
import 'package:task/task_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final dobController = TextEditingController();

  final colorController = TextEditingController();

  final stateController = TextEditingController();

  DBHelper dbHelper = new DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your name"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Pleasr Enter Valid Name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter your Address"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Pleasr Enter Valid Address";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "select DOB",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          print("Pressed on DOB");
                          final DateTime picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2021),
                          );
                          if (picked != null) {
                            print(picked);
                            setState(() {
                              dobController.text =
                                  picked.toString().split(' ')[0];
                              dobController.value = TextEditingValue(
                                  text: picked.toString().split(' ')[0]);
                            });

                            //  dobController.value = TextEditingValue.fromJSON({'date' : '25-55-2020'});
                          }
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please Enter Valid DOB";
                    }
                    return null;
                  },
                  controller: dobController,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: colorController,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Select Color",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.color_lens),
                        onPressed: () {
                          print("Pressed on Color picker");
                          return showDialog(
                            context: context,
                            child: AlertDialog(
                              title: Text("Pick Color"),
                              content: Container(
                                height: 200,
                                width: 100,
                                child: MaterialColorPicker(
                                  allowShades: false,
                                  selectedColor: Colors.red,
                                  spacing: 9.0,
                                  onMainColorChange: (ColorSwatch color) {
                                    print("called");
                                    String colorValue =
                                        color.toString().substring(35, 45);

                                    setState(() {
                                      colorController.text =
                                          colorValue.toString();
                                      colorController.value = TextEditingValue(
                                          text: colorValue.toString());
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                          // builder: (_) => MaterialColorPicker(
                          //     allowShades: false, // default true
                          //     onMainColorChange: (ColorSwatch color) {
                          //       // Handle main color changes
                          //     },
                          //     selectedColor: Colors.red),
                          // context: context);
                        },
                      )),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Pleasr Enter Valid Color Picker";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select State",
                  ),
                  // value: 'Gujarat',
                  items: [
                    DropdownMenuItem(
                      value: "Gujarat",
                      child: Text("Gujarat"),
                    ),
                    DropdownMenuItem(
                      value: "Maharashtra",
                      child: Text("Maharashtra"),
                    ),
                    DropdownMenuItem(
                      value: "Kerala",
                      child: Text("Kerala"),
                    ),
                    DropdownMenuItem(
                      value: "Tamil Nadu",
                      child: Text("Tamil Nadu"),
                    )
                  ],
                  onChanged: (value) {
                    stateController.text = value.toString();
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Select State";
                    }
                    return null;
                  },
                ),
                RaisedButton(
                    child: Text("Save"),
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        print("valid");
                        _formkey.currentState.save();
                        print(nameController.text);
                        print(addressController.text);
                        print(dobController.text);
                        print(colorController.text);
                        print(stateController.text);
                        dbHelper.insert(Task(
                            id: null,
                            name: nameController.text,
                            address: addressController.text,
                            colorCode: colorController.text,
                            dateofbirth: dobController.text,
                            state: stateController.text));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskList()));
                        // print(_formkey.currentState.);
                      }
                      // _formkey.currentState.save();

                      // List<Task> taskList = await dbHelper.getTasks();
                      // print(taskList.map((Task task) => (task.id)));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
