import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/controller/chip_controller.dart';
import 'package:leads/controller/data_controller.dart';
import 'package:leads/models/lead_model.dart';

class LeadScreen extends StatelessWidget {
  LeadScreen({super.key});

  final ChipController chipController = Get.put(ChipController());
  final DataController dataController = Get.put(DataController());
  //name of chips given as list
  final List<String> _chipLabel = ['All', 'Rescent', 'Accepted', 'Other'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SafeArea(
      child: Column(
        children: [
          FIlterTabs(chipLabel: _chipLabel, dataController: dataController),
          Obx(() => Expanded(
                child: dataController.isDataLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: dataController.lead!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: Colors.grey))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dataController.lead![index].id
                                            .toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        dataController.lead![index].datetime
                                            .toString(),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    dataController
                                        .lead![index].queryModel.category,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    dataController
                                        .lead![index].queryModel.status,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
              )),
        ],
      ),
    ));
  }
}

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
            border: Border(bottom: BorderSide(width:0.5, color: Colors.black))),
        child: Wrap(
          spacing: 20,
          children: List<Widget>.generate(4, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = index;
                });

                widget.dataController.readJson(Filters.values[index]);
              },
              child: Container(
                width: 60,
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
