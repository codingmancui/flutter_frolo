class DatabaseSingleton{

  DatabaseSingleton._privateConstructor(){
    // await $FloorAppDatabase.databaseBuilder('wan_android_database.db').build();
  }

  static final DatabaseSingleton _instance = DatabaseSingleton._privateConstructor();

  factory DatabaseSingleton(){
    return _instance;
  }

}