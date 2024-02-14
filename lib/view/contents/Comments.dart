import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  @override
  _CommentWindowState createState() => _CommentWindowState();
}

class _CommentWindowState extends State<Comments> {
  TextEditingController _commentController = TextEditingController();
  List<String> comments = ["Nice!", "Beautiful picture!", "Love it!"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comments[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        comments.add(_commentController.text);
                        _commentController.clear();
                      });
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}