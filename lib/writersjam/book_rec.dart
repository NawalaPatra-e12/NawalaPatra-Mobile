import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/book.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlParsing = 'https://nawalapatra.pythonanywhere.com/library/json';

DateTime now = DateTime.now();
DateTime startOfYear = DateTime(now.year, 1, 1);
int weekOfYear = ((now.difference(startOfYear).inDays + startOfYear.weekday) / 7).ceil();
int currentWeek = weekOfYear % 5;

class BookRecommend extends StatefulWidget {
  const BookRecommend({Key? key}) : super(key: key);

  @override
  _BookGenreState createState() => _BookGenreState();
}

class _BookGenreState extends State<BookRecommend> {
  final List<String> options = [
    'All',
    'Literature & Fiction',
    'Mystery, Thriller & Suspense',
    'Religion & Spirituality',
    'Romance',
    'Science Fiction & Fantasy'
  ];
  final List<String> genres = [
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

    List<Book> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Book.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  void initState() {
    super.initState();
    selectedOption = options.first;
    clearAllSharedPreferences();
  }

  Future<void> clearAllSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    selectedOption = 'All';
    updateUrlToParse(selectedOption);
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
        urlParsing = 'https://nawalapatra.pythonanywhere.com/library/json';
      } else if (newOption == 'Literature & Fiction') {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/1/";
      } else if (newOption == 'Mystery, Thriller & Suspense') {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/2/";
      } else if (newOption == 'Religion & Spirituality') {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/3/";
      } else if (newOption == 'Romance') {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/4/";
      } else if (newOption == 'Science Fiction & Fantasy') {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/5/";
      } else {
        urlParsing =
            "https://nawalapatra.pythonanywhere.com/library/search-flutter/${newOption}/";
      }
    });
    // Store the selected dropdown value in SharedPreferences
    await prefs.setString('selectedOption', newOption);
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NawalaPatra',
        ),
        backgroundColor: const Color(0xff3e2f48), //added colour for appbar!
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchBook(urlParsing),
          builder: (context, AsyncSnapshot snapshot) {
            int promptNow = 0;
            if(currentWeek == 0) promptNow = 3;
            if(currentWeek == 1) promptNow = 4;
            if(currentWeek == 2) promptNow = 0;
            if(currentWeek == 3) promptNow = 1;
            if(currentWeek == 4) promptNow = 2;
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Writers Jam Book Recommendation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = 'All'; // Update selectedOption using setState()
                                  });
                                  updateUrlToParse('All');
                                },
                                child: Text('All Books'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = genres[promptNow]; // Update selectedOption using setState()
                                  });
                                  updateUrlToParse('$promptNow');
                                },
                                child: Text('Book Recommended for this theme!'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text("Tidak ada data produk."),
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
                          Row(children: [
                            TextButton(onPressed: () {Navigator.pop(context);}, child: Icon(Icons.arrow_back)),
                              const Text(
                                'Writers Jam Book Recommendation',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = 'All'; // Update selectedOption using setState()
                                  });
                                  updateUrlToParse('All');
                                },
                                child: Text(
                                  'All Books', 
                                  style: TextStyle(fontSize: 13, color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange)
                                    )
                                  )
                                ),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedOption = genres[promptNow]; // Update selectedOption using setState()
                                  });
                                  updateUrlToParse('$promptNow');
                                },
                                child: Text(
                                  'Book Recommended for this theme!', 
                                  style: TextStyle(fontSize: 13, color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.orange)
                                    )
                                  )
                                ),
                              )

                            ],
                          ),
                          const SizedBox(height: 10),
                          Text('Interested in some of it? might wanna bookmarked it in the Library ;)', 
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                  ],
                );
              }
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
