import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CarouseInitialPage(),
    );
  }
}

class CarouseInitialPage extends StatefulWidget {
  const CarouseInitialPage({Key? key}) : super(key: key);

  @override
  State<CarouseInitialPage> createState() => _CarouseInitialPageState();
}

class _CarouseInitialPageState extends State<CarouseInitialPage> {
  late PageController _pageController;
  int activePage = 0;

  List<Widget> images = [
      Container(
      height: 50,
      width: 50,
      color: Colors.red,
    ),
    Container(
      height: 50,
      width: 50,
      color: Colors.blue,
    ),
    Container(
      height: 50,
      width: 50,
      color: Colors.yellow,
    ),
    Container(
      height: 50,
      width: 50,
      color: Colors.green,
    ),
  ];

  List<String> pageTexts = [
    "Oi",
    "Tchau",
    "Hello",
    "Goodbye",
  ];

  @override
  void initState() {
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: activePage,
    );
    super.initState();
  }

  List<Widget> indicators(int imagesLength, int currentIndex) {
    return List<Widget>.generate(
      imagesLength,
      (index) {
        bool isIndicatorSelected = currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.all(3),
          width: isIndicatorSelected ? 12 : 10,
          height: isIndicatorSelected ? 12 : 10,
          decoration: BoxDecoration(
            color: isIndicatorSelected ? Colors.black : Colors.black26,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                activePage = currentIndex;
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              itemCount: images.length,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              pageSnapping: true,
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return _CarouselSlider(
                  images: images,
                  pagePosition: pagePosition,
                  active: active,
                );
              },
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicators(images.length, activePage),
              ),
              Text(pageTexts[
                  activePage]), // Exibe o texto correspondente à página atual
              ElevatedButton(
                onPressed: () {
                  if (activePage == images.length - 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NextScreen()),
                    );
                  } else {
                    // Caso contrário, exibe "Próximo" e avança para a próxima página
                    setState(() {
                      activePage++;
                      _pageController.animateToPage(
                        activePage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  }
                },
                child: Text(
                    activePage == images.length - 1 ? "Avançar" : "Próximo"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NextScreen()),
                    );
                  },
                  child: Text("Pular tutorial"))
            ],
          ),
        ],
      ),
    );
  }
}

class _CarouselSlider extends StatelessWidget {
  const _CarouselSlider({
    required this.images,
    required this.pagePosition,
    required this.active,
  });

  final List<Widget> images;
  final int pagePosition;
  final bool active;

  @override
  Widget build(BuildContext context) {
    double margin = active ? 10 : 50;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      child: images[pagePosition],
    );
  }
}

class NextScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Screen'),
      ),
      body: Center(
        child: Text('This is the next screen.'),
      ),
    );
  }
}
