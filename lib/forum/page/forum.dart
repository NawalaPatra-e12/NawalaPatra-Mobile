import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _replyController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forum Discussion'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Forum Discussion',
              style: TextStyle(
                fontFamily: 'Kidstock',
                fontWeight: FontWeight.bold,
                color: Color(0xFF011627),
                fontSize: 30.0,
                marginBottom: 20.0,
              ),
            ),
            Container(
              color: Color(0xFF011627),
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Feel free to engage with other people',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Click the button below to create a new discussion!',
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // implementasi buat kalo diteken
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      'Add New Discussion',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            for (var discussion in discussions)
              DiscussionCard(
                user: discussion['user'],
                date: discussion['date'],
                description: discussion['description'],
                replies: discussion['replies'],
                onReplyPressed: () {
                  // implementasi buat namabh reply
                },
              ),
          ],
        ),
      ),
    );
  }
}

class DiscussionCard extends StatelessWidget {
  final String user;
  final String date;
  final String description;
  final List<Map<String, dynamic>> replies;
  final VoidCallback onReplyPressed;

  DiscussionCard({
    required this.user,
    required this.date,
    required this.description,
    required this.replies,
    required this.onReplyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posted by $user on $date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Divider(),
                Text(description),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: onReplyPressed,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Reply',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          if (replies.isNotEmpty)
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey[200],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Replies:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  for (var reply in replies)
                    ReplyItem(
                      user: reply['user'],
                      text: reply['text'],
                      date: reply['date'],
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ReplyItem extends StatelessWidget {
  final String user;
  final String text;
  final String date;

  ReplyItem({
    required this.user,
    required this.text,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        Text(
          'Replied by $user on $date',
          style: TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        Divider(),
      ],
    );
  }
}
