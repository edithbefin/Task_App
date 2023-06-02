import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_app3/utils/colors_util.dart';
import 'utils/date_utils.dart' as date_util;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;
  List<DateTime> currentMonthList = List.empty();
  DateTime currentDateTime = DateTime.now();
  List<String> todos = <String>[];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);
    super.initState();
  }

  Widget horizontalContainer() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height * .23,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 1).withOpacity(1),
          boxShadow: const [
            BoxShadow(
                blurRadius: 4,
                color: Color.fromARGB(31, 177, 151, 151),
                offset: Offset(4, 4),
                spreadRadius: 2)
          ],
          borderRadius: const BorderRadius.only(
              // bottomRight: Radius.circular(40),
              // bottomLeft: Radius.circular(40),
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              titleView(),
              hrizontalCapsuleListView(),
            ]),
      ),
    );
  }

  Widget titleView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Text(
        date_util.DateUtils.months[currentDateTime.month - 1] +
            ' ' +
            currentDateTime.year.toString(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget hrizontalCapsuleListView() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: 150,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: currentMonthList.length,
        itemBuilder: (BuildContext context, int index) {
          return capsuleView(index);
        },
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
            });
          },
          child: Container(
            width: 80,
            height: 140,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: (currentMonthList[index].day != currentDateTime.day)
                        ? [
                            Color.fromARGB(255, 229, 190, 243).withOpacity(0.8),
                            Color.fromARGB(255, 243, 167, 167).withOpacity(0.7),
                            Color.fromARGB(255, 234, 250, 221).withOpacity(0.6)
                          ]
                        : [
                            HexColor("ED6184"),
                            HexColor("EF315B"),
                            HexColor("E2042D")
                          ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.0, 1.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: BorderRadius.circular(40),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(4, 4),
                    blurRadius: 4,
                    spreadRadius: 2,
                    color: Colors.black12,
                  )
                ]),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            (currentMonthList[index].day != currentDateTime.day)
                                ? HexColor("465876")
                                : Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget floatingActionBtn() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Container(
          width: 100,
          height: 100,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 229, 190, 243).withOpacity(1),
                    Color.fromARGB(255, 243, 167, 167).withOpacity(0.7),
                    Color.fromARGB(255, 234, 250, 221).withOpacity(0.6)
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp)),
        ),
        onPressed: () {
          controller.text = "";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: 320,
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Add Todo",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: controller,
                          style: const TextStyle(color: Colors.white),
                          autofocus: true,
                          decoration: const InputDecoration(
                              hintText: 'Add your new todo item',
                              hintStyle: TextStyle(color: Colors.white60)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 320,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                todos.add(controller.text);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text("Add Todo"),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget todoList() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: todos.length,
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            width: width - 20,
            height: 70,
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.white12,
                      blurRadius: 2,
                      offset: Offset(2, 2),
                      spreadRadius: 3)
                ]),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  color: Color.fromARGB(255, 0, 0, 0),
                  highlightColor: Colors.amberAccent, //<-- SEE HERE
                  iconSize: 30,
                  icon: Icon(
                    Icons.label_important,
                  ),
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text(todos[index],
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, color: Colors.black)),
              ],
            ),
          );
        });
  }

  Widget drawerMenu() {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: const EdgeInsets.all(11.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Roomates",
                  style: GoogleFonts.bebasNeue(
                      fontSize: 40, color: Color.fromARGB(255, 227, 218, 218)),
                ),
              ),
            ),
            // decoration: BoxDecoration(
            //   color: Color.fromARGB(255, 2, 2, 2),
            // ),
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/download.png'),
            ),
            title: const Text(
              'Charlie Max',
            ),
            subtitle: Text('9876543210'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Text('Another data');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/download1.png'),
            ),
            title: const Text(
              'John Judah',
            ),
            subtitle: Text('9876543210'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Text('Another data');
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/images.png'),
            ),
            title: const Text(
              'Zoah Zoro',
            ),
            subtitle: Text('9876543210'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Text('Another data');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: drawerMenu(),

        appBar: AppBar(
          elevation: 0,
          title: const Text(""),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.person),
            ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),

        //botom nav bar
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: () {}, child: const Icon(Icons.home)),
                label: ''),
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: () {},
                    child: const Icon(Icons.notifications_active)),
                label: ''),
            BottomNavigationBarItem(
                icon: GestureDetector(
                    onTap: () {}, child: const Icon(Icons.settings)),
                label: ''),
          ],
        ),

//body
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Task Todo",
                    style: GoogleFonts.bebasNeue(
                      fontSize: 56,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  height: height / 5,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 1).withOpacity(1),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height / 6,
                        width: width / 1.5,

                        //child: Lottie.asset('assets/hos.json'),
                        child: Lottie.asset(
                            fit: BoxFit.cover,
                            'assets/MAN WITH TASK LIST.json'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: horizontalContainer(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  height: 70,
                  width: width,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Center(
                    child: Text(
                      "Your Tasks",
                      style: GoogleFonts.bebasNeue(
                          fontSize: 40, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  height: height / 4,
                  width: width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[todoList()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: floatingActionBtn(),
      ),
    );
  }
}
