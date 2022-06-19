import '../export.dart';

class ProfileRepository extends CRUDGeneric<Profile> with SequrityBase, ReportRepository {
  
  Future subscribe(String id) async {
    await post(url: "$id/subscribe/");
  }

  @override
  String get endpoint => "account/channel";

}
