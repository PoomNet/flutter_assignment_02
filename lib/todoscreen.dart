import 'package:flutter/material.dart';
import 'dart:async';
import 'todoItem.dart';
import 'dataaccess.dart';
import 'addtodoitem.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TodoListScreenState createState() => new _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> _todoItems = List();
  List<TodoItem> _completeItems = List();
  DataAccess _dataAccess;

  _TodoListScreenState() {
    _dataAccess = DataAccess();
  }

  @override
  initState() {
    super.initState();
    _dataAccess.open().then((result) {
      _dataAccess.getTodoItems().then((r) {
        for (var i = 0; i < r.length; i++) {
          if (r[i].isComplete == false) {
            setState(() {
              _todoItems.add(r[i]) ;
            });
          } else {
            setState(() {
              _completeItems.add(r[i]);
            });
          }
        }
      });
    });
  }

  void _addTodoItem() async {
    _todoItems = List();
    _completeItems = List();
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTodoItemScreen()));
    _dataAccess.getTodoItems().then((r) {
      for (var i = 0; i < r.length; i++) {
        if (r[i].isComplete == false) {
          setState(() {
            _todoItems.add(r[i]);
          });
        } else {
          setState(() {
            _completeItems.add(r[i]);
          });
        }
      }
    });
  }

  void _updateTodoCompleteStatus(TodoItem item, bool newStatus) {
    _todoItems = List();
    _completeItems = List();
    item.isComplete = newStatus;
    _dataAccess.updateTodo(item);
    _dataAccess.getTodoItems().then((items) {
      for (var i = 0; i < items.length; i++) {
        if (items[i].isComplete == false) {
          setState(() {
            _todoItems.add(items[i]);
          });
        } else {
          setState(() {
            _completeItems.add(items[i]);
          });
        }
      }
    });
  }

  void _deleteTodoItem() {
    _dataAccess.deleteTodo();
          setState(() {
            _completeItems =List();
          });
  }

  Widget _createTodoItemWidget(TodoItem item) {
    return ListTile(
      title: Text(item.name),
      trailing: Checkbox(
        value: item.isComplete,
        onChanged: (value) => _updateTodoCompleteStatus(item, value),
      ),
    );
  }

  Widget _createCompleteItemWidget(TodoItem item) {
    return ListTile(
      title: Text(item.name),
      trailing: Checkbox(
        value: item.isComplete,
        onChanged: (value) => _updateTodoCompleteStatus(item, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _todoItems.sort();
    var todoshow;
    var completeshow;
    var todoItemWidgets = _todoItems.map(_createTodoItemWidget).toList();
    var completeItemWidgets =
        _completeItems.map(_createCompleteItemWidget).toList();
      var emptytodo = Center(
              child: Text(
                "No Data Found..",
                textAlign: TextAlign.center,
                ),
      );
    var todolist =ListView(
      children: todoItemWidgets,
    );
    var completelist =ListView(
      children: completeItemWidgets,
    );
    if(todoItemWidgets.isEmpty){
      todoshow = emptytodo;
    }
    else{
      todoshow = todolist;
    }
    if(completeItemWidgets.isEmpty){
      completeshow = emptytodo;
    }
    else{
      completeshow = completelist;
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.blue,
          child: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.format_list_bulleted),
                text: "Task",
              ),
              Tab(
                icon: Icon(Icons.done_all),
                text: "Completed",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            new Scaffold(
              appBar: AppBar(
                title: Text("Todo"),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.add),
                    color: Colors.white,
                    onPressed: _addTodoItem,
                  )
                ],
              ),
              body: todoshow
            ),
            new Scaffold(
              appBar: AppBar(
                title: Text("Todo"),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.delete),
                    color: Colors.white,
                    onPressed: _deleteTodoItem,
                  )
                ],
              ),
              body: completeshow
            ),
          ],
        ),
      ),
    );
  }
}
