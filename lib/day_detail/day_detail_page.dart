import 'package:field_flow/model/day_model.dart';
import 'package:flutter/material.dart';

import 'day_detail.dart';

class DayDetailPage extends StatelessWidget {
  final DayModel dayModel;
  const DayDetailPage({super.key, required this.dayModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DayDetail(dayModel: dayModel),
          ],
        ),
      ),
    );
  }
}
