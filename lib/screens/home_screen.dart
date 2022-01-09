// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:prayer_list/providers/checkmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:prayer_list/convert.dart';
import 'package:prayer_list/main.dart';
import 'package:prayer_list/model/prayers.dart';
import 'package:prayer_list/settings.dart';
import 'package:prayer_list/widget/prayerInfo.dart';

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
      history: prayers[i].history,
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

    // Prayer Popup
    Future newPrayer(BuildContext context, List<Prayer> prayers) async {
      TextEditingController _noteInput = TextEditingController();
      TextEditingController _descriptionInput = TextEditingController();

      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext bc) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRad),
                    topRight: Radius.circular(borderRad),
                  ),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
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
                                  Text(
                                    "New Prayer",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(),
                                  TextField(
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    controller: _noteInput,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    minLines: 1,
                                    maxLines: 1,
                                    decoration: const InputDecoration(
                                      labelText: "Enter prayer...",
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
                                      labelText: "Add details...",
                                      labelStyle: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: TextButton(
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
                                            history: [],
                                            count: 0,
                                          ),
                                        ),
                                        Navigator.pop(context),
                                        saveData(),
                                        HapticFeedback.vibrate(),
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            "Create",
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
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
              ),
            );
          });
    }

    prayerInfo(
        BuildContext context, List<Prayer> prayers, int i, removePrayer) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
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
              expandedHeight: 300,
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
                        onTap: () =>
                            prayerInfo(context, prayers, i, removePrayer),
                        onLongPress: () => removePrayer(context, i),
                        title: Row(
                          children: [
                            Text(
                              prayers[i].title.isEmpty
                                  ? "Blank"
                                  : parser.emojify(prayers[i].title),
                              style: TextStyle(
                                fontStyle: prayers[i].title.isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                decoration: prayers[i].checked
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            const SizedBox(width: 10),
                            prayers[i].count > 0
                                ? Text(
                                    "🔥 " + prayers[i].count.toString(),
                                  )
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
                              context.read<Checkmark>().checkToggle(i);
                            });
                          },

                          /*

(value) {
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
                          }

                          */
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
