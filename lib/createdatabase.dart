import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolistlocaldatabase/usermodel.dart';

class UserRepository{
  static Database? _database;
  final userTableName="todolist";
  UserRepository(){
    createDatabase();
  }
Future<void> createDatabase() async{
  _database=await openDatabase(join(await getDatabasesPath(),'local.db'),
  onCreate: (db, version) {
    db.execute('CREATE TABLE $userTableName(id INTEGER PRIMARY KEY AUTOINCREMENT,task text)');
  },version: 1
  
  
  
  );
}
Future<void> insertTask(TableValues tableValues) async{
  await _database?.insert(userTableName,tableValues.toJson() );

}
 Future<List<TableValues>> getUsers() async {
    print("inside");
    if (_database != null) {
      print("inside");
      final List<Map<String, dynamic>> maps =
          await _database!.query(userTableName);
      return List.generate(maps.length, (i) {
        return TableValues.fromJson(maps[i]);
      });
    }
    return [];
  }

  Future<void> removeUser(TableValues tableValues) async {
    await _database!.delete(userTableName,
        where: 'id=?',
        whereArgs: [tableValues.id]).then((value) => print("Removed"));
  }
   Future<void> updateUser(TableValues tableValues) async {
    await _database?.update(userTableName, tableValues.toJson(),
        where: "id = ?", whereArgs: [tableValues.id]);
  }
}