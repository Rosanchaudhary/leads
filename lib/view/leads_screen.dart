import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/controller/chip_controller.dart';
import 'package:leads/controller/data_controller.dart';
import 'package:intl/intl.dart';
import 'package:leads/view/widgets/badges_chips.dart';

import 'widgets/filter_tabs.dart';

class LeadScreen extends StatelessWidget {
  LeadScreen({super.key});

  final ChipController chipController = Get.put(ChipController());
  final DataController dataController = Get.put(DataController());
  //name of chips given as list
  final List<String> _chipLabel = ['All', 'Rescent', 'Accepted', 'Other'];

  String getTime(String dateTime) {
    List months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    DateTime dateTimes = DateTime.parse(dateTime);
    DateTime datetimeNow = DateTime.parse(DateTime.now().toString());
    var month = months[dateTimes.month];
    var parsedTime = DateFormat('hh:mm a').format(dateTimes);
    if (dateTimes.hour <= datetimeNow.hour &&
        dateTimes.day == datetimeNow.day &&
        dateTimes.year == datetimeNow.year &&
        dateTimes.month == datetimeNow.month) {
      if (datetimeNow.hour - dateTimes.hour <= 0) {
        var totalMinutes = datetimeNow.minute - dateTimes.minute;
        return '$totalMinutes minutes';
      } else {
        var totalHours = datetimeNow.hour - dateTimes.hour;
        return '$totalHours hours';
      }
    }

    // ignore: prefer_interpolation_to_compose_strings
    return '${'$parsedTime ${dateTimes.day} ' + month},${dateTimes.year}';
  }

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
                                  padding: const EdgeInsets.all(8.0),
                                  height: 100,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: Colors.grey))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dataController.lead![index]
                                                .queryMessageModel.length
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            getTime(dataController
                                                .lead![index].datetime),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dataController.lead![index]
                                                    .queryModel.category,
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                dataController.lead![index]
                                                    .queryModel.status,
                                              )
                                            ],
                                          ),
                                          if (dataController.lead![index]
                                                  .queryModel.status ==
                                              'ACCEPTED') ...[
                                            Container(
                                              height: 19,
                                              width: 19,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      106, 203, 0, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: dataController
                                                .lead![index]
                                                .queryMessageModel
                                                .length,
                                            itemBuilder: (BuildContext context,
                                                int indexTwo) {
                                              if (dataController
                                                      .lead![index]
                                                      .queryMessageModel[
                                                          indexTwo]
                                                      .type ==
                                                  'IMAGE') {
                                                return const BadgesChips(
                                                  title: 'Picture',
                                                  icon:
                                                      Icons.camera_alt_outlined,
                                                );
                                              } else if (dataController
                                                      .lead![index]
                                                      .queryMessageModel[
                                                          indexTwo]
                                                      .type ==
                                                  'AUDIO') {
                                                return const BadgesChips(
                                                  title: "Audio",
                                                  icon: Icons
                                                      .play_circle_outlined,
                                                );
                                              } else if (dataController
                                                      .lead![index]
                                                      .queryMessageModel[
                                                          indexTwo]
                                                      .type ==
                                                  'VIDEO') {
                                                return const BadgesChips(
                                                  title: "Video",
                                                  icon: CupertinoIcons.videocam,
                                                );
                                              }
                                              return Container();
                                            }),
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

