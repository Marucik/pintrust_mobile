import 'dart:convert';

import '/classes/PostData.dart';
import '/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:http/http.dart' as http;

class ImageCard extends StatefulWidget {
  ImageCard({required this.postData, required this.updatePosts});

  final PostData postData;

  final void Function() updatePosts;

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  int localLikes = 0;
  int localDislikes = 0;
  bool reacted = false;

  void reactToImage(reaction) async {
    var imageId = widget.postData.id;
    var authModel = context.read<AuthModel>();

    var response =
        await http.post(Uri.parse('http://10.0.2.2:5000/post/${imageId}/react'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              "Authorization": 'Bearer ${authModel.accessToken}'
            },
            body: jsonEncode(<String, String>{"reactionType": reaction}));

    if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Already reacted!'),
        backgroundColor: Colors.red,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Reacted!'),
        backgroundColor: Colors.green,
      ));
      if (!reacted) {
        reacted = true;
        if (reaction == "like") {
          localLikes = localLikes + 1;
        } else {
          localDislikes = localDislikes + 1;
        }

        setState(() {});
      }
    }
  }

  double getLikeRatio() {
    return localLikes / (localLikes + localDislikes);
  }

  @override
  void initState() {
    super.initState();
    localDislikes = widget.postData.dislikes;
    localLikes = widget.postData.likes;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      // child: Container(child: Text("chuuuuk"), color: Colors.green),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(children: [
          ListTile(
            title: Text(widget.postData.title),
            subtitle: Text(
              widget.postData.description,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                  'http://10.0.2.2:5000${widget.postData.imageUrl}')),
          LinearProgressIndicator(
            value: getLikeRatio(),
            color: Colors.green,
            backgroundColor: Colors.red,
          ),
          Consumer<AuthModel>(
              builder: (context, auth, child) => ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      if (auth.accessToken != "") ...[
                        IconButton(
                            onPressed: () {
                              reactToImage("like");
                            },
                            icon: Icon(Icons.thumb_up)),
                        IconButton(
                            onPressed: () {
                              reactToImage("dislike");
                            },
                            icon: Icon(Icons.thumb_down)),
                      ]
                    ],
                  ))
        ]),
      ),
      widthFactor: 0.95,
    );
  }
}
