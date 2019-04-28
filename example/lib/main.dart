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
  final Paginator _paginator = new Paginator(
    'https://spearhead.hoeijmakers.me/api/v1/moniekvandepas.com/post',
  );

  List _items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination'),
      ),
      body: Center(
        child: _buildList(),
      ),
      floatingActionButton: FlatButton(
        onPressed: _appendList(2),
        child: Icon(Icons.add),
      ),
    );
  }

  _appendList(page) {
    this._paginator.getNext();
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text('yeet'),
        );
      },
    );
  }

//  FutureBuilder _list({page: 1}) {
//    return FutureBuilder(
//      future: paginator.get(page: page),
//      builder: (BuildContext context, AsyncSnapshot snapshot) {
//        PaginatedResponse paginatedResponse = snapshot.data;
//
//        if (ConnectionState.done != snapshot.connectionState) {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        }
//
//        return ListView.builder(
//          itemCount: paginatedResponse.data.length,
//          itemBuilder: (BuildContext context, int index) {
//            return ListTile(
//              title: Text(paginatedResponse.data[index]['title']),
//            );
//          },
//        );
//      },
//    );
//  }
}
