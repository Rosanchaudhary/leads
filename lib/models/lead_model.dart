// ignore_for_file: constant_identifier_names

class LeadModel {
  final int id;
  final String datetime;
  final String status;
  final QueryModel queryModel;
  final List<QueryMessageModel> queryMessageModel;

  const LeadModel(
      {required this.id,
      required this.datetime,
          required this.status,
      required this.queryModel,
      required this.queryMessageModel});
  factory LeadModel.fromJson(Map<String, dynamic> json) {
    var queryMessageJson = json['query_messages'] as List;
    List<QueryMessageModel> queryMessage = queryMessageJson
        .map((message) => QueryMessageModel.fromJson(message))
        .toList();
    return LeadModel(
        id: json['id'],
        datetime: json['datetime'],
        status: json['status'],
        queryModel: QueryModel.fromJson(json['query']),
        queryMessageModel: queryMessage);
  }
}

class QueryModel {
  final int id;
  final String datetime;
  final String from;
  final String category;
  final String type;
  final String status;
  QueryModel({
    required this.id,
    required this.datetime,
    required this.from,
    required this.category,
    required this.type,
    required this.status,
  });
  factory QueryModel.fromJson(Map<String, dynamic> json) {
    return QueryModel(
        id: json['id'],
        datetime: json['datetime'],
        from: json['from'],
        category: json['category'],
        type: json['type'],
        status: json['status']);
  }
}

class QueryMessageModel {
  final int id;
  final int queryId;
  final String type;
  final String content;
  QueryMessageModel({
    required this.id,
    required this.queryId,
    required this.type,
    required this.content,
  });

  factory QueryMessageModel.fromJson(Map<String, dynamic> json) {
    return QueryMessageModel(
        id: json['id'],
        queryId: json['query_id'],
        type: json['type'],
        content: json['content']);
  }
}

enum Filters { All, Rescent, Accepted, Other }
