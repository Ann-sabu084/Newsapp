class News {
  final String title;
  final String description;
  final String urlToImage;
  final String url;

  News({required this.title, required this.description, required this.urlToImage, required this.url});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
