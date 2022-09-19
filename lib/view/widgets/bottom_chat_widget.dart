import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:leads/controller/commons/enums.dart';
import 'package:leads/controller/commons/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


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
        children: [
          isRecording
              ? Row(
                  children: const [
                    Icon(
                      Icons.mic,
                      color: Colors.grey,
                    ),
                    Text("0:0")
                  ],
                )
              : IconButton(
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
