import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'create_user_page.dart';
import 'edit_user_page.dart';

class ProductsListPage extends StatefulWidget {
  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  Map data = {};
  List productsData = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  getProducts(int page) async {
    Uri url = Uri.parse('http://localhost:9090/products/readall/?page=$page');
    http.Response response = await http.get(url);
    data = json.decode(response.body);
    setState(() {
      productsData.addAll(data['docs']);
      print(productsData);
      currentPage = data['page'];
      totalPages = data['totalPages'];
      isLoading = false;
    });
  }

  deleteById(String id) async {
    print("delete by Id $id");
    Uri url = Uri.parse('http://localhost:9090/products/deleteproduct/$id');
    http.Response response = await http.delete(url);
    if (response.statusCode == 201) {
      setState(() {
        productsData.removeWhere((user) => user['_id'] == id);
      });
    } else {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    getProducts(currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (currentPage < totalPages) {
          loadPage();
        }
      }
    });
  }

  void loadPage() {
    if (!isLoading && currentPage < totalPages) {
      setState(() {
        isLoading = true;
      });

      getProducts(currentPage + 1);
    }
  }

  void navigateToEditPage(String id) {
    final route = MaterialPageRoute(
      builder: (context) => EditUserPage(id),
    );
    Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Lista de Productos",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF486D28),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: productsData.length + (isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                final item = productsData[index] as Map;
                final id = item['_id'] as String;
                if (index == productsData.length) {
                  if (isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    loadPage();
                    return SizedBox();
                  }
                }
                final productsIndex = index;
                return Card(
                  color: Color(0xFF486D28),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "$productsIndex",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFCEA),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(productsData[productsIndex]['avatar']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Text(
                          "${productsData[productsIndex]["name"]} ${productsData[productsIndex]["description"]}",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFFCEA),
                          ),
                        ),
                        PopupMenuButton(onSelected: (value) {
                          if (value == 'edit') {
                            navigateToEditPage(id);
                          } else if (value == 'delete') {
                            deleteById(id);
                          }
                        }, itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text('Edit'),
                              value: 'edit',
                            ),
                            PopupMenuItem(
                              child: Text('Delete'),
                              value: 'delete',
                            ),
                          ];
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF486D28),
          child: const Icon(Icons.add, color: Color(0xFFFFFCEA)),
          onPressed: () {
            Navigator.pushNamed(context, '/create_product');
          },
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProductsListPage(),
  ));
}
