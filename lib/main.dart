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
          primarySwatch: Colors.blue),
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
  // loading ui state - initially set to a loading state
  bool _isLoading = true;

  // list of Todos - initially empty
  List<Orders> _orders = [];

  // amplify plugins
  final _dataStorePlugin =
      AmplifyDataStore(modelProvider: ModelProvider.instance);
  final AmplifyAPI _apiPlugin = AmplifyAPI();
  final AmplifyAuthCognito _authPlugin = AmplifyAuthCognito();

  // subscription of Todo QuerySnapshots - to be initialized at runtime
  late StreamSubscription<QuerySnapshot<Orders>> _subscription;

  @override
  initState() {
    // kick off app initialization
    _initializeApp();

    super.initState();
  }

  @override
  void dispose() {
    // to be filled in a later step
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // configure Amplify
    if (!Amplify.isConfigured) {
      await _configureAmplify();
    }

    print('Amplify Configured :' + Amplify.isConfigured.toString());

    // Query and Observe updates to Todo models. DataStore.observeQuery() will
    // emit an initial QuerySnapshot with a list of Todo models in the local store,
    // and will emit subsequent snapshots as updates are made
    //
    // each time a snapshot is received, the following will happen:
    // _isLoading is set to false if it is not already false
    // _orders is set to the value in the latest snapshot
    _subscription = Amplify.DataStore.observeQuery(Orders.classType)
        .listen((QuerySnapshot<Orders> snapshot) {
      setState(() {
        if (_isLoading) _isLoading = false;
        _orders = snapshot.items;
        print('All Orders: $_orders');
      });
    });
  }

  Future<void> _configureAmplify() async {
    try {
      // add Amplify plugins
      await Amplify.addPlugins([_dataStorePlugin, _apiPlugin, _authPlugin]);

      // configure Amplify
      //
      // note that Amplify cannot be configured more than once!
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      // error handling can be improved for sure!
      // but this will be sufficient for the purposes of this tutorial
      print('An error occurred while configuring Amplify: $e');
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

  Future<void> _toggleIsComplete(Orders order, bool? value) async {
    // copy the Todo we wish to update, but with updated properties
    final updatedTodo = order.copyWith(
        Status: (value ?? false) ? Statuses.APPROVED : Statuses.REJECTED);
    try {
      // to update data in DataStore, we again pass an instance of a model to
      // Amplify.DataStore.save()
      await Amplify.DataStore.save(updatedTodo);
    } catch (e) {
      print('An error occurred while saving Todo: $e');
    }
  }

  Widget _orderListView(List<Orders> orders) {
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final double iconSize = 16.0;
          Color iconColor = Colors.red;
          if (order.Status == Statuses.APPROVED) iconColor = Colors.green;
          if (order.Status == Statuses.PENDING) iconColor = Colors.orange;
          if (order.Status == Statuses.REJECTED) iconColor = Colors.red;
          return Card(
            child: CheckboxListTile(
              // title: Text(order.ProductName.toString()),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Icon(
                    order.Status == Statuses.APPROVED
                        ? Icons.circle
                        : Icons.circle,
                    size: iconSize,
                    color: iconColor,
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.ProductName.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(order.Quantity.toString()),
                      ],
                    ),
                  ),
                ]),
              ),
              value: order.Status == Statuses.APPROVED,
              onChanged: (bool? value) {
                _toggleIsComplete(order, value);
              },
            ),
          );
        });
  }
}
