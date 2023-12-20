import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/forum/forum.dart';

import 'package:nawalapatra_mobile/models/discussion.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class DiscussionFormPage extends StatefulWidget {
    const DiscussionFormPage({super.key});

    @override
    State<DiscussionFormPage> createState() => _DiscussionFormPageState();
}

class _DiscussionFormPageState extends State<DiscussionFormPage> {
    final _formKey = GlobalKey<FormState>();
    String _description = "";

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
      
        return Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Form Submit Diskusi',
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
                        hintText: "Description",
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _description = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Description tidak boleh kosong!";
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
                            "https://nawalapatra.pythonanywhere.com/forum/create_discussion_flutter/",
                            jsonEncode(<String, String>{
                                'description': _description,
                            }));

                            if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                content: Text("Diskusi berhasil diunggah!"),
                                ));
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => ForumPage()),
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