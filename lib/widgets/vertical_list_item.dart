import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../screens/movie_details_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class VerticalListItem extends StatelessWidget {
  final int index;
  final Movie mov;
  VerticalListItem(this.index,this.mov);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Slidable(

              actionPane: SlidableDrawerActionPane(),
              child:GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MovieDetailsScreen(mov)),
                );
              },
              child: Card(
                elevation: 5,
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: mov.id,
                      child: Container(
                        height: 150,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            topLeft: Radius.circular(5),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              mov.imageUrl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      height: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Movie: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                mov.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  "Director: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 120,
                                child: Text(
                                  mov.director,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),
        ],
    );
  }
}
