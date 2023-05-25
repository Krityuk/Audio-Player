import 'package:flutter/material.dart';
import 'package:flutterfalanshu/screens/player_page.dart';

import '../global.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Music Player",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: Global.songs.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border(
              top: (i == 0)
                  ? const BorderSide(color: Colors.amber)
                  : BorderSide.none,
              bottom: const BorderSide(color: Colors.amber),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: ListTile(
            onTap: () {
              setState(() {
                Global.index = i;
                Global.playSong = Global.songs[i];
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PlayerPage()));
            },
            leading: Image.network(
              "${Global.songs[i]["image"]}",
            ),
            title: SizedBox(
              height: 20,
              child: Text(
                "${Global.songs[i]["name"]}",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
