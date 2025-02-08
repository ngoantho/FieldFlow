import 'package:field_flow/homepage/check_in_out_button_state.dart';
import 'package:flutter/material.dart';

class CheckInOutButton extends StatefulWidget {
  const CheckInOutButton({
    super.key,
    rawPositions = const []
  });

  @override
  State<CheckInOutButton> createState() => CheckInOutButtonState();
}
