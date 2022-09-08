import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/controller/commons/common_controller.dart';
import 'package:leads/models/lead_model.dart';
import 'package:leads/view/widgets/badges_chips.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  LeadCard({super.key, required this.lead});

  final CommonController commonController = Get.put(CommonController());


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 100,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lead.queryMessageModel.length.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                 commonController.getTime(lead.datetime),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.queryModel.category,
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      lead.queryModel.status,
                    )
                  ],
                ),
                if (lead.queryModel.status == 'ACCEPTED') ...[
                  Container(
                    height: 19,
                    width: 19,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(106, 203, 0, 1),
                        borderRadius: BorderRadius.circular(25)),
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
                  itemCount: lead.queryMessageModel.length,
                  itemBuilder: (BuildContext context, int indexTwo) {
                    if (lead.queryMessageModel[indexTwo].type == 'IMAGE') {
                                            return const BadgesChips(
                        title: 'Picture',
                        icon: Icons.camera_alt_outlined,
                      );
                    } else if (lead.queryMessageModel[indexTwo].type ==
                        'AUDIO') {
                      return const BadgesChips(
                        title: "Audio",
                        icon: Icons.play_circle_outlined,
                      );
                    } else if (lead.queryMessageModel[indexTwo].type ==
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
  }
}
