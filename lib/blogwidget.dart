import 'package:flutter/material.dart';

class DisplayBlog extends StatelessWidget {
  final String url;
  final String author;
  final String title;
  final String desc;

  DisplayBlog(
      {required this.title,
      required this.author,
      required this.desc,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: NetworkImage(url),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black38,
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: Text(
                    author,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
