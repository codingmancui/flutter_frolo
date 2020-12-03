import 'package:floor/floor.dart';
import 'package:frolo/data/db/article_dao.dart';
import 'package:frolo/data/protocol/models.dart';

@Database(version: 1, entities: [Article])
abstract class WanAndroidDatabase extends FloorDatabase{
  ArticleDao get articleDao;
}