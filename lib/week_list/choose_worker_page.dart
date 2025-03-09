import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db/firestore_helper.dart';
import '../report/report_choose_parameter_page.dart';

class ChooseWorkerPage extends StatelessWidget {
  const ChooseWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreHelper = Provider.of<FirestoreHelper>(context, listen: false);

    return Scaffold(
        floatingActionButton: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReportChooseParameterPage()));
            },
            child: Text("Make Report")),
        body: FutureBuilder(future: firestoreHelper.fetchUsers(), builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data;

          return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: _ChooseWorkerItem(users[index])),

          );
        }));
  }
}

class _ChooseWorkerItem extends StatelessWidget {
  final Map<String, dynamic> user;

  const _ChooseWorkerItem(this.user);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
                appBar: AppBar(
                  title: Text(user['name']),
                  centerTitle: true,
                ),
                body: WeekList(id: user['id']));
          }));
        },
        child: Text(user['name']));
  }
}
