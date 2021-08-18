import 'package:flutter/material.dart';


class AddMovieScreen extends StatelessWidget {
  static const routeName = '/addMovie';
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text('Add Movie'),
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
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  labelText: 'Movie Name',
                  prefixIcon: Icon(Icons.movie,color: Colors.white70),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                prefixIcon: Icon(Icons.person,color: Colors.white70),
                labelText: 'Director Name',
                focusColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  color: Colors.green[700],
                  child: TextButton.icon(
                    onPressed: () {

                    },
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }
}