import 'package:flutter/material.dart';
import 'package:test_venzel/helpers/drawer_navigation.dart';
import 'package:test_venzel/models/todo.dart';
import 'package:test_venzel/screens/todo_screen.dart';
import 'package:test_venzel/services/category_service.dart';
import 'package:test_venzel/services/todo_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _editTodoTitleController = TextEditingController();
  var _editTodoDescriptionController = TextEditingController();
  var _editTodoDateController = TextEditingController();
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  var todoObject = Todo();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    getAllTodos();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
    });
  }

  TodoService _todoService;

  var todo;

  final _todo = Todo();

  List<Todo> _todoList = List<Todo>();

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo["id"];
        model.title = todo["title"];
        model.description = todo["description"];
        model.category = todo["category"];
        model.todoDate = todo["todoDate"];
        model.isFinished = todo["isFinished"];
        _todoList.add(model);
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _editTodoDateController.text =
            DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  _editTodo(BuildContext context, todoId) async {
    todo = await _todoService.readTodoById(todoId);
    setState(() {
      _editTodoTitleController.text = todo[0]['title'] ?? 'No title';
      _editTodoDescriptionController.text =
          todo[0]['description'] ?? 'No Description';
      _editTodoDateController.text = todo[0]['todoDate'] ?? 'No Date';
      _selectedValue = todo[0]['category'] ?? 'No Category';
    });
    _editFormTodoDialog(context);
  }

  _moreInfoTodoDialog(BuildContext context, index) {
    var _listTodo = _todoList[index];
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          title: Text(_listTodo.title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_listTodo.description),
                Text(_listTodo.category),
                Text(_listTodo.todoDate),
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Fechar'),
            )
          ],
        );
      },
    );
  }

  _editFormTodoDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () async {
                todoObject.id = todo[0]['id'];
                todoObject.title = _editTodoTitleController.text;
                todoObject.description = _editTodoDescriptionController.text;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = _editTodoDateController.text;

                var result = await _todoService.updateTodo(_todo);

                if (result > 0) {
                  Navigator.pop(context);
                  getAllTodos();
                  print(result);
                }
              },
              child: Text('Editar'),
            ),
          ],
          title: Text("Editar Tarefa"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _editTodoTitleController,
                  decoration: InputDecoration(
                    hintText: 'Escreva um titulo',
                    labelText: 'Título',
                  ),
                ),
                TextField(
                  controller: _editTodoDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Escreva uma descrição',
                    labelText: 'Descrição',
                  ),
                ),
                TextField(
                  controller: _editTodoDateController,
                  decoration: InputDecoration(
                    labelText: 'Data',
                    hintText: 'Escolha uma data',
                    prefixIcon: InkWell(
                      onTap: () {
                        _selectedTodoDate(context);
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: _selectedValue,
                  items: _categories,
                  hint: Text('Categorias'),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _deleteTodoListDialog(BuildContext context, todoId) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (param) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () async {
                var result = await _todoService.deleteTodo(todoId);
                if (result > 0) {
                  Navigator.pop(context);
                  getAllTodos();
                }
              },
              child: Text('Excluir'),
            ),
          ],
          title: Text("Você tem certeza que deseja excluir a tarefa?"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas - Venzel'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_todoList[index].title ?? 'No Title'),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(_todoList[index].category ?? 'No Category'),
                  ],
                ),
                trailing: Column(
                  children: [
                    Text(_todoList[index].todoDate ?? 'No Date'),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editTodo(context, _todoList[index].id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteTodoListDialog(
                                  context, _todoList[index].id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  _moreInfoTodoDialog(context, index);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TodoScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
