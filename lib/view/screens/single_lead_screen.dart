import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:leads/controller/commons/common_controller.dart';
import 'package:leads/controller/commons/enums.dart';
import 'package:leads/controller/commons/utils.dart';
import 'package:leads/models/lead_model.dart';
import 'package:leads/view/widgets/video_player_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SingleLead extends StatelessWidget {
  final LeadModel lead;
  SingleLead({super.key, required this.lead});

  final CommonController commonController = Get.put(CommonController());
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
      body: Padding(
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
                    } else if (lead.queryMessageModel[index].type == 'AUDIO') {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(247, 247, 247, 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                color: Colors.grey,
                              ),
                              Container(
                                height: 6,
                                width: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              Container(
                                height: 2,
                                width: 250,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (lead.queryMessageModel[index].type == 'VIDEO') {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: VideoPlayerWidget(
                                videoUrl: lead.queryMessageModel[index].content,
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
              const SinglePageBottomBar()
            ]
          ],
        ),
      ),
    );
  }
}

class BottomChatWidget extends StatefulWidget {
  const BottomChatWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomChatWidget> createState() => _BottomChatWidgetState();
}

class _BottomChatWidgetState extends State<BottomChatWidget> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic permission not allowed!');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  void sendTextMessage() async {
    if (isShowSendButton) {
      // ref.read(chatControllerProvider).sendTextMessage(
      //       context,
      //       _messageController.text.trim(),
      //       widget.recieverUserId,
      //       widget.isGroupChat,
      //     );
      setState(() {
        _messageController.text = '';
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInit) {
        return;
      }
      if (isRecording) {
        await _soundRecorder!.stopRecorder();

        print("This is inside the audio recording");
        print(File(path));
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: path,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    // ref.read(chatControllerProvider).sendFileMessage(
    //       context,
    //       file,
    //       widget.recieverUserId,
    //       messageEnum,
    //       widget.isGroupChat,
    //     );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [    isRecording
              ? Column(
                children: const [
                  Icon(
                    Icons.mic,color: Colors.grey,
                  ),
                  Text("0:0")
                ],
              )
              : 
          IconButton(
            onPressed: selectImage,
            icon: const Icon(
              Icons.add,
              color: Colors.grey,
              size: 32,
            ),
          ),
          isRecording
              ? const Text("Recording...")
              : Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Write your message",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        isDense: true),
                    controller: _messageController,
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      } else {
                        setState(() {
                          isShowSendButton = false;
                        });
                      }
                    },
                  ),
                ),
          isRecording
              ? const SizedBox()
              : IconButton(
                  onPressed: selectVideo,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 8,
              right: 2,
              left: 2,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 25,
              child: GestureDetector(
                onTap: sendTextMessage,
                child: Icon(
                  isShowSendButton
                      ? Icons.send
                      : isRecording
                          ? Icons.close
                          : Icons.mic,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SinglePageBottomBar extends StatelessWidget {
  const SinglePageBottomBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Container(
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(6)),
                child: const Center(
                  child: Text(
                    "Not Interested",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
          )
        ],
      ),
    );
  }
}
