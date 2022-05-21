import 'package:bitirme_app/widgets/delay_event.dart';
import 'package:bitirme_app/widgets/event_list.dart';
import 'package:bitirme_app/widgets/my_events.dart';
import 'package:flutter/material.dart';

class SimpleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 0,
            elevation: 0,
            bottom: TabBar(
                unselectedLabelColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.greenAccent]),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueAccent),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("PLANLI"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("POPÜLER"),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("GEÇTİ"),
                    ),
                  ),
                ]),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 10),
            child: TabBarView(children: [
              myEvents(),
              eventList(),
              delayEvent(),
            ]),
          ),
        ));
  }
}
