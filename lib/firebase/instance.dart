import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'object/exam.dart';

class Instance extends GetxController {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userInfo;
  List<Exam> exams = [];

  Future<void> getUserInfo() async {
    userInfo = (await firestore
            .collection('profile')
            .doc(firebaseAuth.currentUser?.email)
            .get())
        .data();
    userInfo?['email'] = firebaseAuth.currentUser!.email;
    update();
  }
}
