import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  initAudio() async {
    await Global.playSong['player'].open(
      Audio(Global.playSong['path']),
      autoStart: false,
    );

    setState(() {
      Global.playSong['totalDuration'] =
          Global.playSong['player'].current.value!.audio.duration;
    });
  }

  @override
  void initState() {
    super.initState();
    initAudio();
  }

  @override
  void dispose() async {
    // TODO: implement dispose
    super.dispose();
    await Global.playSong["player"].pause(); //Assestsaudiplayer().pause();
  }

  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.amber,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Now Playing",
          style: TextStyle(
            color: Colors.amber,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "${Global.playSong["name"]}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 15),
            const Divider(color: Colors.amber),
            const Spacer(),
            Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage("${Global.playSong["image"]}"),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.amber,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            StreamBuilder(
              stream: Global.playSong['player'].currentPosition,
              builder: (context, AsyncSnapshot<Duration> snapshot) {
                Duration? currentPosition = snapshot.data;

                return Column(
                  children: [
                    Text(
                      "${"$currentPosition".split(".")[0]} / ${"${Global.playSong['totalDuration']}".split(".")[0]}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Slider(
                      min: 0,
                      max:
                          Global.playSong['totalDuration'].inSeconds.toDouble(),
                      value: (currentPosition != null)
                          ? currentPosition.inSeconds.toDouble()
                          : 0,
                      onChanged: (val) async {
                        await Global.playSong['player']
                            .seek(Duration(seconds: val.toInt()));
                      },
                    ),
                  ],
                );
              },
            ),
            // SizedBox(height: 30)
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 25,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.black.withOpacity(0.95),
                      shape: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      builder: (context) {
                        return ListView.builder(
                          itemCount: Global.songs.length,
                          itemBuilder: (context, i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.amber),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  Global.playSong["player"].pause();
                                  Global.index = i;
                                  Global.playSong = Global.songs[i];
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PlayerPage()));
                              },
                              leading: Image.network(
                                "${Global.songs[i]["image"]}",
                              ),
                              title: SizedBox(
                                height: 20,
                                child: Text(
                                  "${Global.songs[i]["name"]}",
                                  style: TextStyle(
                                    color: (Global.songs[i] == Global.playSong)
                                        ? Colors.amber
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.amber,
                  ),
                ),
                IconButton(
                  iconSize: 35,
                  onPressed: () {
                    if (Global.index > 0) {
                      setState(() {
                        Global.playSong["player"].pause();
                        Global.index--;
                        Global.playSong = Global.songs[Global.index];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlayerPage()));
                    }
                  },
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                ),
                IconButton(
                  // padding: EdgeInsets.all(10),
                  iconSize: 55,
                  icon: Icon(
                    (isPlay) ? Icons.pause : Icons.play_arrow,
                    color: Colors.amber,
                  ),
                  onPressed: () async {
                    setState(() {
                      isPlay = (isPlay) ? false : true;
                    });
                    (isPlay)
                        ? await Global.playSong['player'].play()
                        : await Global.playSong['player'].pause();
                  },
                ),
                IconButton(
                  iconSize: 35,
                  onPressed: () {
                    if (Global.index < Global.songs.length - 1) {
                      setState(() {
                        Global.playSong["player"].pause();
                        Global.index++;
                        Global.playSong = Global.songs[Global.index];
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PlayerPage()));
                    }
                  },
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                ),
                IconButton(
                  iconSize: 25,
                  icon: const Icon(Icons.stop, color: Colors.amber),
                  onPressed: () async {
                    setState(() {
                      isPlay = false;
                    });
                    await Global.playSong['player'].stop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
