import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';
import '../main.dart';
import '../widgets/waste.dart';
import '../models/waste.dart';
import '../widgets/progressbar.dart';

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
      category: WasteCategory.burnable,
    ),
    Waste(
      image: "https://cdn-icons-png.flaticon.com/512/7030/7030877.png",
      category: WasteCategory.nonBurnable,
    ),
    Waste(
      image: "https://cdn-icons-png.flaticon.com/512/7030/7030877.png",
      category: WasteCategory.nonBurnable,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // I want to add animations to these elements that is a simple fade
          // and transform up.

          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  //TODO: Change this to the user's name.
                  "Hi, World!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15, top: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 217, 217, 217),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: () {
                      print("profile pressed!");
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 217, 217, 217),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Keep going! You're doing great!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "You're 80 points away from leveling up!",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "120/200",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Progress bar
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: ProgressBar(
                      width: double.infinity,
                      height: 20,
                      progress: 0.7,
                      color: Colors.blue,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),

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
