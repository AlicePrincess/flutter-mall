import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import './../../adapt.dart';

class MallListTopWidget extends StatefulWidget {
  const MallListTopWidget(
      {Key? key, required this.topSelect, required this.changeTopType})
      : super(key: key);
  final ValueChanged changeTopType;
  final int topSelect;

  @override
  _MallListTopWidgetState createState() => _MallListTopWidgetState();
}

class _MallListTopWidgetState extends State<MallListTopWidget> {
  List topList = ["场景", "类别", "款式"];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Adapt.px(72.0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: topList.asMap().keys.map((i) {
          return GestureDetector(
            onTap: () {
              //调用回调函数传值
              widget.changeTopType(i);
            },
            child: Container(
                decoration: new BoxDecoration(
                  color: widget.topSelect == i
                      ? Color.fromRGBO(234, 24, 60, 1)
                      : Color.fromRGBO(255, 255, 255, 1),
                  borderRadius:
                      BorderRadius.all(Radius.circular(Adapt.px(20.0))),
                ),
                width: Adapt.px(140.0),
                height: Adapt.px(40.0),
                child: Center(
                  child: Text(
                    topList[i],
                    style: TextStyle(
                        fontSize: Adapt.px(26.0),
                        color: widget.topSelect == i
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 0, 0, 1)),
                  ),
                )),
          );
        }).toList(),
      ),
    );
  }
}
