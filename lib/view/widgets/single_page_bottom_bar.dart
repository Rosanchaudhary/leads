import 'package:flutter/material.dart';
import 'package:leads/models/dialog_model.dart';
import 'package:leads/view/dialogs/not_interested.dart';

class SinglePageBottomBar extends StatelessWidget {
  SinglePageBottomBar({
    Key? key,
  }) : super(key: key);

  final notInterested = <DialogModel>[
    const DialogModel(message: "Lead is not relevant to my business"),
    const DialogModel(
        message: "Customer is asking for inappropriate item or service"),
    const DialogModel(message: "Fake lead - Not a genuine customer"),
    const DialogModel(message: "I am too busy"),
    const DialogModel(message: "Bad time. I am off now."),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                      child: Text(
                        "Accept & Reply",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const Text(
                    "Only 20\$",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NotInterestdDialog(notInterested: notInterested);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                      child: Text(
                        "Not Interested",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Row(
                children: const [
                  Text(
                    "By accepting this lead you also agree with One Call",
                    style: TextStyle(fontSize: 8),
                  ),
                  Text(
                    " user acceptance policy ",
                    style: TextStyle(fontSize: 8, color: Colors.blue),
                  )
                ],
              ),
              Row(
                children: const [
                  Text(
                    "and",
                    style: TextStyle(fontSize: 8),
                  ),
                  Text(
                    " terms & conditions",
                    style: TextStyle(fontSize: 8, color: Colors.blue),
                  )
                  
                ],
              )
            ],
          ),

        ],
      ),
    );
  }
}
