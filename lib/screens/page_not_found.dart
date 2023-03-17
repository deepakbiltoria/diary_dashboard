import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Center(
            child: Text(
              ' 404 ',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'page not found',
            style: Theme.of(context).textTheme.headline3,
          )
        ],
      ),
    );
  }
}
