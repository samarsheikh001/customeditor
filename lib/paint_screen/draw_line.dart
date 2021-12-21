import 'package:flutter/material.dart';

class DrawnLine {
  final List<Offset> path;
  final Color color;
  final double width;

  DrawnLine(this.path, this.color, this.width);

  DrawnLine.fromJson(Map<String, dynamic> json)
      : path = json['path'],
        color = json['color'],
        width = json['width'];

  Map<String, dynamic> toJson() {
    List<List<double>> _tempList = [];
    for (var i in path) {
      _tempList.add([i.dx, i.dy]);
    }
    return {
      'path': _tempList,
      'color': color,
      'width': width,
    };
  }
}
