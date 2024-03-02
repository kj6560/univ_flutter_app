import 'package:flutter/material.dart';

class Esports extends StatelessWidget {
  const Esports({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "UNIV ESPORTS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ARENA",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
                child: Text(
                  'Univ Sportatech is proud to announce the launch of our new esports platform. Soon you will be able to participate in touranments',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: GridTile(
                      footer: Text("ABCD",style: TextStyle(color:Colors.white),),
                      child: Text(
                          "EFGH",style: TextStyle(color: Colors.white),)), //just for testing, will fill with image later
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
