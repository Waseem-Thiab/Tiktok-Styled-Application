import 'package:flutter/material.dart';

class AddVideoIcon extends StatelessWidget {
  const AddVideoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45,
      height: 30,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            width: 38,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 203, 26),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            width: 38,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 233, 11, 115),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
