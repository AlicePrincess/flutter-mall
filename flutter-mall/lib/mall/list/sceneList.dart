import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import './../../adapt.dart';

class MallSceneListWidget extends StatefulWidget {
  const MallSceneListWidget(
      {Key? key, required this.product, required this.changeLeftType})
      : super(key: key);
  final Map product;
  final changeLeftType;
  @override
  _MallSceneListWidgetState createState() => _MallSceneListWidgetState();
}

class _MallSceneListWidgetState extends State<MallSceneListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Adapt.px(162.0),
        height: Adapt.px(107.0),
        color: Colors.white,
        child: GestureDetector(
            onTap: () {
              //调用回调函数传值
              widget.changeLeftType(widget.product);
            },
            child: Row(
              children: [
                Container(
                    width: Adapt.px(6.0),
                    height: Adapt.px(48.0),
                    color: widget.product["select"]
                        ? Color.fromRGBO(234, 24, 60, 1)
                        : Color.fromRGBO(255, 255, 255, 1)),
                Container(
                  width: Adapt.px(156.0),
                  child: Center(
                    child: Text(widget.product["scenario_name"],
                        style: TextStyle(
                            fontSize: Adapt.px(28.0),
                            color: widget.product["select"]
                                ? Color.fromRGBO(234, 24, 60, 1)
                                : Color.fromRGBO(27, 27, 27, 1))),
                  ),
                ),
              ],
            )));
  }
}
