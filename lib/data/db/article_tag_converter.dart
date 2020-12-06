import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/utils/log_util.dart';

class ArticleTagConverter extends TypeConverter<List<Tags>, String> {
  @override
  List<Tags> decode(String databaseValue) {
    List list = json.decode(databaseValue);
    List<Tags> tags = new List();
    list.map((value) {
      tags.add(Tags.fromJson(value));
    });
    LogUtil.v('ArticleTagConverter decode $list');
    return tags;
  }

  @override
  String encode(List<Tags> value) {
    String v = json.encode(value);
    LogUtil.v('ArticleTagConverter encode $v');
    return v;
  }
}
