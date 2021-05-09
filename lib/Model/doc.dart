import 'package:flutter/material.dart';

class Doc {
  final String id;
  final String userId;
  final String name;
  final String link;
  final String date;
  final String path;
  Doc(
      {@required this.id,
      @required this.userId,
      @required this.name,
      @required this.path,
      @required this.link,
      @required this.date});
}