import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Paginator _paginator = Paginator(
    'https://spearhead.hoeijmakers.me/api/v1/moniekvandepas.com/post',
  );

  List _items = List.from([], growable: true);

  @override
  Widget build(BuildContext context) {
    _appendList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination'),
      ),
      body: Center(
        child: _buildList(),
      ),
      floatingActionButton: FlatButton(
        onPressed: _appendList(),
        child: Icon(Icons.add),
      ),
    );
  }

  _appendList() {
    this._paginator.getNext().then((PaginatedResponse paginatedResponse) =>
        _items.addAll(paginatedResponse.data));
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: this._items?.length,
      itemBuilder: (BuildContext context, int index) {
        print(_items.length);
        return ListTile(
          title: Text(_items[index]['title']),
        );
      },
    );
  }
}
