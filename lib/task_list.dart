import 'package:flutter/material.dart';
import 'package:task/main.dart';
import 'package:task/task.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All USER"),
      ),
      body: Container(
        // color: Colors.redAccent,
        height: MediaQuery.of(context).size.height * 0.8,
        child: FutureBuilder<List<Task>>(
          future: DBHelper().getTasks(),
          builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
            return snapshot.hasData
                ? snapshot.data.length != 0
                    ? ListView.separated(
                        padding: EdgeInsets.all(10),
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                        itemBuilder: (context, index) => Container(
                          color: Color(int.parse(
                              snapshot.data[index].colorCode.toString() ??
                                  '0xff009688')),
                          child: ListTile(
                            title: Text(snapshot.data[index].name),
                          ),
                        ),
                        itemCount: snapshot.data.length,
                      )
                    : CircularProgressIndicator()
                : CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
