import 'package:flutter/material.dart';
class menuItem extends StatelessWidget {
  String itemTitle;
  Icon itemIcon;
  Function route;

  menuItem(this.itemTitle, this.itemIcon, this.route);

  @override
  Widget build(BuildContext context) {
    return
      ListTile(
          title: Text(itemTitle),
          leading: itemIcon,
          trailing: Icon(Icons.arrow_right),
          onTap: () {
            this.route(context);
          },
      );
  }

}
