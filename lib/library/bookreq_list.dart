import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nawalapatra_mobile/models/bookreq.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/library/bookreq_form.dart';

class BookReqlistPage extends StatefulWidget {
  const BookReqlistPage({Key? key}) : super(key: key);

  @override
  _ReqPageState createState() => _ReqPageState();
}

class _ReqPageState extends State<BookReqlistPage> {
  Future<List<BookReq>> fetchBook() async {
    // DO: Ganti URL
    var url = Uri.parse(
        "https://nawalapatra.pythonanywhere.com/library/get-req-full/");
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<BookReq> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(BookReq.fromJson(d));
      }
    }
    return list_product;
  }

  @override
  void initState() {
    super.initState();
    // setState(() {});
    // Initialize selectedOption with the first option
    // loadSharedPreferences();
  }

  // final TextEditingController _searchController = TextEditingController();

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
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
          future: fetchBook(),
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
                            'Library Requests',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Got a book you wanna see in our library?',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (request.loggedIn) ...[
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BookReqFormPage(),
                                          ));
                                    },
                                    child: const Text("Request a Book!")),
                              ] else ...[
                                const Text(
                                  'Log in to submit a request.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]
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
                            'Library Requests',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Got a book you wanna see in our library?',
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (request.loggedIn) ...[
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const BookReqFormPage(),
                                          ));
                                    },
                                    child: const Text("Request a Book!")),
                              ] else ...[
                                const Text(
                                  'Log in to submit a request.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ]
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${snapshot.data![index].bookTitle}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "Book by ${snapshot.data![index].bookAuthor}",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              "${snapshot.data![index].reason}",
                                              style: const TextStyle(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            if (request.jsonData["username"] ==
                                                snapshot
                                                    .data![index].username) ...[
                                              Text(
                                                "@${snapshot.data![index].username} (you)",
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xFFe88600),
                                                ),
                                              ),
                                            ] else ...[
                                              Text(
                                                "@${snapshot.data![index].username}",
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: Color(0xff249b90),
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Request posted on ${snapshot.data![index].dateAdded.toString().substring(0, 11)}",
                                                  style: const TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(width: 20),
                                                if (request
                                                        .jsonData["username"] ==
                                                    snapshot.data![index]
                                                        .username) ...[
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                      onPressed: () async {
                                                        final response = await request
                                                            .postJson(
                                                                'https://nawalapatra.pythonanywhere.com/library/bookreq-delete-flutter/',
                                                                jsonEncode(<String,
                                                                    int>{
                                                                  'id': snapshot
                                                                      .data![
                                                                          index]
                                                                      .id,
                                                                })
                                                                // You can include headers or other necessary data here
                                                                );
                                                        if (response[
                                                                'status'] ==
                                                            'success') {
                                                          setState(() {});
                                                          // ignore: use_build_context_synchronously
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'You have successfully deleted the request!')));
                                                        } else {
                                                          // Handle other status codes (if needed)
                                                          print(
                                                              'Failed to delete. Status code: ${response.statusCode}');
                                                        }
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor: Colors
                                                            .red, // You can change the color according to your UI
                                                      ),
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
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
            }
          }),
      bottomNavigationBar: NavigationBarApp(),
    );
  }
}
