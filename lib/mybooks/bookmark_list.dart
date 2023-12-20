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
    "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=0";

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
            'https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=0';
      } else if (newOption == 'Literature & Fiction') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=1";
      } else if (newOption == 'Mystery, Thriller & Suspense') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=2";
      } else if (newOption == 'Religion & Spirituality') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=3";
      } else if (newOption == 'Romance') {
        urlToParse =
            "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_flutter/?category_filter=4";
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
      // appBar: AppBar(
      //   title: const Text('NawalaPatra'),
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
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // Tampilkan popup detail buku
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      TextEditingController reviewController =
                                          TextEditingController(
                                              text:
                                                  snapshot.data![index].review);
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Gambar ditengah
                                              Container(
                                                width: 65,
                                                height: 100,
                                                child: Image.network(
                                                  "${snapshot.data![index].book.imageUrl}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                "${snapshot.data![index].book.title}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Author: ${snapshot.data![index].book.author.isEmpty ? 'Unknown' : snapshot.data![index].book.author}",
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Category: ${snapshot.data![index].book.category}",
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                "Review: ${snapshot.data![index].review.isNotEmpty ? snapshot.data![index].review : 'Belum ada review'}",
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('Close',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _showReviewForm(
                                                        context,
                                                        setState,
                                                        reviewController,
                                                        snapshot
                                                            .data![index].pk,
                                                        snapshot.data!,
                                                        index,
                                                      );
                                                    },
                                                    child: Text(
                                                      '${snapshot.data![index].review.isNotEmpty ? 'Edit Review' : 'Add Review'}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.blue,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      var url = Uri.parse(
                                                          'https://nawalapatra.pythonanywhere.com/mybooks/remove_bookmark/');
                                                      var requestRemove =
                                                          await http.Request(
                                                              "DELETE", url);
                                                      requestRemove.body =
                                                          jsonEncode({
                                                        "id": snapshot
                                                            .data![index].pk,
                                                      });
                                                      final response =
                                                          await requestRemove
                                                              .send();
                                                      if (response.statusCode ==
                                                          200) {
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BookmarkPage()),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              SnackBar(
                                                            content: Text(
                                                              'You have successfully removed "${snapshot.data![index].book.title}" !',
                                                            ),
                                                          ));
                                                        // Navigator.pop(context);
                                                      } else {
                                                        // Handle error jika penghapusan gagal
                                                        print(
                                                            'Failed to remove. Status code: ${response.statusCode}');
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Remove',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
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
                                          "${snapshot.data![index].book.author.isEmpty ? 'Unknown Author' : snapshot.data![index].book.author}"),
                                      const SizedBox(height: 10),
                                      Text(
                                          "${snapshot.data![index].book.category}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}

void _showReviewForm(
  BuildContext context,
  StateSetter setState,
  TextEditingController reviewController,
  int bookId,
  List<Result> snapshotData,
  int snapshotIndex,
) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add/Edit Review',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Formulir Review
            TextField(
              controller: reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Review',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Kirim review ke server menggunakan metode POST
                // Anda dapat menyesuaikan URL dan parameter sesuai kebutuhan
                var url = Uri.parse(
                    'https://nawalapatra.pythonanywhere.com/mybooks/add_review_ajax/${bookId}/');
                var response = await http.post(
                  url,
                  body: {
                    'review': reviewController.text,
                  },
                );

                if (response.statusCode == 201) {
                  // Simpan nilai yang akan diperbarui dalam variabel lokal
                  var updatedReview = reviewController.text;

                  // Jika berhasil, perbarui tampilan modal dan tutup modal
                  setState(() {
                    // Gunakan nilai yang disimpan untuk mengupdate state
                    snapshotData[snapshotIndex].review = updatedReview;
                  });

                  Navigator.pop(context);
                } else {
                  // Handle kesalahan jika POST gagal
                  print(
                      'Failed to add/edit review. Status code: ${response.statusCode}');
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ],
        ),
      );
    },
  );
}
