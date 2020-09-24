import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Task {
  int id;
  String name;
  String address;
  String dateofbirth;
  String colorCode;
  String state;
  Task(
      {this.id,
      this.name,
      this.address,
      this.dateofbirth,
      this.colorCode,
      this.state});

  int get userId => id;
  String get userName => name;
  String get userAddress => address;
  String get userDateOfBirth => dateofbirth;
  String get userColorCode => colorCode;
  String get userState => state;
  factory Task.fromMap(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        dateofbirth: json['dateofbirth'],
        colorCode: json['colorCode'],
        state: json['state']);
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['dateofbirth'] = dateofbirth;
    map['colorCode'] = colorCode;
    map['state'] = state;
    return map;
  }
}

// class DatabaseHelper {
//   Database database;
//   createDatabase() async {
//     String databasesPath = await getDatabasesPath();
//     String dbPath = join(databasesPath, 'user.db');
//     var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
//     return database;
//   }

//   void populateDb(Database database, int version) async {
//     await database.execute("CREATE TABLE User ("
//         "id INTEGER PRIMARY KEY,"
//         "name TEXT,"
//         ")");
//   }

//   Future<int> createCustomer(Task task) async {
//     var result = await database.insert("User", task.toMap());
//     return result;
//   }

//   Future<List> getCustomers() async {
//     var result = await database.query("User", columns: ["id", "name"]);
//     return result.toList();
//   }
//   Future<int> updateCustomer(Customer customer) async {
//   return await database.update("Customer", customer.toMap(), where: "id = ?", whereArgs: [customer.id]);
// }
// }

class DBHelper {
  static Database _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  _onCreate(Database db, int version) async {
    // await db.execute(
    //     'CREATE TABLE task (id INTEGER PRIMARY KEY, name TEXT,address TEXT)');
    await db.execute(
        'CREATE TABLE task (id INTEGER PRIMARY KEY, name TEXT,address TEXT , dateofbirth TEXT,colorCode TEXT , state TEXT)');
  }

  initDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'task.db');
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<Task> insert(Task task) async {
    var dbClient = await db;
    print(task.toMap());
    task.id = await dbClient.insert("task", task.toMap());
    print(task.id);
    return task;
  }

  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('task', columns: [
      'id',
      'name',
      'address',
      'dateofbirth',
      'colorCode',
      'state'
    ]);
    List<Task> taskList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        taskList.add(Task.fromMap(maps[i]));
      }
    }
    print(taskList);
    return taskList;
  }

  Future<int> update(Task task) async {
    var dbClient = await db;
    return await dbClient.update(
      'task',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete('task', where: 'id=?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
