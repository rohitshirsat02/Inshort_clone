import 'dart:convert';
import 'package:flutter/material.dart';
import 'bookmark_manager.dart';

class BookmarkScreen extends StatefulWidget {
  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  void loadBookmarks() async {
    List<String> savedBookmarks = await BookmarkManager().getBookmarks();
    setState(() {
      bookmarks = savedBookmarks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: bookmarks.isEmpty
          ? Center(child: Text('No bookmarks found'))
          : ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          var news = json.decode(bookmarks[index]);
          return ListTile(
            title: Text(news['title']),
            subtitle: Text(news['content']),
          );
        },
      ),
    );
  }
}
