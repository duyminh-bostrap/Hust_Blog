import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey, blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': 'Hottest', 'iconPath': 'images/cat.png'},
  {'name': 'Top Rateds', 'iconPath': 'images/dog.png'},
  {'name': 'Teen', 'iconPath': 'images/rabbit.png'},
  {'name': 'Travel', 'iconPath': 'images/parrot.png'},
  {'name': 'Spot', 'iconPath': 'images/horse.png'}
];

List<Map> drawerItems=[
  {
    'icon': Icons.local_fire_department,
    'title' : 'Hottest'
  },
  {
    'icon': Icons.trending_up,
    'title' : 'Top Rated'
  },
  {
    'icon': Icons.sports_handball,
    'title' : 'Teen'
  },
  {
    'icon': Icons.local_airport,
    'title' : 'Travel'
  },
  {
    'icon': Icons.sports_basketball,
    'title' : 'Spot'
  },
  {
    'icon': FontAwesomeIcons.userAlt,
    'title' : 'Profile'
  },
];