import 'package:flutter/material.dart';

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  blue('Blue', Colors.blue),
  indigo('Indigo', Colors.indigo),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink Accent', Colors.pinkAccent),
  red('Red', Colors.red),
  purple('Purple', Colors.purple),
  lightBlue('Light Blue', Colors.lightBlue);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}
