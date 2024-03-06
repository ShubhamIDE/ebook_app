import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ebook_app/app_colors.dart' as AppColors;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List popularBooks = List.empty();
  late ScrollController _scrollController;
  late TabController _tabController;

  ReadData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/popularBooks.json")
        .then((s) {
      setState(() {
        popularBooks = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    ReadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
          child: Scaffold(
              body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageIcon(
                  AssetImage('img/menu.png'),
                  size: 24,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.notifications)
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text("Popular Books",
                    style: TextStyle(fontSize: 30.0)),
              )
            ],
          ),
          // page slider
          const SizedBox(
            height: 15.0,
          ),
          Container(
            height: 180,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: -20.0,
                    right: 0.0,
                    child: Container(
                      height: 180,
                      child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8),
                          itemCount: popularBooks.length,
                          itemBuilder: (_, i) {
                            return Container(
                                height: 180,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(right: 10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image:
                                            AssetImage(popularBooks[i]["img"]),
                                        fit: BoxFit.fill)));
                          }),
                    ))
              ],
            ),
          ),
          Expanded(
              child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled){
              return [ 
                SliverAppBar(
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50.0),
                    child: Container(
                      margin: const EdgeInsets.all(0.0),
                      child: TabBar(
                        indicatorPadding: const EdgeInsets.all(0.0),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: const EdgeInsets.all(0.0),
                        controller: _tabController,
                        isScrollable: true,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2), 
                              blurRadius: 7, 
                              offset: Offset(0, 0) 
                            )
                          ]
                        ),
                      ),
                    ),
                  ),
                )
              ]
            }),
          )
        ],
      ))),
    );
  }
}
