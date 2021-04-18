import 'package:flutter/material.dart';

class User {
  final String id;
  final String userId;
  final String email;
  final int mobile;
  final String type;
  User(
      {@required this.id,
      @required this.userId,
      @required this.email,
      @required this.mobile,
      @required this.type});
}