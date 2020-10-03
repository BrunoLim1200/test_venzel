import 'package:sqflite/sqflite.dart';
import 'package:test_venzel/repositories/database_con.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    // conexao db
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  // Inserindo dados na tabela
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  // Ler o dado da tabela
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  // Ler o dado pelo id
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(
      table,
      where: 'id=?',
      whereArgs: [itemId],
    );
  }

  // Update do dado
  updateData(table, data) async {
    var connection = await database;
    return await connection.update(
      table,
      data,
      where: 'id=?',
      whereArgs: [data['id']],
    );
  }

  // Delete data
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }

  // Read data from table by column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection.query(
      table,
      where: '$columnName=?',
      whereArgs: [columnValue],
    );
  }
}
