import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'crud.dart';

import 'dart:io';

class BlogInputScreen extends StatefulWidget {
  @override
  _BlogInputScreenState createState() => _BlogInputScreenState();
}

class _BlogInputScreenState extends State<BlogInputScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _authorController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _desController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  Crud crud = Crud();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _onSubmit() async {
    if (_image != null) {
      var isvalidate = _formKey.currentState!.validate();

      if (!isvalidate) {
        return;
      }
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      var _random = new Random();

      final _ref = FirebaseStorage.instance
          .ref()
          .child('images')
          .child('${_random.nextInt(1000000000)}.jpg');

      await _ref.putFile(_image!);

      var downloadUrl = await _ref.getDownloadURL();

      Map<String, String> blogInfom = {
        'author': _authorController.text,
        'title': _titleController.text,
        'description': _desController.text,
        'imageUrl': downloadUrl,
        'createdAt': Timestamp.now().toString(),
      };
      await crud.addData(blogInfom);

      print(downloadUrl);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Flutter'),
            Text(
              'Blog',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: _onSubmit,
              icon: Icon(Icons.file_upload),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: _image == null
                          ? Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image(
                                  image: FileImage(_image!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Author Name',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (v) {
                                if (v!.length < 1) {
                                  return 'Plz enter Author Name';
                                }
                                return null;
                              },
                              controller: _authorController,
                              onSaved: (v) {
                                _authorController.text = v!;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (v) {
                                if (v!.length < 1) {
                                  return 'Plz enter title';
                                }
                                return null;
                              },
                              onSaved: (v) {
                                _titleController.text = v!;
                              },
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (v) {
                                if (v == null) {
                                  return 'Plz enter description';
                                } else if (v.length < 10) {
                                  return 'description contains atleats 10 char';
                                }
                                return null;
                              },
                              onSaved: (v) {
                                _desController.text = v!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
