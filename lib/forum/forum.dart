import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/models/discussion.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:nawalapatra_mobile/widgets/left_drawer.dart';
import 'package:nawalapatra_mobile/widgets/nav_bottom.dart';
import 'package:nawalapatra_mobile/forum/discussion_form.dart';

import 'package:http/http.dart' as http;

String urlToParse = 'https://nawalapatra.pythonanywhere.com/forum/json';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ForumPage> {
  List<Product> discussions = [];

  Future<List<Product>> fetchDiscussion() async {
    // DO: Ganti URL
    var url = Uri.parse('https://nawalapatra.pythonanywhere.com/forum/get-discussion/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
    // melakukan konversi data json menjadi object Product
    List<Product> list_product = [];
    for (var d in data) {
      if (d != null) {
        list_product.add(Product.fromJson(d));
      }
    }
    return list_product;
  }

@override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Halaman Forum'),
        ),
        drawer: const LeftDrawer(),
        body: 
          FutureBuilder(
            future: fetchDiscussion(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Belum ada diskusi yang diunggah.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
    
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
                          color: Colors.blue.shade100,
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                                'Feel free to engage with other people',
                                style: TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 8.0),
                            const Text(
                              'Click the button below to create a new discussion!',
                              style: TextStyle(color: Colors.white),
                            ),
                            ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => DiscussionFormPage()),
                                        );
                                      },
                                      child: Text('Submit Your Discussion'),
                                    )

                            
                          ]
                        )
                        )
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
                              
                              const SizedBox(height: 10),
                              Text(
                                "by ${snapshot.data![index].fields.user}",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // const SizedBox(height: 10),
                              Divider(color: Colors.black),
                              Text(
                                "${snapshot.data![index].fields.description}",
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
