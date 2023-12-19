import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/writersjam/writer.dart';
// import 'package:nawalapatra_mobile/writersjam/writer_models.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

// List<Item> items = [];
// DateTime now = DateTime.now();
// DateTime startOfYear = DateTime(now.year, 1, 1);
// int weekOfYear = ((now.difference(startOfYear).inDays + startOfYear.weekday) / 7).ceil();
// int currentWeek = weekOfYear % 5;
// int weekNow = currentWeek + 2;
// int promptNow = ((weekNow + 1) > 5) ? promptNow = 4 : (weekNow + 1);

class StoryFormPage extends StatefulWidget {
    const StoryFormPage({super.key});

    @override
    State<StoryFormPage> createState() => _StoryFormPageState();
}

class _StoryFormPageState extends State<StoryFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _title = "";
    String _story = "";

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
      
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Form Submit Story',
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 145,190,220),
            foregroundColor: Colors.white,
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Title",
                        labelText: "Title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _title = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Title tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Story",
                        labelText: "Story",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _story = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Story tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color.fromARGB(255, 189, 169, 149)),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                            // Kirim ke Django dan tunggu respons
                            final response = await request.postJson(
                              // TODO: pake link yg ngarah ke flutter, bikin baru
                            "https://nawalapatra.pythonanywhere.com/writersjam/create_story_flutter/",
                            jsonEncode(<String, String>{
                                'title': _title,
                                'story': _story,
                            }));

                            if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                content: Text("Story berhasil diunggah!"),
                                ));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => StoryListPage()),
                                );
                            } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content:
                                        Text("Terdapat kesalahan, silakan coba lagi."),
                                ));
                            }
                        }
                    },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                ]
            ),
          ),
        )
      );
    }
}