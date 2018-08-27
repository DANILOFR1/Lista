import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';




void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Mestres de RPG'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<User>> _getUsers() async {
    var data = await http
        .get('https://next.json-generator.com/api/json/get/4JBMU_3UB');
    var jsonData = json.decode(data.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["index"], u["picture"], u["name"], u["email"],
          u["phone"], u["address"], u["about"]);

      users.add(user);
    }

    print(users.length);

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data[index].picture),
                    ),
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].address),
                    onTap: (){
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}





class DetailPage extends StatelessWidget{

  final User user;


  DetailPage(this.user);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.phone, color: Colors.amber), onPressed: (){},),
        ],
      ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[

                Padding(padding: EdgeInsets.all(20.0),
                child: Text(user.about, textAlign: TextAlign.justify , style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
                ),
              ),
              Text(user.phone, textAlign: TextAlign.justify , style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
              ),
              Text(user.email, textAlign: TextAlign.justify , style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)
              ),
            ],
          ),

        ),

    );
  }
}

class User {
  final int index;

  final String picture;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String about;

  User(this.index, this.picture, this.name, this.email, this.phone,
      this.address, this.about);
}
