import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:http/http.dart' as http;
import 'bookmark_manager.dart';
import 'bookmark_screen.dart'; // Import BookmarkScreen
import 'home_screen.dart'; // Import HomeScreen

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List newsData = [];
  String selectedCategory = 'national';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(
        Uri.parse('https://inshortsapi.vercel.app/news?category=$selectedCategory'));
    if (response.statusCode == 200) {
      setState(() {
        newsData = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News - $selectedCategory'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedCategory = value;
                fetchNews();
              });
            },
            itemBuilder: (context) {
              return <String>[
                'all',
                'national',
                'business',
                'sports',
                'world',
                'politics',
                'technology',
                'startup',
                'entertainment',
                'miscellaneous',
                'hatke',
                'science',
                'automobile'
              ].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: newsData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Swiper(
        itemCount: newsData.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(newsData[index]['imageUrl']),
                SizedBox(height: 10),
                Text(
                  newsData[index]['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(newsData[index]['content']),
                IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    final news = json.encode(newsData[index]);
                    BookmarkManager().saveBookmark(news);
                  },
                ),
              ],
            ),
          );
        },
        control: SwiperControl(),
      ),
    );
  }
}
