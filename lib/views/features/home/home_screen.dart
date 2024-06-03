import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recycle/utils/providers/user_data_provider.dart';
import 'package:recycle/utils/data_classes.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomeState();
}

class _MyHomeState extends ConsumerState<HomeTab> {
  List<String> categories = [
    'Plastic',
    'Recyclable',
    'Burnable',
    'Non-burnable',
    'Oversized Burnable',
    'Oversized Non-burnable',
    'Hazardous Waste',
    "We Don't Collect",
  ];

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          // Welcome User Row
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: <Widget>[
                const Text(
                  'Hi, ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  userData[UserData.keyProfileUsername] ?? "J. Doe",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Points Container
          Container(
            margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Keep going!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "You are 80 points away from leveling up!",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  // Add a progress bar here
                  // text to show the points progress
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "120/200",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                  ),
                  LinearProgressIndicator(
                      value: 0.8,
                      backgroundColor: Colors.grey[300],
                      minHeight: 20,
                      borderRadius: BorderRadius.circular(10),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(152, 203, 81, 1))),
                ],
              ),
            ),
          ),

          // Waste Categories
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Waste Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Waste Categories List
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              categories[index],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
