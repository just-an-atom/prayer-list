import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:intl/intl.dart';
import 'package:prayer_list/main.dart';

import '../convert.dart';

class PrayerInfo extends StatefulWidget {
  const PrayerInfo(this.i);

  final i;

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
                        SelectableText(
                          parser.emojify(prayers[i].title),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        prayers[i].description.isEmpty
                            ? const Text(
                                "No description set",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              )
                            : SelectableText(
                                parser.emojify(prayers[i].description)),
                        const SizedBox(height: 20),
                        Text(
                          "Last prayed: " +
                              DateFormat.yMMMMEEEEd().format(Convert()
                                  .fromIntToDateTime(prayers[i].lastCheck)),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Created: " +
                              DateFormat.yMMMMEEEEd().format(
                                  Convert().fromIntToDateTime(prayers[i].date)),
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Prayed " + prayers[i].count.toString() + " times",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
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
                                setState(() {
                                  prayers.removeAt(i);
                                  saveData();
                                }),
                                Navigator.pop(context),
                              },
                              child: const Text("Remove"),
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
    );
  }
}
