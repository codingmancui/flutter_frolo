import 'database.dart';

class DatabaseSingleton {
  Future<WanAndroidDatabase> database;

  DatabaseSingleton._privateConstructor() {
    database = $FloorWanAndroidDatabase
        .databaseBuilder('wan_android_database.db')
        .build();
  }

  static final DatabaseSingleton instance =
      DatabaseSingleton._privateConstructor();

  factory DatabaseSingleton() {
    return instance;
  }
}
