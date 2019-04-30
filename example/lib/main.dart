import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import './widgets/keep_alive_future_builder.dart';

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
  PaginatedResponse _firstPaginatedResponse;

  final Paginator _paginator = Paginator(
    'https://spearhead.hoeijmakers.me/api/v1/moniekvandepas.com/post',
  );

  /// On initialize, get the first page and update the state
  @override
  void initState() {
    super.initState();

    // Get the first page and build the listview
    _getPage(1).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination'),
      ),
      body: Center(
        // Show a progress indicator while _lastPaginatedResponse is null
        child: _firstPaginatedResponse == null
            ? CircularProgressIndicator()
            : _buildList(),
      ),
    );
  }

  /// Get paginated response by index
  Future<void> _getPage(int page) async {
    PaginatedResponse paginatedResponse = await _paginator.page(page);

    if (null == _firstPaginatedResponse) {
      _firstPaginatedResponse = paginatedResponse;
    }

    return paginatedResponse.data;
  }

  /// Build a page with items
  Widget _buildPage(List items) {
    return ListView(
      shrinkWrap: true,
      primary: false,
      children: items.map((item) {
        return ListTile(
          title: Text(item['title']),
        );
      }).toList(),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _firstPaginatedResponse.lastPage,
      itemBuilder: (BuildContext context, int page) {
        // We must add a page as this starts with "0".
        page++;
        
        print(page);

        // Use KeepAliveFutureBuilder to prevent the
        // ListView builder from disposing the older pages
        return KeepAliveFutureBuilder(
          future: _getPage(page),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (ConnectionState.done != snapshot.connectionState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 2,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return ListTile(
                title: Text(snapshot.error.toString()),
              );
            }

            return _buildPage(snapshot.data);
          },
        );
      },
    );
  }
}
