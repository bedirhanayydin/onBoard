import 'package:flutter/material.dart';
import 'package:on_board/second_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('onBoard') ?? false;
  runApp(MyApp(onBoard: showHome));
}

class MyApp extends StatelessWidget {
  final bool onBoard;

  const MyApp({Key? key, required this.onBoard}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: onBoard ? const SecondPage() : const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              isLastPage = value == 2;
            });
          },
          children: [
            Container(
              color: Colors.red,
              child: const Center(child: Text('Page1')),
            ),
            Container(
              color: const Color.fromARGB(255, 172, 102, 102),
              child: const Center(child: Text('Page2')),
            ),
            Container(
              color: Colors.blue,
              child: const Center(child: Text('Page3')),
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                primary: const Color.fromARGB(255, 182, 5, 5),
                backgroundColor: Colors.teal,
                minimumSize: const Size.fromHeight(80),
              ),
              child: const Text('Get Started'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('onBoard', true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const SecondPage()));
              },
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        controller.jumpToPage(2);
                      },
                      child: const Text('Skip')),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.teal.shade700,
                      ),
                      onDotClicked: (index) {
                        controller.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Next')),
                ],
              ),
            ),
    );
  }
}
