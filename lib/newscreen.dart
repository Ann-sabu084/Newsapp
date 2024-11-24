import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_1/modal.dart';
import 'package:flutter_application_1/services.dart';
import 'package:url_launcher/url_launcher.dart';



class NewsReelsScreen extends StatefulWidget {
  @override
  _NewsReelsScreenState createState() => _NewsReelsScreenState();
}

class _NewsReelsScreenState extends State<NewsReelsScreen> {
  late Future<List<News>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = ApiService().fetchNews();  // Fetch the news articles when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('India News Reels'),
      ),
      body: FutureBuilder<List<News>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No news available.'));
          } else {
            final newsList = snapshot.data!;

            return PageView.builder(
              scrollDirection: Axis.vertical,  // Scroll vertically
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final article = newsList[index];
                return NewsReelCard(news: article);
              },
            );
          }
        },
      ),
    );
  }
}

class NewsReelCard extends StatelessWidget {
  final News news;

  NewsReelCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(news.url);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image (Using Cached Network Image for optimization)
          news.urlToImage.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: news.urlToImage,
                  fit:BoxFit.none,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                )
              : Container(color: Colors.grey), // Fallback to grey if no image

          // Text content overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            
              children: [Container(color: Colors.black,
                child: 
                 
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 234, 29, 29),
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),),
                SizedBox(height: 10),
                Text(
                  news.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open the URL: $url';
    }
  }
}
