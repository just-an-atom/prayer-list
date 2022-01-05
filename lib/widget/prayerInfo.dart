// ignore_for_file: file_names, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:prayer_list/main.dart';

import '../convert.dart';

class PrayerInfo extends StatefulWidget {
  const PrayerInfo(this.i, this.removePrayer);

  final Function removePrayer;
  final int i;

  @override
  State<PrayerInfo> createState() => _PrayerInfoState();
}

class _PrayerInfoState extends State<PrayerInfo> {
  @override
  Widget build(BuildContext context) {
    var parser = EmojiParser();
    int i = widget.i;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRad),
            topRight: Radius.circular(borderRad),
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
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
                          // Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SelectableText(
                                    parser.emojify(prayers[i].title),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  prayers[i].count > 0
                                      ? Text(
                                          "🔥 " + prayers[i].count.toString(),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const SizedBox(width: 0),
                                ],
                              ),
                              Checkbox(
                                value: prayers[i].checked,
                                onChanged: (value) {
                                  setState(() {
                                    HapticFeedback.vibrate();
                                    prayers[i].checked = value!;
                                    if (prayers[i].checked == true) {
                                      prayers[i].count++;

                                      prayers[i].lastCheck = Convert()
                                          .dateTimeToInt(DateTime.now());
                                    } else {
                                      if (prayers[i].count > 0) {
                                        prayers[i].count--;
                                      }

                                      prayers[i].date = Convert()
                                          .dateTimeToInt(DateTime.now());
                                    }
                                    saveData();
                                  });
                                },
                              )
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 5),
                          // Description
                          prayers[i].description.isEmpty
                              ? const Text(
                                  "No description set",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                )
                              : SelectableText(
                                  parser.emojify(prayers[i].description)),
                          const SizedBox(height: 20),
                          nerdyStats == true
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(),
                                    const Text(
                                      "Nerdy Stats",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Last prayed: " +
                                          DateFormat.yMMMMEEEEd().format(
                                              Convert().fromIntToDateTime(
                                                  prayers[i].lastCheck)),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "Created: " +
                                          DateFormat.yMMMMEEEEd().format(
                                              Convert().fromIntToDateTime(
                                                  prayers[i].date)),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "Prayer count: " +
                                          prayers[i].count.toString(),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                ),

                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            children: [
                              ElevatedButton(
                                onPressed: () => {
                                  Navigator.pop(context),
                                  HapticFeedback.vibrate(),
                                },
                                child: const Text("Done"),
                              ),
                              ElevatedButton(
                                onPressed: () => {
                                  widget.removePrayer(context, i),
                                },
                                child: const Text("Delete"),
                              ),
                            ],
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
  }
}
