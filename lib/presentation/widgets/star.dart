import 'package:flutter/material.dart';

class StarWidget extends StatefulWidget {
  @override
  _StarWidgetState createState() => _StarWidgetState();
}

class _StarWidgetState extends State<StarWidget> {
  bool _isSolid = false;

  void _toggleStar() {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content:
              Text('You have ${_isSolid ? 'joined' : 'left'} this channel'),
        ),
      );
    setState(() {
      _isSolid = !_isSolid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleStar,
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: Text(
          _isSolid ? 'Join' : 'Leave',
        ),
      ),
    );
  }
}
