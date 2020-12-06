import 'package:floor/floor.dart';
import 'package:frolo/data/protocol/models.dart';

@dao
abstract class ArticleDao{
  @Query('SELECT * FROM HISTORY')
  Future<List<Article>> findAllArticles();

  @insert
  Future<void> insertArticle(Article article);
}