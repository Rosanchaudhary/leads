import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leads/controller/commons/common_controller.dart';
import 'package:leads/models/dialog_model.dart';
import 'package:leads/models/lead_model.dart';
import 'package:leads/view/dialogs/report_dialog.dart';
import 'package:leads/view/widgets/audio_player_card.dart';
import 'package:leads/view/widgets/bottom_chat_widget.dart';
import 'package:leads/view/widgets/single_page_bottom_bar.dart';
import 'package:leads/view/widgets/video_player_widget.dart';

class SingleLead extends StatelessWidget {
  final LeadModel lead;
  SingleLead({super.key, required this.lead});

  final CommonController commonController = Get.put(CommonController());

  final reports = <DialogModel>[
    const DialogModel(
        message: "Customer is asking for inappropriate item or service"),
    const DialogModel(message: "Fake lead - Not a genuine customer"),
    const DialogModel(message: "Spam"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 32,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Container(
              width: 35,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(247, 247, 247, 1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Icon(
                  Icons.more_horiz_outlined,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
        title: Column(
          children: [
            const Text(
              'Real Estate',
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
            Text(
              commonController.getTime(lead.datetime),
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            )),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: lead.queryMessageModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (lead.queryMessageModel[index].type == 'IMAGE') {
                          return SizedBox(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    lead.queryMessageModel[index].content,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: 150,
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                )
                              ],
                            ),
                          );
                        } else if (lead.queryMessageModel[index].type ==
                            'AUDIO') {
                          return const AudioPlayerCard();
                        } else if (lead.queryMessageModel[index].type ==
                            'VIDEO') {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: 200,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: VideoPlayerWidget(
                                    videoUrl:
                                        lead.queryMessageModel[index].content,
                                  )),
                                  const SizedBox(
                                    width: 60,
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
                if (lead.status == 'COMPOSITION') ...[
                  const BottomChatWidget()
                ] else ...[
                  SinglePageBottomBar()
                ],
              ],
            ),
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              initialChildSize: 0.01,
              minChildSize: 0.01,
              maxChildSize: 0.3,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Container(
                          height: 6.0,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ReportDialog(reports: reports);
                                    });
                              },
                              child: Column(
                                children: const [
                                  Text("Report",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                  Divider(
                                    thickness: 2,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: const [
                                Text("Need help",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                            Column(
                              children: const [
                                Text("Reject Lead",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                                Divider(
                                  thickness: 2,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
