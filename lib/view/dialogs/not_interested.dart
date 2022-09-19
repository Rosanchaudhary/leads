import 'package:flutter/material.dart';

import 'package:leads/models/dialog_model.dart';

class NotInterestdDialog extends StatefulWidget {
  const NotInterestdDialog({
    Key? key,
    required this.notInterested,
  }) : super(key: key);

  final List<DialogModel> notInterested;

  @override
  State<NotInterestdDialog> createState() => _NotInterestdDialogState();
}

class _NotInterestdDialogState extends State<NotInterestdDialog> {
  bool isSelected = false;
  String selectedItem = '';
  final TextEditingController _messgeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 1),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close))
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Not Interested",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const Text(
              "Tell us why are you not interested?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.maxFinite,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.notInterested.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = true;
                          selectedItem = widget.notInterested[index].message;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.notInterested[index].message,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          const Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    );
                  }),
            ),
            const Text("Others",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            TextField(
              controller: _messgeController,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: ((value) {
                if (value.isNotEmpty) {
                  setState(() {
                    isSelected = true;
                  });
                } else {
                  setState(() {
                    isSelected = false;
                  });
                }
                setState(() {
                  selectedItem = value;
                });
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    //send to the backend
                    /// print(selectedItem);
                  },
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.grey,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
