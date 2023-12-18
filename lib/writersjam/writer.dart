import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:nawalapatra_mobile/writersjam/book_rec.dart';
import 'package:nawalapatra_mobile/writersjam/story_form.dart';
import 'dart:convert';
import 'package:nawalapatra_mobile/writersjam/writer_models.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


DateTime now = DateTime.now();
DateTime startOfYear = DateTime(now.year, 1, 1);
int weekOfYear = ((now.difference(startOfYear).inDays + startOfYear.weekday) / 7).ceil();
int currentWeek = weekOfYear % 5;
int weekNow = currentWeek + 2;
// int promptNow = weekNow + 1;

class Prompt {
  final int urutan;
  final String tema;
  final String genre;

  Prompt(this.urutan, this.tema, this.genre);
}

final List<Prompt> promptStory = [
  Prompt(1, "Write a story about a small town librarian who discovers a secret message hidden in the margins of an old book.", "Literature & Fiction"),
  Prompt(2, "A renowned detective receives an anonymous letter containing a series of cryptic clues during haloween.", "Mystery, Thriller & Suspense"),
  Prompt(3, "About a mysterious ritual", "Religion & Spirituality"),
  Prompt(4, "A secret relationship between a mafia boss and a daughter of a noble family", "Romance"),
  Prompt(5, "Abnormal dimension gate appears out of nowhere are letting out mysterious monster and now normal humans have super power.", "Science Fiction & Fantasy")
];

class StoryListPage extends StatefulWidget {
  const StoryListPage({Key? key}) : super(key: key);
  

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryListPage> {
  Future<List<Item>> fetchBook() async {
    // DO: Ganti URL
    var url = Uri.parse('https://nawalapatra.pythonanywhere.com/writersjam/get-story/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Item> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Item.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Writers Jam'),
        ),
        drawer: const LeftDrawer(),
        body: 
          FutureBuilder(
            future: fetchBook(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Belum ada story yang diunggah.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  
                  // if(weekNow > 4) weekNow -= 5;
                  // int promptNow = weekNow + 1;
                  // if(promptNow > 4) promptNow = 4;
                  int promptNow = 0;
                  if(currentWeek == 0) promptNow = 3;
                  if(currentWeek == 1) promptNow = 4;
                  if(currentWeek == 2) promptNow = 0;
                  if(currentWeek == 3) promptNow = 1;
                  if(currentWeek == 4) promptNow = 2;
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 20.0,
                            top: 20.0,
                            right: 20.0,
                            bottom: 5.0,  // No padding at the bottom
                          ),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Weekly Prompt Theme',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                             Center(  // Center the text
                              child: Text('${promptStory[promptNow].tema}',  
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text('Genre: ${promptStory[promptNow].genre}',
                             style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              ),
                            const SizedBox(height: 10),
                          ]
                        )
                        )
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                border: Border.all(
                                  // color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child : Column(
                                children: [
                                  Center(  // Center the text
                                      child: Text(
                                      'Do you want to participate? click the button below to submit your story now!',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    ),
                                  const SizedBox(height: 10),
                                  if (request.loggedIn)... [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => StoryFormPage()),
                                        );
                                      },
                                      child: Text('Submit Your Story'),
                                    )
                                  ] else ... [
                                  Text('Dont see the button? Please login first to join the fun!',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ] 
                                ]
                              )
                            )
                          ),
                        ),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                color: Colors.pink.shade50,
                                border: Border.all(
                                  // color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child : Column(
                                children: [
                                  Center(  // Center the text
                                      child: Text(
                                      'Here are some books you can use as a reference to add a lil spice to your imagination! ',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                    ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => BookRecommend()),
                                        );
                                      },
                                      child: Text('Books Recommendation', style: TextStyle(fontSize: 13,)),
                                    )
                                ]
                              )
                            )
                           ),
                         ),
                       ],
                      ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => 
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center, // Change to center
                            children: [
                              Text(
                                "${snapshot.data![index].fields.title}",
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center, // Add this line
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "by ${snapshot.data![index].fields.username}",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // const SizedBox(height: 10),
                              Divider(color: Colors.black),
                              Text(
                                "${snapshot.data![index].fields.story}",
                                textAlign: TextAlign.justify, 
                              ),
                              const SizedBox(height: 20),
                              Text("${snapshot.data![index].fields.date}"),
                            ],
                          ),
                        ))
                      )
                    ]
                  );
                }
              }
            }),
            bottomNavigationBar: NavigationBarApp(),
            );
  }
}
