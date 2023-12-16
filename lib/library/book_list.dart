import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/book.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlToParse = 'https://nawalapatra.pythonanywhere.com/library/json';

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

    print(utf8.decode(response.bodyBytes));

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
    selectedOption =
        options.first; // Initialize selectedOption with the first option
    loadSharedPreferences();
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
        urlToParse = 'https://nawalapatra.pythonanywhere.com/library/json';
      } else if (newOption == 'Literature & Fiction') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/1/";
      } else if (newOption == 'Mystery, Thriller & Suspense') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/2/";
      } else if (newOption == 'Religion & Spirituality') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/3/";
      } else if (newOption == 'Romance') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/4/";
      } else if (newOption == 'Science Fiction & Fantasy') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/filter-json/5/";
      } else {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/library/search-flutter/${newOption}/";
      }
    });
    // Store the selected dropdown value in SharedPreferences
    await prefs.setString('selectedOption', newOption);
  }

  // Callback function to update search query and perform actions
  // void onSearchQueryChanged(String newQuery) {
  //   setState(() {
  //     // Update necessary state variables or perform actions based on the new query
  //     selectedOption = 'All'; // For example, resetting the selectedOption
  //     updateUrlToParse(newQuery); // Call the updateUrlToParse function
  //   });
  // }
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    // String uname = "User";

    // if (request.loggedIn) {
    //   uname = request.jsonData["username"];
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NawalaPatra'),
        actions: [
          SizedBox(
            width: 200,
            height: 50,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
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
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Library',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Tidak ada data produk."),
                        ],
                      ),
                    ),
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
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
