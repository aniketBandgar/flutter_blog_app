import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blog_app/blogInputScreen.dart';
import 'package:flutter_blog_app/blogwidget.dart';

class HomePageApp extends StatefulWidget {
  @override
  _HomePageAppState createState() => _HomePageAppState();
}

class _HomePageAppState extends State<HomePageApp> {
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('blogs')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, streamSnapShot) {
            if (streamSnapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final blogData = (streamSnapShot.data! as QuerySnapshot).docs;
            return ListView.builder(
              itemCount: blogData.length,
              itemBuilder: (ctx, i) {
                return DisplayBlog(
                    title: blogData[i]['title'],
                    author: blogData[i]['author'],
                    desc: blogData[i]['description'],
                    url: blogData[i]['imageUrl']);
              },
            );
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => BlogInputScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
