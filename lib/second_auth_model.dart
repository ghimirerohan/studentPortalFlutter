import 'package:flutter/material.dart';

class second_auth_model {
late String token;

second_auth_model({required String token})
{this.token = token;
}

second_auth_model.fromJson(Map<String, dynamic> json) {
token = json['token'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['token'] = this.token;
  return data;
}
}