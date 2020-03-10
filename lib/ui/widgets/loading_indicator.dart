import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
    );
  }
}
