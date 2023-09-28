import 'package:flutter/material.dart';

class IncreaseDecrease extends StatelessWidget {
  final int? i, count;
  final Function changeCount;
  const IncreaseDecrease(
      {super.key,
      required this.i,
      required this.count,
      required this.changeCount});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (i == 1 && count == 1)
        IconButton(
            onPressed: () {
              changeCount(true, i);
            },
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xff006966),
            )),
      if (i == count && count != 1) ...[
        IconButton(
            onPressed: () {
              changeCount(true, i);
            },
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xff006966),
            )),
        IconButton(
            onPressed: () {
              changeCount(false, i);
            },
            icon: const Icon(
              Icons.remove_circle,
              color: Color(0xff006966),
            )),
      ],
      // if (i! < count!)
      //   IconButton(
      //       onPressed: () {
      //         changeCount(false, i);
      //       },
      //       icon: const Icon(
      //         Icons.remove_circle,
      //         color: Color(0xff006966),
      //       )),
    ]);
  }
}
