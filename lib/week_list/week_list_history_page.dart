import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeekListHistoryPage extends StatelessWidget with BuildAppBar {

  const WeekListHistoryPage({super.key});

  Future<String> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    return userDoc['role'];
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>
      (future: _getUserRole(),
        builder: (context, snapshot){
          return Scaffold(
            appBar: AppBar(title: Text('Week Report')),
            body: snapshot.data == 'Manager'
                ? ChooseWorkerPage()   // Manager sees worker selection
                : WeekList(id: FirebaseAuth.instance.currentUser?.uid ?? ''), // Field Worker sees their week list
          );
        });
  }
}
