import 'package:floor/floor.dart';
import 'package:frolo/data/protocol/models.dart';

@dao
abstract class ArticleDao{
  @Query('SELECT * FROM history order by lastTime desc limit 50')
  Future<List<Article>> findAllArticles();

  @insert
  Future<void> insertArticle(Article article);
}