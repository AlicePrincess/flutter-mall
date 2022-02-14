import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import './../../adapt.dart';

class MallListCardWidget extends StatefulWidget {
  const MallListCardWidget({Key? key, required this.product}) : super(key: key);
  final Map product;
  @override
  _MallListCardWidgetState createState() => _MallListCardWidgetState();
}

class _MallListCardWidgetState extends State<MallListCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adapt.px(270.0),
      height: Adapt.px(498.0),
      margin: EdgeInsets.only(
          left: Adapt.px(10.0), right: Adapt.px(6.0), top: Adapt.px(20)),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Adapt.px(10.0))),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            widget.product["banners"][0]["url"],
            fit: BoxFit.cover,
            width: Adapt.px(270.0),
            height: Adapt.px(360.0),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(20.0)),
            child: Text(widget.product["name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: Adapt.px(28.0),
                    color: Color.fromRGBO(27, 27, 27, 1))),
          ),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(10.0)),
            child: Text("￥${widget.product["sell_specs"][0]["sell_price"]}",
                style: TextStyle(
                    fontSize: Adapt.px(28.0),
                    color: Color.fromRGBO(234, 24, 60, 1))),
          )
        ],
      ),
    );
  }
}
