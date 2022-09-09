import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/controller/chip_controller.dart';
import 'package:leads/controller/data_controller.dart';
import 'package:leads/view/screens/single_lead_screen.dart';
import 'package:leads/view/widgets/lead_card.dart';

import 'widgets/filter_tabs.dart';

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
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleLead(lead: dataController.lead![index],)));
                                },
                                child:
                                    LeadCard(lead: dataController.lead![index]),
                              );
                            }),
                  )),
            ],
          ),
        ));
  }
}
