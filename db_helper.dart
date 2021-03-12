import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dog_model.dart';

// ignore: non_constant_identifier_names
final String TableName = 'Dog';


//데이터베이스
class DBHelper {

  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  //데이터베이스 초기화
  initDB() async {

    //getApplicationDocumentsDirectory() : 적당한 위치에 경로 생성
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyDogsDB.db');


    //openDatabase() : 경로 불러오는 함수
    return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
          'CREATE TABLE $TableName(id INTEGER PRIMARY KEY, name TEXT)',
        );     //위와 같은 조건으로 테이블 생성
        },
        //migration
        onUpgrade: (db, oldVersion, newVersion){}
    );
  }

  //Create
  createData(Dog dog) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO $TableName(name) VALUES(?)', [dog.name]);
    return res;
  }

  //Read
  getDog(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty ? Dog(id: res.first['id'], name: res.first['name']) : Null;
  }

  //Read All
  Future<List<Dog>> getAllDogs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Dog> list = res.isNotEmpty ? res.map((c) => Dog(id:c['id'], name:c['name'])).toList() : [];

    return list;
  }

  //Delete
  deleteDog(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }

}


//https://dalgonakit.tistory.com/116?category=808568