import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talkaholic/models/chat.dart';
import 'package:talkaholic/models/message.dart';
import 'package:talkaholic/models/user_profile.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:talkaholic/utils.dart';

class DatabaseServices {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  late AuthService _authService;
 

  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;

  DatabaseServices() {
    _authService = _getIt.get<AuthService>();

    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshots, _) => UserProfile.fromJson(
                snapshots.data()!,
              ),
              toFirestore: (UserProfile, _) => UserProfile.toJson(),
            );

    _chatCollection =
        _firebaseFirestore.collection('chats').withConverter<Chat>(
              fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
              toFirestore: (chat, _) => chat.toJson(),
            );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserProfiles() {
    return _usersCollection
        ?.where("uid", isNotEqualTo: _authService.user!.uid)
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateCharId(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateCharId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatID);
    final chat = Chat(
      id: chatID,
      participants: [uid1, uid2], 
      messages: [],
      );
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
    String uid1, String uid2, Message message) async {
      String chatID = generateCharId(uid1: uid1, uid2: uid2);
      final docRef = _chatCollection!.doc(chatID);
      await docRef.update(
        {
        "messages": FieldValue.arrayUnion(
          [
           message.toJson(),
        ]
      ),
    },
    );
    }

  Stream<DocumentSnapshot<Chat>> getChatDdata(String uid1, String uid2){
      String chatID = generateCharId(uid1: uid1, uid2: uid2);
      return _chatCollection?.doc(chatID).snapshots() 
      as Stream<DocumentSnapshot<Chat>>;
    }

  }


