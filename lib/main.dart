// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:prayer_list/settings.dart';
import 'package:prayer_list/widget/prayerInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/prayers.dart';
import './convert.dart';

List<Prayer> prayers = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const title = "Prayer List";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

saveData() async {
  print("save");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var parser = EmojiParser();

  List<String> prayersJson = [];

  for (var i = 0; i < prayers.length; i++) {
    Prayer temp = Prayer(
      title: parser.emojify(prayers[i].title),
      description: parser.emojify(prayers[i].description),
      date: prayers[i].date,
      checked: prayers[i].checked,
      lastCheck: prayers[i].lastCheck,
      previousCheck: prayers[i].previousCheck,
      count: prayers[i].count,
    );

    prayersJson.add(temp.toJson().toString());
  }

  prefs.setStringList("prayers", prayersJson);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  removePrayer(BuildContext context, int i) {
    Navigator.pop(context);

    print("Removing: " + prayers[i].toString());
    setState(() {
      prayers.remove(prayers[i]);
    });
    saveData();
  }

  getData() async {
    print("Clearing old Data...");

    prayers.clear();

    print("Getting data...");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> prayersJson = [];
    prayersJson = prefs.getStringList("prayers") ?? [];

    if (prayersJson != null || prayersJson.isNotEmpty) {
      for (var i = 0; i < prayersJson.length; i++) {
        Prayer prayer = Prayer.fromJson(prayersJson[i]);

        DateTime today = DateTime.now();

        DateTime lastCheck = Convert().fromIntToDateTime(prayer.lastCheck);

        lastCheck = lastCheck.subtract(Duration(
          hours: lastCheck.hour,
          minutes: lastCheck.minute,
          seconds: lastCheck.second,
          milliseconds: lastCheck.millisecond,
          microseconds: lastCheck.microsecond,
        ));

        DateTime prayerAvailableTime = lastCheck.add(const Duration(days: 1));

        print(prayerAvailableTime);

        setState(() {
          // Check if it's the next day.
          // If so allow the user to check off that prayer.
          if (Convert().dateTimeToInt(today) >=
              Convert().dateTimeToInt(prayerAvailableTime)) {
            prayer.checked = false;
          }

          prayers.add(prayer);

          prayers.sort((a, b) => b.date.compareTo(a.date));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();

    Future newPrayer(BuildContext context, List<Prayer> prayers) async {
      TextEditingController _noteInput = TextEditingController();
      TextEditingController _descriptionInput = TextEditingController();

      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .4,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "New Prayer",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  style: TextStyle(fontSize: 16),
                                  controller: _noteInput,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    labelText: "Enter prayer here...",
                                    labelStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: _descriptionInput,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  minLines: 1,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    labelText: "Enter prayer description...",
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () => {
                                    prayers.add(
                                      Prayer(
                                        title: _noteInput.text,
                                        description: _descriptionInput.text,
                                        date: Convert()
                                            .dateTimeToInt(DateTime.now()),
                                        checked: false,
                                        lastCheck: Convert()
                                            .dateTimeToInt(DateTime.now()),
                                        previousCheck: Convert()
                                            .dateTimeToInt(DateTime.now()),
                                        count: 0,
                                      ),
                                    ),
                                    Navigator.pop(context),
                                    saveData(),
                                    HapticFeedback.vibrate(),
                                  },
                                  child: const Text("Create"),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }

    prayerInfo(
        BuildContext context, List<Prayer> prayers, int i, removePrayer) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext bc) {
            return PrayerInfo(i, removePrayer);
          });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData();
          });
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  )
                },
                icon: Icon(Icons.settings),
              ),
              pinned: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.asset(
                  "./assets/header.jpg",
                  fit: BoxFit.cover,
                ),
                title: Text(widget.title),
                centerTitle: false,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () => setState(() {
                          prayers[i].checked = !prayers[i].checked;
                          if (prayers[i].checked == true) {
                            prayers[i].count++;

                            prayers[i].previousCheck = prayers[i].lastCheck;

                            prayers[i].lastCheck =
                                Convert().dateTimeToInt(DateTime.now());
                          } else {
                            if (prayers[i].count > 0) {
                              prayers[i].count--;
                            }

                            prayers[i].lastCheck = prayers[i].previousCheck;

                            prayers[i].date =
                                Convert().dateTimeToInt(DateTime.now());
                          }
                          saveData();
                          HapticFeedback.vibrate();
                        }),
                        onLongPress: () =>
                            prayerInfo(context, prayers, i, removePrayer),
                        title: Row(
                          children: [
                            Text(
                              prayers[i].title.isEmpty
                                  ? "Empty"
                                  : parser.emojify(prayers[i].title),
                              style: TextStyle(
                                decoration: prayers[i].checked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 10),
                            prayers[i].count > 0
                                ? Text("🔥 " + prayers[i].count.toString())
                                : Container(),
                          ],
                        ),
                        subtitle: Text(
                          DateFormat.yMMMMEEEEd().format(Convert()
                              .fromIntToDateTime(prayers[i].lastCheck)),
                          style: TextStyle(
                            decoration: prayers[i].checked
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        trailing: Checkbox(
                          value: prayers[i].checked,
                          onChanged: (value) {
                            setState(() {
                              HapticFeedback.vibrate();
                              prayers[i].checked = value!;
                              if (prayers[i].checked == true) {
                                prayers[i].count++;

                                prayers[i].lastCheck =
                                    Convert().dateTimeToInt(DateTime.now());
                              } else {
                                if (prayers[i].count > 0) {
                                  prayers[i].count--;
                                }

                                prayers[i].date =
                                    Convert().dateTimeToInt(DateTime.now());
                              }
                              saveData();
                            });
                          },
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
                childCount: prayers.length,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newPrayer(context, prayers),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
