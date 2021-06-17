import 'package:flutter/material.dart';

class Cuser {
  final String id;
  final String userId;
  final String email;
  final int mobile;
   var plan;
  Cuser(
      {@required this.id,
      @required this.userId,
      @required this.email,
      @required this.mobile,
      @required this.plan});
}