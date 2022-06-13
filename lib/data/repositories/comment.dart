import "/data/export.dart";
import "/constants/export.dart";

import '../export.dart';

class CommentRepository extends CRUDGeneric<Comment> with SequrityBase {
  
  @override
  String get endpoint => "video/comment";

}
