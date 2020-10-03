import 'package:test_venzel/models/todo.dart';
import 'package:test_venzel/repositories/repository.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  // create todo
  saveTodo(Todo todo) async {
    return await _repository.insertData(
      'todos',
      todo.todoMap(),
    );
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  // Read todo by id
  readTodoById(todoId) async {
    return await _repository.readDataById(
      'todos',
      todoId,
    );
  }

  // Update data
  updateTodo(Todo todo) async {
    return await _repository.updateData(
      'todos',
      todo.todoMap(),
    );
  }

  // Delete data
  deleteTodo(todoId) async {
    return await _repository.deleteData('todos', todoId);
  }

  // read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
      'todos',
      'category',
      category,
    );
  }
}
