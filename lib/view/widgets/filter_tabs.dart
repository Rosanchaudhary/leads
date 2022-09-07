import 'package:flutter/material.dart';
import 'package:leads/controller/data_controller.dart';
import 'package:leads/models/lead_model.dart';

class FIlterTabs extends StatefulWidget {
  const FIlterTabs({
    Key? key,
    required List<String> chipLabel,
    required this.dataController,
  })  : _chipLabel = chipLabel,
        super(key: key);

  final List<String> _chipLabel;
  final DataController dataController;

  @override
  State<FIlterTabs> createState() => _FIlterTabsState();
}

class _FIlterTabsState extends State<FIlterTabs> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 0.5, color: Colors.black))),
        child: Wrap(
          spacing: 10,
          children: List<Widget>.generate(4, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = index;
                });

                widget.dataController.readJson(Filters.values[index]);
              },
              child: Container(
                width: 65,
                decoration: BoxDecoration(
                    border: selected == index
                        ? const Border(
                            bottom: BorderSide(width: 1, color: Colors.black))
                        : null),
                child: Center(
                  child: Text(
                    widget._chipLabel[index],
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}