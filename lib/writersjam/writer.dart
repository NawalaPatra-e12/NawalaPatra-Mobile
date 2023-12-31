import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:nawalapatra_mobile/writersjam/book_rec.dart';
import 'package:nawalapatra_mobile/writersjam/story_form.dart';
import 'dart:convert';
import 'package:nawalapatra_mobile/models/writer_models.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

DateTime now = DateTime.now();
DateTime startOfYear = DateTime(now.year, 1, 1);
int weekOfYear =
    ((now.difference(startOfYear).inDays + startOfYear.weekday) / 7).ceil();
int currentWeek = weekOfYear % 5;

class Prompt {
  final int urutan;
  final String tema;
  final String genre;

  Prompt(this.urutan, this.tema, this.genre);
}

final List<Prompt> promptStory = [
  Prompt(
      1,
      "Write a story about a small town librarian who discovers a secret message hidden in the margins of an old book.",
      "Literature & Fiction"),
  Prompt(
      2,
      "A renowned detective receives an anonymous letter containing a series of cryptic clues during haloween.",
      "Mystery, Thriller & Suspense"),
  Prompt(3, "About a mysterious ritual", "Religion & Spirituality"),
  Prompt(
      4,
      "A secret relationship between a mafia boss and a daughter of a noble family",
      "Romance"),
  Prompt(
      5,
      "Abnormal dimension gate appears out of nowhere are letting out mysterious monster and now normal humans have super power.",
      "Science Fiction & Fantasy")
];

class StoryListPage extends StatefulWidget {
  const StoryListPage({Key? key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryListPage> {
  Future<List<Item>> fetchBook() async {
    // DO: Ganti URL
    var url = Uri.parse(
        'https://nawalapatra.pythonanywhere.com/writersjam/get-story/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
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
      // appBar: AppBar(
      //   title: const Text('NawalaPatra'),
      //   backgroundColor: const Color.fromARGB(255, 241, 163, 65),
      // ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFF011627),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFF2EC4B6),
              ),
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFFE71D36),
              ),
              Container(
                width: 20,
                height: 60,
                color: const Color(0xFFFF9F1C),
              ),
              const SizedBox(width: 20), // Adjust the space between rectangles
              const Text(
                'NawalaPatra',
                style: TextStyle(
                  fontFamily: 'Kidstock',
                  color: Colors.white, // Change title text color as needed
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
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
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                int promptNow = 0;
                if (currentWeek == 0) promptNow = 3;
                if (currentWeek == 1) promptNow = 4;
                if (currentWeek == 2) promptNow = 0;
                if (currentWeek == 3) promptNow = 1;
                if (currentWeek == 4) promptNow = 2;
                return Column(children: [
                  const SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Writers Jam',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 6, 22, 38),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 20.0,
                        top: 5.0,
                        right: 20.0,
                        bottom: 5.0, // No padding at the bottom
                      ),
                      child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 6, 22, 38),
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(children: [
                            const Text(
                              'Weekly Prompt Theme',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                '${promptStory[promptNow].tema}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            //  Center(  // Center the text
                            //   child: Text('${promptStory[promptNow].tema}',
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                            Text(
                              'Genre: ${promptStory[promptNow].genre}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ]))),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 10.0,
                              right: 20.0,
                              bottom: 10.0, // No padding at the bottom
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 241, 163, 65),
                                  border: Border.all(
                                    // color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(children: [
                                  Center(
                                    // Center the text
                                    child: Text(
                                      'Do you want to participate? click the button below to submit your story now!',
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  if (request.loggedIn) ...[
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  StoryFormPage()),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          'Submit Your Story',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.blue)))),
                                    )
                                  ] else ...[
                                    Text(
                                      'Dont see the button? Please login first to join the fun!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]
                                ]))),
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 10.0,
                              right: 20.0,
                              bottom: 10.0, // No padding at the bottom
                            ),
                            child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 97, 193, 181),
                                  border: Border.all(
                                    // color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(children: [
                                  Center(
                                    // Center the text
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
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BookRecommend()),
                                      );
                                    },
                                    child: Center(
                                        child: Text(
                                      'Books Recommendation',
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black),
                                    )),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.blue)))),
                                  )
                                ]))),
                      ),
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  color: Colors.yellow.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center, // Change to center
                                  children: [
                                    Text(
                                      "${snapshot.data![index].fields.title}",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign:
                                          TextAlign.center, // Add this line
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
                                    Text(
                                        "${snapshot.data![index].fields.date}"),
                                  ],
                                ),
                              ))) //penutup
                ]);
              }
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
