import 'package:flutter/material.dart';
import '../../animation/fade_route.dart';
import '../screens/settings.dart';

class HomeTop extends StatelessWidget {
  const HomeTop({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Stack(children: [
              Positioned(
                  top: MediaQuery.of(context).padding.top * 2,
                  left: width * .075,
                  child: const Row(
                    children: [
                      Image(
                        image: AssetImage('assets/images/islam.png'),
                        height: 24,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Masha Allah',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ],
                  )),
              Positioned(
                  top: MediaQuery.of(context).padding.top * 1.5,
                  right: width * .05,
                  child: IconButton(
                    icon: const Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context, FadeRoute(page: const Settings()));
                      // Navigator.of(context).pushNamed(Settings.routeName);
                    },
                  )),
              Positioned(
                top: constraints.maxHeight * .3,
                left: width * .075,
                right: width * .01,
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Zam Zam Mobiles',
                          style: TextStyle(fontSize: 40, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              )
            ]));
  }
}
