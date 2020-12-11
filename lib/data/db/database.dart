import 'dart:async';

// required package imports
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:frolo/data/db/article_dao.dart';
import 'package:frolo/data/protocol/models.dart';

import 'article_tag_converter.dart';
part 'database.g.dart'; // the generated code will be there

@TypeConverters([ArticleTagConverter])
@Database(version: 1, entities: [Article])
abstract class WanAndroidDatabase extends FloorDatabase{
  ArticleDao get articleDao;
}