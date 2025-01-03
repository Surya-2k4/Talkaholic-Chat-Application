import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user {
    return _user;
  }


  AuthService(){
    _firebaseAuth.authStateChanges().listen(authStateChangesstreamListener);
  }
  

  Future<bool> login(String email, String Password) async{
    try{
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password : Password);

      if(credential.user != null){
        _user = credential.user;
        return true;
      }

    _firestore.collection('users').doc(credential.user!.uid).set({
        'uid' : credential.user!.uid,
        'email' : email,
    },SetOptions(merge: true));
 
  
    }catch(e){
      print(e);
    }
    return false;
  }

  Future<bool> signup(String email,String password)async{
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(credential.user != null){
        _user = credential.user;
           _firestore.collection('users').doc(credential.user!.uid).set({
        'uid' : credential.user!.uid,
        'email' : email,
    });
 
        return true;
      }

       
    } catch (e) {
      print(e);
    }
    return false;
  }



  Future<bool> logout()async{
    try{
        await _firebaseAuth.signOut();
        return true;
    }catch(e){
      print(e);
    }
    return false;
  }

  void authStateChangesstreamListener(User? user){
      if(user != null){
        _user = user;
      }else{
        _user = null;
      }
  }
}

