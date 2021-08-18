import 'package:random_db/models/model.dart';

class Movie extends Model{
  static String table = 'movies';

  final int id;
  final String title;
  final String imageUrl;
  final String director;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.director,
  });

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {
      'id' : id,
      'title': title,
      'imageUrl': imageUrl,
      'director': director,
    };

    map['id'] = id;
    return map;
  }

  static Movie fromMap(Map<String, dynamic> map) {

    return Movie(
        id: map['id'],
        title: map['title'],
        imageUrl: map['imageUrl'],
        director: map['director']
    );
  }

  @override
  String toString(){
    return (id.toString()+" "+title+" "+director+" "+imageUrl);
  }
}
