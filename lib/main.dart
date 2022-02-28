import 'dart:async';
import 'dart:convert';
import '/models/auth.dart';
import '/views/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/imageCard.dart';
import "./classes/PostData.dart";

import 'package:http/http.dart' as http;

Future<List<PostData>> fetchPosts() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:5000/post'));

  if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    var posts = jsonDecode(response.body) as List;
    List<PostData> mappedPosts = [];
    posts.forEach((element) {
      mappedPosts.add(PostData.fromJson(element));
    });
    return mappedPosts;
    // return PostData.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load posts');
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pintrust mobile',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Pintrust mobile'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<PostData>> futurePosts;

  void updatePosts() {
    futurePosts = fetchPosts();
  }

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                var authModel = context.read<AuthModel>();

                if (authModel.accessToken == "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  authModel.setToken("");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Logged out!'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
              icon: Consumer<AuthModel>(
                  builder: (context, authModel, child) => Icon(
                      authModel.accessToken == ""
                          ? Icons.login
                          : Icons.logout))),
        ],
      ),
      body: Center(
          // child: Column(
          child: FutureBuilder<List<PostData>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, int index) {
                        return ImageCard(
                          postData: snapshot.data![index],
                          updatePosts: updatePosts,
                        );
                      });
                  // for (PostData pd in snapshot.data!) Card();
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              })),
    );
  }
}
