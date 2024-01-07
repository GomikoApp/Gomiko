import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import '../main.dart';
import '../widgets/waste.dart';
import '../models/waste.dart';

class HomePage extends StatefulWidget {
  // title parameter is not necessary here, its just for testing.
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Uncomment this code after finishing the home page.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   var appState = Provider.of<MyAppChangeNotifier>(context, listen: false);

    //   // Check if user is logged in, if not, push login page to screen.
    //   if (!appState.loggedIn) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const LoginPage(title: "Login"),
    //       ),
    //     );
    //   }
    // });
  }

  final List<Waste> wasteCategories = [
    Waste(
      // Use assets instead of network images in the future.
      image: "https://cdn-icons-png.flaticon.com/512/5835/5835713.png",
      category: WasteCategory.plastic,
      type: WasteType.recyclable,
    ),
    Waste(
      image: "https://cdn-icons-png.flaticon.com/512/7030/7030877.png",
      category: WasteCategory.glass,
      type: WasteType.recyclable,
    ),
    Waste(
      image: "https://cdn-icons-png.flaticon.com/512/7030/7030877.png",
      category: WasteCategory.glass,
      type: WasteType.recyclable,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // I want to add animations to these elements that is a simple fade
          // and transform up.

          // Stack(
          //   children: [
          //     Transform.scale(
          //       alignment: Alignment.center,
          //       scale: 1.1,
          //       child: Container(
          //         height: 200,
          //         decoration: ShapeDecoration(
          //           shape: const CircleBorder(
          //             side: BorderSide.none,
          //           ),
          //           gradient: LinearGradient(
          //             begin: Alignment.topRight,
          //             end: Alignment.bottomLeft,
          //             colors: [
          //               Colors.green[300]!,
          //               Colors.green[300]!,
          //               Colors.white,
          //               Colors.white,
          //               Colors.white,
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     Transform.scale(
          //       alignment: Alignment.centerRight,
          //       scale: 1.7,
          //       child: Container(
          //         height: 200,
          //         decoration: ShapeDecoration(
          //           shape: const CircleBorder(
          //             side: BorderSide.none,
          //           ),
          //           gradient: LinearGradient(
          //             begin: Alignment.topLeft,
          //             end: Alignment.bottomRight,
          //             colors: [
          //               Colors.green[400]!,
          //               Colors.green[200]!,
          //               Colors.white,
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     const Padding(
          //       padding: EdgeInsets.only(top: 50, left: 20),
          //       child: Text(
          //         "Gomiko",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 30,
          //         ),
          //       ),
          //     ),
          //     const Column(
          //       children: [
          //         SizedBox(height: 100),
          //         Padding(
          //           padding: EdgeInsets.only(left: 20),
          //           child: Text(
          //             "Keep going!",
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(left: 20),
          //           child: Text(
          //             "You're 80 points away from leveling up!",
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontWeight: FontWeight.bold,
          //               fontSize: 20,
          //             ),
          //           ),
          //         ),
          //       ],
          //     )
          //   ],
          // ),

          const SizedBox(height: 20),

          // Waste Categories
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 217, 217),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        "Waste Categories",
                        textScaler: TextScaler.linear(1.5),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 175,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: wasteCategories.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return WasteCard(waste: wasteCategories[index]);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
