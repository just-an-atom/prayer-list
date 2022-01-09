// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:prayer_list/main.dart';
import 'package:prayer_list/model/prayers.dart';
import 'package:prayer_list/screens/home_screen.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  _SettingsState createState() => _SettingsState();
}

TextEditingController _importJson = TextEditingController();

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();

    importData(BuildContext context) {
      List<dynamic> jsonData = jsonDecode(_importJson.text) as List<dynamic>;
      List<Prayer> tempPrayers = [];
      prayers.clear();

      for (var i = 0; i < jsonData.length; i++) {
        Prayer prayer = Prayer.fromJson(jsonData[i]);

        tempPrayers.add(prayer);
      }

      setState(() {
        prayers = tempPrayers;
      });
      prayers.sort((a, b) => b.date.compareTo(a.date));

      saveData();

      Navigator.pop(context);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("Settings"),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Raw JSON Data",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.black.withOpacity(0.1),
                    child: SelectableText(
                      parser.unemojify(jsonEncode(prayers)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Import JSON Data",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextField(
                    controller: _importJson,
                    autocorrect: false,
                    minLines: 1,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Paste JSON data here...",
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => {
                          importData(context),
                        },
                        child: Text("Import"),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: Text("Toggle Nerdy Stats"),
                    subtitle: Text("If enabled shows extra stats"),
                    value: nerdyStats,
                    onChanged: (value) {
                      setState(() {
                        nerdyStats = value;
                      });
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
