import 'article_dao.dart';
import 'database.dart';

class DatabaseSingleton {
  WanAndroidDatabase database;

  DatabaseSingleton._privateConstructor() {
    var db = $FloorWanAndroidDatabase
        .databaseBuilder('wan_android_database.db')
        .build();
    db.then((value) {
      this.database = value;
    });
  }

  ArticleDao getArticleDao() => database.articleDao;

  static final DatabaseSingleton instance =
      DatabaseSingleton._privateConstructor();

  factory DatabaseSingleton() {
    return instance;
  }
}
