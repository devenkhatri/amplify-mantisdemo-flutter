// dart async library we will refer to when setting up real time updates
import 'dart:async';

import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

// Generated in previous step
import 'models/ModelProvider.dart';
import 'amplifyconfiguration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mantis Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.teal),
      home: const TodosView(title: 'Mantis - Order Approval App'),
    );
  }
}

class TodosView extends StatefulWidget {
  const TodosView({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<TodosView> createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  bool _isLoading = true;

  List<Todo> _todos = [];

  // Amplify Plugins
  final AmplifyDataStore _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  @override
  initState() {
    // initialize the app
    _initializeApp();
    super.initState();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    if (!Amplify.isConfigured) {
      await _configureAmplify();
    }
    // .then((value) => _fetchTodos());

    // fetch the Todo from DataStore
    // _fetchTodos();

    // _subscription = Amplify.DataStore.observe(Todo.classType).listen((e) {
    //   _fetchTodos();
    // });

    await _fetchTodos();

    setState(() {
      _isLoading = false;
    });

    await _fetchTodos();

    if (!_isLoading) {
      Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
        print("hubevent is ${hubEvent.eventName}");
        switch (hubEvent.eventName) {
          case "SIGNED_IN":
            {
              print("USER IS SIGNED IN");
            }
            break;
          case "SIGNED_OUT":
            {
              print("USER IS SIGNED OUT");
            }
            break;
          case "SESSION_EXPIRED":
            {
              print("USER IS SIGNED IN SESSION_EXPIRED");
            }
            break;
        }
      });

      Amplify.Hub.listen([HubChannel.DataStore], (hubEvent) {
        print("hubevent2 is ${hubEvent.eventName}");
      });
    }
  }

  Future<void> _configureAmplify() async {
    try {
      // add AMplify Plugins
      await Amplify.addPlugins([_dataStorePlugin, _apiPlugin, _authPlugin]);

      await Amplify.configure(amplifyconfig);
    } catch (err) {
      debugPrint('Erro occured while configuring Amplify $err');
    }
  }

  Future<void> _fetchTodos() async {
    try {
      // query for all Todo entries by passing the Todo classType to
      // Amplify.DataStore.query()
      // List<Todo> updatedTodos = await Amplify.DataStore.query(Todo.classType);
      Amplify.DataStore.observeQuery(
        Todo.classType,
      ).listen((QuerySnapshot<Todo> snapshot) {
        var count = snapshot.items.length;
        var now = DateTime.now().toIso8601String();
        bool status = snapshot.isSynced;
        print(
            '[Observe Query] Blog snapshot received with $count models, status: $status at $now');
        setState(() {
          _todos = snapshot.items;
          print('fetched Todos $_todos');
        });
      });

      // update the ui state to reflect fetched todos
      // print('fetched Todos $updatedTodos');
      // setState(() {
      //   _todos = updatedTodos;
      // });
    } catch (e) {
      print('An error occurred while querying Todos: $e');
    }
  }

  Future<AuthUser> getCurrentUser() async {
    AuthUser authUser = await Amplify.Auth.getCurrentUser();
    return authUser;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    print('Is Loading $_isLoading');
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TodosList(todos: _todos),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TodosList extends StatelessWidget {
  final List<Todo> todos;

  const TodosList({required this.todos, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return todos.isNotEmpty
        ? ListView(
            padding: const EdgeInsets.all(8),
            children: todos.map((todo) => TodoItem(todo: todo)).toList())
        : const Center(child: Text('Tap button below to add a todo!'));
  }
}

class TodoItem extends StatelessWidget {
  final double iconSize = 24.0;
  final Todo todo;

  const TodoItem({required this.todo, Key? key}) : super(key: key);

  void _deleteTodo(BuildContext context) async {
    try {
      // to delete data from DataStore, we pass the model instance to
      // Amplify.DataStore.delete()
      await Amplify.DataStore.delete(todo);
    } catch (e) {
      print('An error occurred while deleting Todo: $e');
    }
  }

  Future<void> _toggleIsComplete() async {
    // copy the Todo we wish to update, but with updated properties
    Todo updatedTodo = todo.copyWith(isComplete: !(todo.isComplete ?? false));
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _toggleIsComplete();
        },
        onLongPress: () {
          _deleteTodo(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(todo.title ?? 'No Title',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(
                (todo.isComplete ?? false)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                size: iconSize),
          ]),
        ),
      ),
    );
  }
}
