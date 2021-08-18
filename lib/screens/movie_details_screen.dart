import 'package:flutter/material.dart';

import '../models/movie.dart';


class MovieDetailsScreen extends StatelessWidget {
  static const routeName = '/movieDetails';

  final Movie _mov;

  MovieDetailsScreen(this._mov);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text('Movie Details'),
          centerTitle: true,
          elevation: 2,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: Card(
                elevation: 5,
                child: Hero(
                  tag: _mov.id,
                  child: Container(
                    height: 450,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          _mov.imageUrl,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              _mov.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "Director: ",
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  _mov.director,
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

          ],
        ),
      ),

    );
  }
}
