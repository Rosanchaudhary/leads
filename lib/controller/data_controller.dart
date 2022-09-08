import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:leads/models/lead_model.dart';

class DataController extends GetxController {
  List<LeadModel>? lead;
  var isDataLoading = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    readJson(Filters.All);
  }

  readJson(Filters filters) async {
    isDataLoading(true);
    final String response = await rootBundle.loadString('assets/leads.json');
    final data = await json.decode(response.toString()) as List;
    final leads = data.map((d) => LeadModel.fromJson(d)).toList();

    switch (filters) {
      case Filters.All:
        lead = leads;
        break;
      case Filters.Rescent:
        lead = leads
            .where((data) =>
                DateTime.parse(data.datetime).year ==
                DateTime.parse(DateTime.now().toString()).year &&
                DateTime.parse(data.datetime).month ==
                DateTime.parse(DateTime.now().toString()).month &&
                DateTime.parse(data.datetime).day ==
                DateTime.parse(DateTime.now().toString()).day)
            .toList();
        break;
      case Filters.Accepted:
        lead = leads.where((data) => data.queryModel.status == 'ACCEPTED').toList();
        break;
      case Filters.Other:
        lead = leads;
        break;
      default:
    }

    isDataLoading(false);
  }
}
