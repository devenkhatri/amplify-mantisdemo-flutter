import 'package:flutter/material.dart';

// Amplify Flutter Packages
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_api/amplify_api.dart';

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
      home: const MyHomePage(title: 'Mantis - Order Approval App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  List<Orders> _orders = [];

  @override
  initState() {
    super.initState();
    // initialize the app
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    if (!Amplify.isConfigured) {
      await _configureAmplify();
    }

    print('Amplify Configured :' + Amplify.isConfigured.toString());

    //fetch data from amplify
    await _fetchOrders();

    print('All Orders: $_orders');

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(
          AmplifyAPI()); // UNCOMMENT this line after backend is deployed
      await Amplify.addPlugin(
          AmplifyDataStore(modelProvider: ModelProvider.instance));

      // Once Plugins are added, configure Amplify
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchOrders() async {
    try {
      // query for all Order entries by passing the Orders classType to
      // Amplify.DataStore.query()
      List<Orders> allOrders = await Amplify.DataStore.query(Orders.classType);
      print('Inside function - All Orders: $allOrders');
      List<Todo> allTodos = await Amplify.DataStore.query(Todo.classType);
      print('Inside function - All Todos: $allTodos');

      // update the ui state to reflect fetched todos
      setState(() {
        _orders = allOrders;
      });
    } catch (e) {
      print('An error occurred while querying Orders: $e');
    }
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListOrders(orders: _orders),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ListOrders extends StatelessWidget {
  final List<Orders> orders;
  const ListOrders({required this.orders, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Inside ListOrders: $orders');
    return orders.isNotEmpty ? _orderListView(orders) : _emptyOrderList();
  }

  Widget _emptyOrderList() {
    return const Center(
      child: Text('No orders yet.....'),
    );
  }

  Widget _orderListView(List<Orders> orders) {
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: CheckboxListTile(
              title: Text(order.ProductName.toString()),
              value: order.Status == Statuses.APPROVED,
              onChanged: (bool? value) {},
            ),
          );
        });
  }
}
