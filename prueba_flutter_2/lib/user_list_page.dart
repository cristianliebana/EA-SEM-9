import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'create_user_page.dart';
import 'edit_user_page.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Map data = {};
  List usersData = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  getUsers(int page) async {
    Uri url = Uri.parse('http://localhost:9090/users/readall/?page=$page');
    http.Response response = await http.get(url);
    data = json.decode(response.body);
    setState(() {
      usersData.addAll(data['docs']);
      print(usersData);
      currentPage = data['page'];
      totalPages = data['totalPages'];
      isLoading = false;
    });
  }

  deleteById(String id) async {
    print("delete by Id $id");
    Uri url = Uri.parse('http://localhost:9090/users/deleteuser/$id');
    http.Response response = await http.delete(url);
    if (response.statusCode == 201) {
      setState(() {
        usersData.removeWhere((user) => user['_id'] == id);
      });
    } else {
      print('Error');
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers(currentPage);

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

      getUsers(currentPage + 1);
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
              "Lista de Usuarios",
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
              itemCount: usersData.length + (isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                final item = usersData[index] as Map;
                final id = item['_id'] as String;
                if (index == usersData.length) {
                  if (isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    loadPage();
                    return SizedBox();
                  }
                }
                final userIndex = index;
                return Card(
                  color: Color(0xFF486D28),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "$userIndex",
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFFFCEA),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(usersData[userIndex]['avatar']),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                        ),
                        Text(
                          "${usersData[userIndex]["username"]} ${usersData[userIndex]["email"]}",
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
            Navigator.pushNamed(context, '/create_user');
          },
          shape: CircleBorder(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserListPage(),
  ));
}
