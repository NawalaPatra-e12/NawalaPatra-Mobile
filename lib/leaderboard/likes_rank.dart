import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/book.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlToParse = 'https://nawalapatra.pythonanywhere.com/leaderboard/json';

class LeaderPage extends StatefulWidget {
  const LeaderPage({Key? key}) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
}

class _LikePageState extends State<LeaderPage> {
  final List<String> options = [
    'All',
    'Literature & Fiction',
    'Mystery, Thriller & Suspense',
    'Religion & Spirituality',
    'Romance',
    'Science Fiction & Fantasy'
  ];
  late String selectedOption = 'All';
  late SharedPreferences prefs;

  Future<List<Book>> fetchBook(String parseUrl) async {
    var url = Uri.parse(parseUrl);
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // Convert JSON data to a list of Book objects
    List<Book> books = [];
    for (var d in data) {
      if (d != null) {
        books.add(Book.fromJson(d));
      }
    }

    // Sort the books by their rate in descending order
    books.sort((a, b) => b.fields.rate.compareTo(a.fields.rate));

    return books;
  }


  @override
  void initState() {
    super.initState();
    selectedOption =
        options.first; // Initialize selectedOption with the first option
    loadSharedPreferences();
  }

  Future<void> clearAllSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    selectedOption = 'All';
    updateUrlToParse(selectedOption);
    // await prefs.clear();
  }

  Future<void> loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    // Retrieve the stored dropdown value or set default value as 'Option 1'
    selectedOption = prefs.getString('selectedOption') ?? 'All';
    // Set initial urlToParse based on the selectedOption
    updateUrlToParse(selectedOption);
  }


  Future<void> updateUrlToParse(String newOption) async {
    // Update urlToParse based on the selected option
    setState(() {
      if (newOption == 'All') {
        urlToParse = 'https://nawalapatra.pythonanywhere.com/leaderboard/json';
      } else if (newOption == 'Literature & Fiction') {
        urlToParse =
        "https://nawalapatra.pythonanywhere.com/leaderboard/filter-json/1/";
      } else if (newOption == 'Mystery, Thriller & Suspense') {
        urlToParse =
        "https://nawalapatra.pythonanywhere.com/leaderboard/filter-json/2/";
      } else if (newOption == 'Religion & Spirituality') {
        urlToParse =
        "https://nawalapatra.pythonanywhere.com/leaderboard/filter-json/3/";
      } else if (newOption == 'Romance') {
        urlToParse =
        "https://nawalapatra.pythonanywhere.com/leaderboard/filter-json/4/";
      } else if (newOption == 'Science Fiction & Fantasy') {
        urlToParse =
        "https://nawalapatra.pythonanywhere.com/leaderboard/filter-json/5/";
      }
    });
    // Store the selected dropdown value in SharedPreferences
    await prefs.setString('selectedOption', newOption);
  }

  Future<void> increaseBookRate(int bookId) async {
    var url = Uri.parse('https://nawalapatra.pythonanywhere.com/leaderboard/rate_button');
    var response = await http.post(url, body: {'book_id': bookId.toString()});

    if (response.statusCode == 200) {
      // Handle successful response
    } else {
      // Handle error
    }
  }



  // String urlToParse = '';

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NawalaPatra'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchBook(urlToParse),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Column(
                  children: [
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Tidak ada data produk.",
                      style:
                      TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Leaderboard',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          DropdownButton<String>(
                            value: selectedOption,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 18),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedOption =
                                      newValue; // Update selectedOption using setState()
                                });
                                updateUrlToParse(newValue);
                              }
                            },
                            items: options.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Left: Image
                                  Container(
                                    width: 100,
                                    child: Image.network(
                                      "${snapshot.data![index].fields.imageUrl}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  const SizedBox(width: 20),

                                  // Right: Text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data![index].fields.title}",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Author: ${snapshot.data![index].fields.author}"),
                                        const SizedBox(height: 10),
                                        Text(
                                            "Genre: ${snapshot.data![index].fields.category}"),
                                        const SizedBox(height: 10),
                                        Text(
                                          "Likes: ${snapshot.data![index].fields.rate}",
                                          style: const TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                        ),
                                      ),

                                        ],

                                    ),
                                  ),
            if (request.loggedIn) ...[
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  int book_id =
                      snapshot.data![index].pk;

                  final response = await request.postJson(
                      'https://nawalapatra.pythonanywhere.com/leaderboard/rate-button-flutter',
                      jsonEncode(<String, int>{
                        'index': book_id,
                      })
                    // You can include headers or other necessary data here
                  );
                  if (response['status'] ==
                      'success') {
                    setState(() {
                      fetchBook(urlToParse); // Refresh the forum list after deletion
                    });
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                          content: Text(
                              'You Like "${snapshot.data![index].fields.title}" So Much!!!')));
                  } else {
                    // Handle other status codes (if needed)
                    print(
                        'Failed to bookmark. Status code: ${response.statusCode}');
                  }
                },
                child: Icon(
                  Icons.favorite,
                  color: Colors.pink,
                  size: 24.0,
                ),

              ),

            ]
                                ],





                              ))),
                    )],
                );
              }
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
