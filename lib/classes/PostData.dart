class PostData {
  late String id;
  late String title;
  late String description;
  late int likes;
  late int dislikes;
  late String imageUrl;
  late Author author;
  late String createdAt;
  late String updatedAt;

  PostData(
      {required this.id,
      required this.title,
      required this.description,
      required this.likes,
      required this.dislikes,
      required this.imageUrl,
      required this.author,
      required this.createdAt,
      required this.updatedAt});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    likes = json['likes'];
    dislikes = json['dislikes'];
    imageUrl = json['imageUrl'];
    author = Author.fromJson(json['author']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['likes'] = this.likes;
    data['dislikes'] = this.dislikes;
    data['imageUrl'] = this.imageUrl;
    data['author'] = this.author.toJson();
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Author {
  late String id;
  late String login;

  Author({required this.id, required this.login});

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login'] = this.login;
    return data;
  }
}
