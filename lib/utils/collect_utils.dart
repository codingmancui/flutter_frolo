import 'package:frolo/data/repository/collect_repository.dart';

typedef Call = void Function(bool success);

class CollectUtils {
  static void doCollect(int id, Call call) {
    CollectRepository collectRepository = new CollectRepository();
    collectRepository.collect(id).then((bool success) {
      call(success);
    }).catchError(() {
      call(false);
    });
  }

  static void unCollect(int id, Call call) {
    CollectRepository collectRepository = new CollectRepository();
    collectRepository.unCollect(id).then((bool success) {
      call(success);
    }).catchError(() {
      call(false);
    });
  }
}
