// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorWanAndroidDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WanAndroidDatabaseBuilder databaseBuilder(String name) =>
      _$WanAndroidDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$WanAndroidDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$WanAndroidDatabaseBuilder(null);
}

class _$WanAndroidDatabaseBuilder {
  _$WanAndroidDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$WanAndroidDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$WanAndroidDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<WanAndroidDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$WanAndroidDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$WanAndroidDatabase extends WanAndroidDatabase {
  _$WanAndroidDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ArticleDao _articleDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `history` (`id` INTEGER, `apkLink` TEXT, `audit` INTEGER, `author` TEXT, `canEdit` INTEGER, `chapterId` INTEGER, `chapterName` TEXT, `collect` INTEGER, `courseId` INTEGER, `desc` TEXT, `descMd` TEXT, `envelopePic` TEXT, `fresh` INTEGER, `link` TEXT, `niceDate` TEXT, `niceShareDate` TEXT, `origin` TEXT, `prefix` TEXT, `projectLink` TEXT, `publishTime` INTEGER, `realSuperChapterId` INTEGER, `selfVisible` INTEGER, `shareDate` INTEGER, `shareUser` TEXT, `superChapterId` INTEGER, `superChapterName` TEXT, `tags` TEXT, `title` TEXT, `type` INTEGER, `userId` INTEGER, `visible` INTEGER, `zan` INTEGER, `lastTime` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ArticleDao get articleDao {
    return _articleDaoInstance ??= _$ArticleDao(database, changeListener);
  }
}

class _$ArticleDao extends ArticleDao {
  _$ArticleDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _articleInsertionAdapter = InsertionAdapter(
            database,
            'history',
            (Article item) => <String, dynamic>{
                  'id': item.id,
                  'apkLink': item.apkLink,
                  'audit': item.audit,
                  'author': item.author,
                  'canEdit':
                      item.canEdit == null ? null : (item.canEdit ? 1 : 0),
                  'chapterId': item.chapterId,
                  'chapterName': item.chapterName,
                  'collect':
                      item.collect == null ? null : (item.collect ? 1 : 0),
                  'courseId': item.courseId,
                  'desc': item.desc,
                  'descMd': item.descMd,
                  'envelopePic': item.envelopePic,
                  'fresh': item.fresh == null ? null : (item.fresh ? 1 : 0),
                  'link': item.link,
                  'niceDate': item.niceDate,
                  'niceShareDate': item.niceShareDate,
                  'origin': item.origin,
                  'prefix': item.prefix,
                  'projectLink': item.projectLink,
                  'publishTime': item.publishTime,
                  'realSuperChapterId': item.realSuperChapterId,
                  'selfVisible': item.selfVisible,
                  'shareDate': item.shareDate,
                  'shareUser': item.shareUser,
                  'superChapterId': item.superChapterId,
                  'superChapterName': item.superChapterName,
                  'tags': _articleTagConverter.encode(item.tags),
                  'title': item.title,
                  'type': item.type,
                  'userId': item.userId,
                  'visible': item.visible,
                  'zan': item.zan,
                  'lastTime': item.lastTime,
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Article> _articleInsertionAdapter;

  @override
  Future<List<Article>> findAllArticles() async {
    return _queryAdapter.queryList('SELECT * FROM history order by lastTime desc limit 50',
        mapper: (Map<String, dynamic> row) => Article(
              apkLink: row['apkLink'] as String,
              audit: row['audit'] as int,
              author: row['author'] as String,
              canEdit: row['canEdit'] == 1 ? true : false,
              chapterId: row['chapterId'] as int,
              chapterName: row['chapterName'] as String,
              collect: row['collect'] == 1 ? true : false,
              courseId: row['courseId'] as int,
              desc: row['desc'] as String,
              descMd: row['descMd'] as String,
              envelopePic: row['envelopePic'] as String,
              fresh: row['fresh'] == 1 ? true : false,
              id: row['id'] as int,
              link: row['link'] as String,
              niceDate: row['niceDate'] as String,
              niceShareDate: row['niceShareDate'] as String,
              origin: row['origin'] as String,
              prefix: row['prefix'] as String,
              projectLink: row['projectLink'] as String,
              publishTime: row['publishTime'] as int,
              realSuperChapterId: row['realSuperChapterId'] as int,
              selfVisible: row['selfVisible'] as int,
              shareDate: row['shareDate'] as int,
              shareUser: row['shareUser'] as String,
              superChapterId: row['superChapterId'] as int,
              superChapterName: row['superChapterName'] as String,
              tags: _articleTagConverter.decode(row['tags']),
              title: row['title'] as String,
              type: row['type'] as int,
              userId: row['userId'] as int,
              visible: row['visible'] as int,
              zan: row['zan'] as int,
              lastTime: row['lastTime'] as int,
            ));
  }

  @override
  Future<void> insertArticle(Article article) async {
    await _articleInsertionAdapter.insert(article, OnConflictStrategy.replace);
  }
}

// ignore_for_file: unused_element
final _articleTagConverter = ArticleTagConverter();
