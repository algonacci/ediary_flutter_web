import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ediary_flutter_web/model/user.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DiaryService {
  final CollectionReference userCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> loginUser(String email, String password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return;
  }

  Future<void> createUser(
      String displayName, BuildContext context, String uid) async {
    MUser user = MUser(
      avatarUrl: 'https://picsum.photos/200/300',
      displayName: displayName,
      uid: uid,
    );
    userCollectionReference.add(user.toMap());
    return;
  }

  Future<void> updateUser(MUser user, String displayName, String avatarUrl,
      BuildContext context) async {
    MUser updateUser = MUser(
      displayName: displayName,
      avatarUrl: avatarUrl,
      uid: user.uid,
    );
    userCollectionReference.doc(user.id).update(updateUser.toMap());
    return;
  }
}
