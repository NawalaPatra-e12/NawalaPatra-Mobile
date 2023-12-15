import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/bookmark.dart';
import 'package:nawalapatra_mobile/models/markbook.dart';

import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';

String urlToParse =
    "https://nawalapatra.pythonanywhere.com/mybooks/get_bookmark_json/?category_filter=0";
// String urlToParse = "https://nawalapatra.pythonanywhere.com/mybooks/json";

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<BookmarkPage> {
  Future<List<Result>> fetchBook(String parseUrl) async {
    // DO: Ganti URL
    var url = Uri.parse(parseUrl);
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data['result']);
    // melakukan konversi data json menjadi object Bookmark
    List<Result> list_product = [];
    for (var d in data['result']) {
      if (d != null) {
        list_product.add(Result.fromJson(d));
      }
    }

    return list_product;
  }

  // Future<List<MarkBook>> fetchBook(String parseUrl) async {
  // // DO: Ganti URL
  //   var url = Uri.parse(parseUrl);
  //   var response = await http.get(
  //     url,
  //     headers: {"Content-Type": "application/json"},
  //   );

  //   // melakukan decode response menjadi bentuk json
  //   var data = jsonDecode(utf8.decode(response.bodyBytes));
  //   print(data);
  //   // melakukan konversi data json menjadi object Bookmark
  //   List<MarkBook> list_product = [];
  //   for (var d in data) {
  //     print("masuk");
  //     if (d != null) {
  //       list_product.add(MarkBook.fromJson(d));

  //       print('User: ${d['fields']['user']}');
  //       print('Book: ${d['fields']['book']}');
  //       print('Markbook id: ${d['pk']}');
  //       print('-------------');
  //     }
  //   }

  //   return list_product;
  // }

  @override
  Widget build(BuildContext context) {
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
                      'Library',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Tidak ada data produk.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
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
                            'Library',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
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
