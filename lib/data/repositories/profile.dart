import '../export.dart';

class ProfileRepository extends CRUDGeneric<Profile> with SequrityBase, ReportRepository {
  
  @override
  String get endpoint => "account/channel";

}
