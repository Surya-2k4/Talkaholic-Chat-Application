//video stopped at 5.55
import 'package:talkaholic/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:talkaholic/services/alert_service.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:talkaholic/services/database_services.dart';
import 'package:talkaholic/services/media_service.dart';
import 'package:talkaholic/services/navigation_service.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
    );
}

//retrive info  || register the services
Future<void> registerServices() async {
  final GetIt getit = GetIt.instance;
  getit.registerSingleton<AuthService>(
    AuthService(),
  );
   getit.registerSingleton<NavigationService>(
    NavigationService(),
  );
   getit.registerSingleton<AlertService>(
    AlertService(),
  );
    getit.registerSingleton<MediaService>(
    MediaService(),
  );
  //storage services pending

    getit.registerSingleton<DatabaseServices>(
    DatabaseServices(),
  );
}

//check for the uid of the users
String generateCharId({required String uid1, required String uid2}){
  List uids = [uid1, uid2];
  uids.sort();
  String chatID = uids.fold("",(id,uid)=>"$id$uid");
  return chatID;
}