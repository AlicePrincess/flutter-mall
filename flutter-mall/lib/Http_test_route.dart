import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './adapt.dart';
import './mall/list/card.dart';
import './mall/list/sceneList.dart';
import './mall/list/top.dart';

class HttpTestRoute<T extends Notification> extends StatefulWidget {
  @override
  _HttpTestRouteState createState() => _HttpTestRouteState();
}

class _HttpTestRouteState extends State<HttpTestRoute> {
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool _loading = false;
  String _text = "";
  List resRightList = [];
  List resLeftList = [];
  List sceneList = [];
  int topSelect = 0;
  int count = 0;
  int currentPage = 1;
  int pageSize = 20;
  @override
  void initState() {
    super.initState();
    getMallList();
    getItemScene();
    scrollCtr();
  }

  @override
  void dispose() {
    // 组件销毁时，释放资源
    super.dispose();
    this.scrollController.dispose();
  }

  scrollCtr() {
    this.scrollController.addListener(() {
      // 滑动到底部的判断
      if (!this.isLoading &&
          this.scrollController.position.pixels >=
              this.scrollController.position.maxScrollExtent) {
        print("到底了");
        // 开始加载数据
        setState(() {
          this.isLoading = true;
          loadMoreData(); //加载数据
        });
      }
    });
  }

  loadMoreData() {
    currentPage += 1;
    getMallList();
  }

  getMallList() async {
    print("------------getMallList--------------");
    try {
// ,"where":topSelect==0?{"scene": [{"id": 3}]}:topSelect==1?{"cat_id": 2}:{"style_id":1}
      Map reg = {
        "offset_head": (currentPage - 1) * pageSize,
        "offset_tail": currentPage * pageSize
      };
      if (sceneList.length > 0 && !sceneList[0]["select"]) {
        Map leftSelect = {};
        sceneList.asMap().forEach((i, item) {
          if (item["select"]) {
            leftSelect = item;
          }
        });
        reg["where"] = topSelect == 0
            ? {
                "scene": [
                  {"id": leftSelect["id"]}
                ]
              }
            : topSelect == 1
                ? {"cat_id": leftSelect["id"]}
                : {"style_id": leftSelect["id"]};
      }
      var response = await Dio().post(
          'https://lclg.d.hersjade.cn/crius/v1/mall/item/list_sorted',
          data: reg);
      List resLeftListTemp = resLeftList;
      List resRightListTemp = resRightList;
      response.data["page_data"].asMap().forEach((i, item) {
        if (i % 2 == 1) {
          resLeftListTemp.add(item);
        } else {
          resRightListTemp.add(item);
        }
      });
      setState(() {
        resLeftList = resLeftListTemp;
        resRightList = resRightListTemp;
        count = response.data["count"];
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  getItemScene() async {
    String url = topSelect == 0
        ? "/item_scene/list"
        : topSelect == 1
            ? '/item_category/root'
            : '/item_style/list';
    try {
      var sceneResponse =
          await Dio().get('https://lclg.d.hersjade.cn/crius/v1/mall' + url);
      List sceneListTemp = [
        {"select": true, "scenario_name": "全部"}
      ];
      print(url);
      print(sceneResponse.data);
      sceneResponse.data.asMap().forEach((i, item) {
        print(item["name"]);
        item["select"] = false;
        if (topSelect != 0) {
          item["scenario_name"] = item["name"];
        }
        sceneListTemp.add(item);
      });

      setState(() {
        sceneList = sceneListTemp;
      });
    } catch (e) {
      print(e);
    } finally {}
  }

  void changeTopType(index) {
    currentPage = 1;
    pageSize = 20;
    resRightList = [];
    resLeftList = [];
    sceneList = [];
    getMallList();
    topSelect = index;
    getItemScene();
    setState(() {
      topSelect = index; //修改状态
    });
  }

  void changeLeftType(product) {
    List sceneListTemp = sceneList;
    sceneListTemp.asMap().forEach((i, item) {
      item["select"] = false;
      if (product["scenario_name"] == "全部" && i == 0) {
        item["select"] = true;
      } else if (product["id"] == item["id"]) {
        item["select"] = true;
      }
    });
    currentPage = 1;
    pageSize = 20;
    resRightList = [];
    resLeftList = [];
    getMallList();
    setState(() {
      sceneList = sceneListTemp; //修改状态
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 46,
            title: Text("翠佛堂商城"),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            titleTextStyle: TextStyle(
                fontSize: Adapt.px(30.0), color: Color.fromRGBO(27, 27, 27, 1)),
            centerTitle: true),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MallListTopWidget(
                  topSelect: topSelect, changeTopType: changeTopType),
              Container(
                  color: Color.fromRGBO(237, 237, 237, 1),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Adapt.px(162.0),
                        height: MediaQuery.of(context).size.height -
                            Adapt.px(250.0),
                        color: Colors.white,
                        child: ListView.builder(
                          itemCount: sceneList.length,
                          itemBuilder: (BuildContext context, int index1) {
                            return MallSceneListWidget(
                                product: sceneList[index1],
                                changeLeftType: changeLeftType);
                          },
                        ),
                      ),
                      resLeftList.length == 0
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width -
                                  Adapt.px(162.0),
                              height: MediaQuery.of(context).size.height -
                                  Adapt.px(250.0),
                              child: NotificationListener(
                                child: ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount: resLeftList.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index < resLeftList.length) {
                                      return Row(
                                        children: [
                                          new MallListCardWidget(
                                              product: resLeftList[index]),
                                          new MallListCardWidget(
                                              product: resRightList[index]),
                                        ],
                                      );
                                    } else {
                                      return this.renderBottom();
                                    }
                                  },
                                ),
                              ))
                    ],
                  )),
            ],
          ),
        ));
  }

  Widget renderBottom() {
    if (this.isLoading) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '努力加载中...',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF111111),
              ),
            ),
            Padding(padding: EdgeInsets.only(left: 15)),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        child: Text(
          '上拉加载更多',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF111111),
          ),
        ),
      );
    }
  }
}
