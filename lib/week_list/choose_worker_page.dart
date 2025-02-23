import 'package:field_flow/week_list/week_list.dart';
import 'package:flutter/material.dart';

class ChooseWorkerPage extends StatelessWidget {
  const ChooseWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: _ChooseWorkerItem(index + 1),
      ),
      itemCount: 7,
    );
  }
}

class _ChooseWorkerItem extends StatelessWidget {
  final int _index;

  const _ChooseWorkerItem(this._index, {super.key});

  String get index => _index.toString();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Worker (ID: $index)'),
                  centerTitle: true,
                ),
                body: WeekList(id: index));
          }));
        },
        child: Text(index));
  }
}
