import 'package:flutter/material.dart';

import 'package:leads/models/dialog_model.dart';

class ReportDialog extends StatefulWidget {
  const ReportDialog({
    Key? key,
    required this.reports,
  }) : super(key: key);

  final List<DialogModel> reports;

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
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
              "Report",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const Text(
              "Tell us if you have received inappropriate message, lead or spam content.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.maxFinite,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.reports.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelected = true;
                          selectedItem = widget.reports[index].message;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.reports[index].message,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                          const Divider(
                            thickness: 2,
                          )
                        ],
                      ),
                    );
                  }),
            ),
            const Text("Others",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
