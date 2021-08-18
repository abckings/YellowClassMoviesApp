import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;
import 'package:google_sign_in/google_sign_in.dart';

import '../services/db.dart';

import '../models/movie.dart';

import '../screens/movie_details_screen.dart';


class DashboardScreen extends StatefulWidget {

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'openid',
    'profile',
  ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  late int _id;
  late String _director;
  late String _title;
  late String _imageUrl;

  List<Movie> _movies = [];

  void _delete(Movie item) async {

    DB.delete(Movie.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text("Added "+_title), duration: Duration(milliseconds: 1000), ), );

    Movie item = Movie(
      id: _id,
      director: _director,
      title: _title,
      imageUrl: _imageUrl,

    );

    await DB.insert(Movie.table, item);
    setState(() => _id = _id+1 );
    refresh();
  }

  void _edit(BuildContext context,Movie movTemp) async{
    String _director = movTemp.director;
    String _title = movTemp.title;
    String _imageUrl = movTemp.imageUrl;

    if(!await _googleSignIn.isSignedIn()){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged in to edit Movies"),
      duration: Duration(milliseconds: 1000),),);
      return;
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Edit Movie Details"),
                actions: <Widget>[
                  TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop()
                  ),
                  TextButton(
                      child: Text('Update'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Edited " + _title),
                            duration: Duration(milliseconds: 1000)));
                        await DB.update(Movie.table, new Movie(id: movTemp.id,
                            title: _title,
                            imageUrl: _imageUrl,
                            director: _director));
                        setState(() => _id);
                        refresh();
                      }
                  )
                ],
                content:
                Column(
                  children: <Widget>[
                    TextFormField(
                      initialValue: movTemp.title,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Moive Name', hintText: 'e.g. Avengers',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)
                          )
                      ),
                      onChanged: (value) {
                        _title = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: movTemp.director,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Director', border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )),
                      onChanged: (value) {
                        _director = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: movTemp.imageUrl,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Poster Link', border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )),
                      onChanged: (value) {
                        _imageUrl = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
            );
          }
      );
    }
  }

  void  _create(BuildContext context) async {
    if(!await _googleSignIn.isSignedIn()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login to Add Movies"),
          duration: Duration(milliseconds: 1000),),);
      return;
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Add New Movie"),
                actions: <Widget>[
                  TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop()
                  ),
                  TextButton(
                      child: Text('Save'),
                      onPressed: () {
                        _save();
                      }
                  )
                ],
                content:
                Column(
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(labelText: 'Moive Name',
                          hintText: 'e.g. Avengers',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)
                          )),
                      onChanged: (value) {
                        _title = value;
                        _id = _id + 1;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Director', border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )),
                      onChanged: (value) {
                        _director = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Poster Link', border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)
                      )),
                      controller: new TextEditingController(),
                      onChanged: (value) {
                        _imageUrl = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
            );
          }
      );
    }
  }

  @override
  void initState() {
    refresh();
    _id = _movies.length;
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(Movie.table);
    _movies = _results.map((item) => Movie.fromMap(item)).toList();
    setState(() { });
  }

  late Icon _icon = Icon(Icons.login);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: _icon,
                onPressed: () async{
                    if(await _googleSignIn.isSignedIn() !) {
                      _handleSignIn();
                      if (await _googleSignIn.isSignedIn()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Logged in as: " +
                              _googleSignIn.currentUser.displayName),
                            duration: Duration(milliseconds: 1000),),);
                      }
                    }
                  },
              ),
              Text('Movies App'),
              IconButton(
                icon: Icon(Icons.info,color: Colors.grey,),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: Text("How to use? "),
                          content: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(child: Text("Add: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Edit: ",style: TextStyle(fontWeight: FontWeight.bold),)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Delete: ",style: TextStyle(fontWeight: FontWeight.bold),)),

                                  ]
                              ),
                              Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Flexible(child: Text("Use Green Floating Button",textAlign: TextAlign.start,overflow: TextOverflow.clip,)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Slide the movie tile to left",textAlign: TextAlign.start,overflow: TextOverflow.clip,)),
                                    SizedBox(height: 10,),
                                    Flexible(child: Text("Slide tile to right / Dismiss Tile",textAlign: TextAlign.start,overflow: TextOverflow.clip,),)

                                  ]
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.of(context).pop()
                            ),
                          ],
                        );
                      }
                  );
                },
              ),
            ],
          ),
          centerTitle: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _create(context),
        elevation: 2,
        backgroundColor: Colors.green,
        focusColor: Colors.green[900],
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Added Movies',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _movies.isEmpty ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            'No movies Found',
                            style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                        ),
                        SizedBox(height: 20),
                        Icon(Icons.mood_bad_rounded,size: 60),
                        SizedBox(height: 20),
                        Text(
                          'Add new movies using green button',
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.arrow_downward_rounded,size: 60,),
                            SizedBox(width: 20),
                          ],
                        )
                      ]
                  )
            ):ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (ctx, i) {
                  final mov = _movies[i];
                  return Column(
                    children: <Widget>[
                      Slidable(
                        key: UniqueKey(),
                        dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                          dismissThresholds: <SlideActionType, double>{
                            SlideActionType.secondary: 1.0
                          },
                          onDismissed: (actionType) {
                            if(actionType == SlideActionType.primary){
                              showDialog(
                                  context: ctx,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: Text("Do you want to delete Movie : "+mov.title),
                                      actions: <Widget>[
                                        TextButton(
                                            child: Text('Cancel'),
                                            onPressed: () => Navigator.of(context).pop()
                                        ),
                                        TextButton(
                                            child: Text('Delete'),
                                            onPressed: (){
                                              _movies.remove(mov);
                                              _delete(mov);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text("Deleted "+mov.title), duration: Duration(milliseconds: 1000)));
                                            }
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                            setState(() {});
                          },
                        ),
                        actions: [
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red[900],
                            icon: Icons.archive,
                            onTap: () {
                              showDialog(
                                  context: ctx,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                        title: Text("Do you want to delete Movie : "+mov.title),
                                        actions: <Widget>[
                                          TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () => Navigator.of(context).pop()
                                          ),
                                          TextButton(
                                              child: Text('Delete'),
                                              onPressed: (){
                                                _delete(mov);
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text("Deleted "+mov.title), duration: Duration(milliseconds: 1000), ));
                                              }
                                          )
                                        ],
                                    );
                                  }
                              );
                            },
                          ),

                        ],
                        secondaryActions: [
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.green[700],
                            icon: Icons.edit,
                            onTap: (){
                              _edit(context, mov);
                            },
                          ),
                        ],
                        actionExtentRatio: 1/4,
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
                      (i == _movies.length -1)?
                      Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                    'Swipe tile to Edit/Delete',
                                    style: TextStyle(fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    )
                                ),
                              ]
                          )
                      ):
                      SizedBox(
                        height: 10,
                      ),
                  ],
                );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
