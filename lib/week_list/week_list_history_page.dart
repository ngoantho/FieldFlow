import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/mixins/build_app_bar.dart';
import 'package:field_flow/week_list/choose_worker_page.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeekListHistoryPage extends StatelessWidget with BuildAppBar {
  final String userId;
  final String userRole;
  const WeekListHistoryPage({super.key,
    required this.userId,
    required this.userRole,});

  // Future<String> _getUserRole() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //
  //   DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .get();
  //   return userDoc['role'];
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Week Report'),
              centerTitle: true,
            ),
            body: userRole == 'Manager'
                ? ChooseWorkerPage() // Manager sees worker selection
                : WeekList(id: userId), // Field Worker sees their week list
          );
        }
  }

