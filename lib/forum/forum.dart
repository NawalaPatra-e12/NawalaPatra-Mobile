import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/models/discussion.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:http/http.dart' as http;

String urlToParse = 'https://nawalapatra.pythonanywhere.com/forum/json';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);


  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ForumPage> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _replyController = TextEditingController();

  List<Product> discussions = []; // Initialize with an empty list

  void addDiscussion(Product newDiscussion) {
    setState(() {
      discussions.add(newDiscussion);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Discussion'),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Forum Discussion',
              style: TextStyle(
                fontFamily: 'Kidstock',
                fontWeight: FontWeight.bold,
                color: Color(0xFF011627),
                fontSize: 30.0,
                // marginBottom: 20.0,
              ),
            ),
            Container(
              color: const Color(0xFF011627),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    'Feel free to engage with other people',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Click the button below to create a new discussion!',
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Show discussion submission modal or navigate to a new screen
                      Product newDiscussion = await showDiscussionSubmissionDialog();
                      if (newDiscussion != null) {
                        addDiscussion(newDiscussion);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text(
                      'Add New Discussion',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            for (var discussion in discussions)
              DiscussionCard(
                user: discussion.fields.user.toString(),
                date: discussion.fields.date.toString(),
                description: discussion.fields.description,
                replies: discussion.fields.replies, // You may need to fetch replies for each discussion
                onReplyPressed: () {
                    showReplySubmissionDialog(discussion);
                  // TODO: Implement logic to add new reply
                  // You can show a modal or navigate to a new screen for reply submission
                },
              ),
          ],
        ),
      ),
        bottomNavigationBar: NavigationBarApp(),
    );
  }

  Future<Product> showDiscussionSubmissionDialog() async {
  TextEditingController descriptionController = TextEditingController();
  
  return showDialog<Product>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Discussion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog without adding a discussion
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Validate and create a new discussion
              if (descriptionController.text.isNotEmpty) {
                Product newDiscussion = Product(
                  model: Model.FORUM_DISCUSSION,
                  pk: discussions.length + 1, // Assign a unique ID (you may need to modify this logic)
                  fields: Fields(
                    user: 1, // User ID, replace with the actual user ID
                    date: DateTime.now(),
                    description: descriptionController.text,
                    replies: [], // Initialize with an empty list or fetch from your API

                  ),
                );

                Navigator.pop(context, newDiscussion); // Close the dialog and return the new discussion
              }
            },
            child: Text('Submit'),
          ),
        ],
      );
    },
  );
}


Future<void> showReplySubmissionDialog(Product discussion) async {
    TextEditingController replyController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Reply!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: replyController,
                decoration: InputDecoration(labelText: 'Reply'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without adding a reply
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Validate and create a new reply
                if (replyController.text.isNotEmpty) {
                  Reply newReply = Reply(
                    user: 1, // User ID, replace with the actual user ID
                    text: replyController.text,
                    date: DateTime.now(),
                  );

                  // Add the new reply to the discussion's replies list
                  discussion.fields.replies.add(newReply);

                  // Trigger a rebuild of the UI
                  setState(() {});

                  Navigator.pop(context); // Close the dialog
                }
              },
              child: Text('Submit Reply'),
            ),
          ],
        );
      },
    );
  }

}

class DiscussionCard extends StatelessWidget {
  final String user;
  final String date;
  final String description;
  final List<Reply> replies; 
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
                       user: reply.user.toString(),
                       text: reply.text,
                       date: reply.date.toString(),
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
          style: const TextStyle(fontSize: 12.0, color: Colors.grey),
        ),
        const Divider(),  
      ],
    );
  }
}

class Fields {
  // Existing fields
  int user;
  DateTime date;
  String description;

  // Add a field for replies
  List<Reply> replies;

  // Constructor
  Fields({
    required this.user,
    required this.date,
    required this.description,
    required this.replies,
  });
}



