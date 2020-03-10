import 'package:flutter/material.dart';

class MainMenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;

  const MainMenuButton({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 105,
      margin: EdgeInsets.only(right: 12.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(12.0)),
        color: Colors.grey[200],
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.black54,
              ),
              Text(title,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
