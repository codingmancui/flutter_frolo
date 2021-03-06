class WanAndroidApi {
  /// 首页banner http://www.wanandroid.com/banner/json
  static const String BANNER = "banner";

  /// 最新项目tab (首页的第二个tab) http://wanandroid.com/article/listproject/0/json
  static const String ARTICLE_LISTPROJECT = "article/listproject";

  /// 项目分类 http://www.wanandroid.com/project/tree/json
  static const String PROJECT_TREE = "project/tree";

  /// 项目列表数据 http://www.wanandroid.com/project/list/1/json?cid=294
  static const String PROJECT_LIST = "project/list";

  /// 体系数据 http://www.wanandroid.com/tree/json
  static const String TREE = "tree";

  /// 导航数据 https://www.wanandroid.com/navi/json
  static const String NAVI = "navi";

  //https://www.wanandroid.com//hotkey/json
  static const String HOT_KEY = "hotkey";

  /// 首页文章列表 http://www.wanandroid.com/article/list/0/json
  /// 知识体系下的文章 http://www.wanandroid.com/article/list/0/json?cid=60
  static const String ARTICLE_LIST = "article/list";

  /// 首页置顶 http://www.wanandroid.com/article/top/json
  static const String TOP_LISt = "article/top";

  /// 搜索 https://www.wanandroid.com/article/query/0/json?k=我的
  static const String SEARCH_LIST = "article/query";

  /// 获取公众号列表 http://wanandroid.com/wxarticle/chapters/json
  static const String WXARTICLE_CHAPTERS = "wxarticle/chapters";

  /// 查看某个公众号历史数据 http://wanandroid.com/wxarticle/list/405/1/json
  /// 在某个公众号中搜索历史文章 http://wanandroid.com/wxarticle/list/405/1/json?k=Java
  static const String WXARTICLE_LIST = "wxarticle/list";

  static const String USER_REGISTER = "user/register"; //注册
  static const String USER_LOGIN = "user/login"; //登录
  static const String USER_LOGOUT = "user/logout"; //退出

  static const String LG_COIN_USERINFO = "lg/coin/userinfo"; //个人积分
  static const String LG_COIN_LIST = "lg/coin/list"; //个人积分列表
  static const String LG_COLLECT_LIST = "lg/collect/list"; //收藏文章列表
  static const String LG_COLLECT = "lg/collect"; //收藏站内文章
  static const String LG_UNCOLLECT_ORIGINID = "lg/uncollect_originId"; //取消收藏

  static String getPath({String path: '', int page, String resType: 'json'}) {
    StringBuffer sb = new StringBuffer(path);
    if (page != null) {
      sb.write('/$page');
    }
    if (resType != null && resType.isNotEmpty) {
      sb.write('/$resType');
    }
    return sb.toString();
  }
}
