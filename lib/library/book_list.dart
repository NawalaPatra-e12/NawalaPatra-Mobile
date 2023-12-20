import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/book.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nawalapatra_mobile/library/bookreq_list.dart';

String urlParsing = 'https://nawalapatra.pythonanywhere.com/library/json';

class BooklistPage extends StatefulWidget {
  const BooklistPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<BooklistPage> {
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
    // DO: Ganti URL
    var url = Uri.parse(parseUrl);
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // print(utf8.decode(response.bodyBytes));

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
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
    // Initialize selectedOption with the first option
    // loadSharedPreferences();
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
    // print(request);
    // print(request.jsonData);
    // String uname = "User";

    // if (request.loggedIn) {
    //   uname = request.jsonData["username"];
    // }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFF011627),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
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
          actions: [
            SizedBox(
              width: 200,
              height: 40,
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  fontSize: 16, // Set the font size to make the text smaller
                ),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
                onSubmitted: (value) {
                  // Perform action when "Enter" key is pressed
                  setState(() {
                    selectedOption =
                        'All'; // Update selectedOption using setState()
                  });
                  String searchTerm = value;
                  if (searchTerm == '' || searchTerm.isEmpty) {
                    updateUrlToParse('All');
                  } else {
                    updateUrlToParse(searchTerm);
                  }
                },
              ),
            ),
            // const SizedBox(width: 20),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                setState(() {
                  selectedOption =
                      'All'; // Update selectedOption using setState()
                });
                String searchTerm = _searchController.text;
                if (searchTerm == '' || searchTerm.isEmpty) {
                  updateUrlToParse('All');
                } else {
                  updateUrlToParse(searchTerm);
                }
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchBook(urlParsing),
          builder: (context, AsyncSnapshot snapshot) {
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
                            'Library',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Filter by Genre:',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              DropdownButton<String>(
                                value: selectedOption,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 16,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Color(0xFF2EC4B6), fontSize: 18),
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
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BookReqlistPage(),
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFFFF9F1C), // Change background color here
                                    // You can adjust other properties like padding, shape, etc., if needed
                                  ),
                                  child: const Text(
                                    "Library Requests",
                                    style: TextStyle(color: Color(0xFF011627)),
                                  )),
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
                          const Text(
                            'Library',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Filter by Genre:',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              DropdownButton<String>(
                                value: selectedOption,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 16,
                                elevation: 16,
                                style: const TextStyle(
                                    color: Color(0xFF2EC4B6), fontSize: 18),
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
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const BookReqlistPage(),
                                        ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xFFFF9F1C), // Change background color here
                                    // You can adjust other properties like padding, shape, etc., if needed
                                  ),
                                  child: const Text(
                                    "Library Requests",
                                    style: TextStyle(color: Color(0xFF011627)),
                                  )),
                            ],
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

                                      if (request.loggedIn) ...[
                                        Container(
                                          width: 200,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              // print("${index}");
                                              int book_id =
                                                  snapshot.data![index].pk;

                                              final response = await request.postJson(
                                                  'https://nawalapatra.pythonanywhere.com/library/bookmark-flutter/',
                                                  jsonEncode(<String, int>{
                                                    'index': book_id,
                                                  })
                                                  // You can include headers or other necessary data here
                                                  );
                                              if (response['status'] ==
                                                  'success') {
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(SnackBar(
                                                      content: Text(
                                                          'You have successfully bookmarked "${snapshot.data![index].fields.title}" !')));
                                              } else {
                                                // Handle other status codes (if needed)
                                                print(
                                                    'Failed to bookmark. Status code: ${response.statusCode}');
                                              }
                                            },
                                            child: const Text('Bookmark'),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ))),
                  ],
                );
              }
            }
          }),
      bottomNavigationBar: const NavigationBarApp(),
    );
  }
}
