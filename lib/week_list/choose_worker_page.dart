import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';

import '../report/report_choose_parameter_page.dart';

class ChooseWorkerPage extends StatelessWidget {
  const ChooseWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Choose a Worker"),
        ),
        body: FutureBuilder(future: (() async {
          return FirebaseFirestore.instance.collection('users').get();
        })(), builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs
              .map((e) => {...e.data(), 'id': e.id})
              .toList();

          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: _ChooseWorkerItem(users[index])),
                itemCount: users.length,
              )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReportChooseParameterPage()));
                  },
                  child: Text("Make Report"))
            ],
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
