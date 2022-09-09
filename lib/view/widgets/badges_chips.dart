import 'package:flutter/material.dart';




class BadgesChips extends StatelessWidget {
  final String title;
  final IconData icon;
  const BadgesChips({Key? key, required this.title, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 2.0),
      child: Container(
          width: 70,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(247, 247, 247, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          )),
    );
  }
}


