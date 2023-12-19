import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/models/bookmark.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:http/http.dart' as http;

String urlToParse =
    "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=0";

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<BookmarkPage> {
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

  Future<List<Result>> fetchBookmark(
      String parseUrl, CookieRequest request) async {
    // DO: Ganti URL
    var response = await request.get(
      parseUrl,
    );

    // melakukan konversi data json menjadi object Bookmark
    List<Result> list_product = [];
    for (var d in response['result']) {
      list_product.add(Result.fromJson(d));
    }

    return list_product;
  }

  @override
  void initState() {
    super.initState();
    selectedOption =
        options.first; // Initialize selectedOption with the first option
    clearAllSharedPreferences();
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
        urlToParse =
            'https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=0';
      } else if (newOption == 'Literature & Fiction') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=1";
      } else if (newOption == 'Mystery, Thriller & Suspense') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=2";
      } else if (newOption == 'Religion & Spirituality') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=3";
      } else if (newOption == 'Romance') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=4";
      } else if (newOption == 'Science Fiction & Fantasy') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=5";
      }
    });
    // Store the selected dropdown value in SharedPreferences
    await prefs.setString('selectedOption', newOption);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('NawalaPatra'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchBookmark(urlToParse, request),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
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
                          'MyBooks',
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
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 18),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Left: Image
                                    Container(
                                      width: 100,
                                      child: Image.network(
                                        "${snapshot.data![index].book.imageUrl}",
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
                                            "${snapshot.data![index].book.title}",
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                              "${snapshot.data![index].book.author}"),
                                          const SizedBox(height: 10),
                                          Text(
                                              "${snapshot.data![index].book.category}"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      child: Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              var url = Uri.parse(
                                                  'https://nawalapatra.pythonanywhere.com/mybooks/remove_bookmark/');
                                              var requestRemove =
                                                  await http.Request(
                                                "DELETE",
                                                url,
                                              );
                                              requestRemove.body = jsonEncode({
                                                "id": snapshot.data![index].pk
                                              });
                                              final response =
                                                  await requestRemove.send();
                                              if (response.statusCode == 200) {
                                                // Jika penghapusan berhasil, perbarui state dengan memanggil ulang fetchBookmark
                                                setState(() {
                                                  // Anda juga dapat melempar parameter baru ke fungsi fetchBookmark
                                                  // jika diperlukan untuk pembaruan data yang lebih spesifik
                                                  fetchBookmark(
                                                      urlToParse, request);
                                                });
                                                ScaffoldMessenger.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(SnackBar(
                                                    content: Text(
                                                        'You have successfully removed "${snapshot.data![index].book.title}" !'),
                                                  ));
                                              } else {
                                                // Handle error jika penghapusan gagal
                                                print(
                                                    'Failed to remove. Status code: ${response.statusCode}');
                                              }
                                            },
                                            child: const Text('Remove'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .red, // You can change the color according to your UI
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              // Tampilkan review dalam AlertDialog
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        '"${snapshot.data![index].book.title}"'),
                                                    content: Text(snapshot
                                                            .data![index]
                                                            .review ??
                                                        'No review available'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            const Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: const Text('View Review'),
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors
                                                  .blue, // Adjust color according to your UI
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ))),
                ],
              );
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
