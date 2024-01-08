import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';


class Sql {
  Database ?_db;
  final String dbname;

  final String currentTable;
  final Map<String, Object> params;
  Sql({required this.dbname, required this.currentTable, required this.params});

  Future<Database> get db async{
    if(_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbname);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  String getParamsToString(){
    String sql = "";
    params.forEach((key, value) {
      if(key == 'ID'){
        sql += "$key integer primary key autoincrement ,";
      }else if(value is int){
        sql += "$key integer ,";
      }else if(value is String){
        sql += "$key text ,";
      }else if(value is DateTime){
        sql += "$key DATETIME ,";
      }
    });

    if(sql != "") sql = sql.substring(0, sql.length-1);
    return sql;
  }

  void _onCreate(Database db, int version) async{
    await db.execute('''create table IF NOT EXISTS $currentTable (${getParamsToString()})''');
  }

  Future<int> insert(Map<String, Object> data) async{
    data.remove("ID");
    var dbClient = await db;
    return await dbClient.insert(currentTable, data);
  }

  Future<Map> select(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(
      currentTable,
      columns: params.keys.toList().cast<String>(),
      where: 'ID = ?',
      whereArgs: [id]
    );
    if(maps.isNotEmpty){
      return maps.first;
    }
    return {};
  }

  Future<List<Map>> selectAll() async{
    var dbClient = await db;
    List<Map<String, Object?>> maps = await dbClient.query(
        currentTable,
        columns: params.keys.toList().cast<String>()
    );
    if(maps.isNotEmpty){
      return maps;
    }
    return [];
  }

  Future<int> delete(int id) async{
    var dbClient = await db;
    return await dbClient.delete(currentTable, where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> update(Map<String, Object> data) async{
    var dbClient = await db;
    return await dbClient.update(currentTable, data, where: 'ID = ?', whereArgs: [data["ID"]]);
  }
}