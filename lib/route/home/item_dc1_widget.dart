import 'package:dc1clientflutter/bean/dc1.dart';
import 'package:dc1clientflutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'home_route.dart';

class Dc1ItemWidget extends StatefulWidget {
  final Dc1 _dc1;

  Dc1ItemWidget(this._dc1) : super(key: ValueKey(_dc1.id));

  @override
  _Dc1ItemWidgetState createState() => _Dc1ItemWidgetState();
}

class _Dc1ItemWidgetState extends State<Dc1ItemWidget> {
  @override
  Widget build(BuildContext context) {
    var dc1 = widget._dc1;
    var primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                dc1.names == null || dc1.names.isEmpty
                    ? dc1.id.substring(dc1.id.length - 4, dc1.id.length)
                    : dc1.names[0],
                style: TextStyle(fontSize: 16, color: primaryColor),
              ),
              GestureDetector(
                child: Icon(
                  Icons.edit,
                  color: primaryColor,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      MyRoute.EDIT_DEVICE_NAME_ROUTE,
                      arguments: dc1);
                },
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              "img/pic_dc1.png",
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Text("电压：${dc1.v}   电流：${dc1.i}   功率：${dc1.p}"),
          Text("从${formatTime()}至今用电量为${dc1.totalPower / 1000}kwh"),
          buildSwitch(0),
          buildSwitch(1),
          buildSwitch(2),
          buildSwitch(3),
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {},
                  textColor: primaryColor,
                  child: Text(
                    "计划",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FlatButton(
                  onPressed: () {},
                  textColor: primaryColor,
                  child: Text(
                    "倒计时",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Row buildSwitch(int pos) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Text("${pos + 1}. ${widget._dc1.names[pos + 1]}"),
        ),
        Switch(
            activeColor: Theme.of(context).primaryColor,
            value: widget._dc1.status.split("")[pos] == "1",
            onChanged: (value) {
              var replaceRange = widget._dc1.status
                  .replaceRange(pos, pos + 1, value ? "1" : "0");
              setState(() {
                widget._dc1.status = replaceRange;
              });
              Provider.of<DeviceListModel>(context, listen: false)
                  .setDeviceStatus(widget._dc1.id, widget._dc1.status);
            }),
      ],
    );
  }

  formatTime() {
    var dateTime =
        DateTime.fromMillisecondsSinceEpoch(widget._dc1.powerStartTime);
    return "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
  }
}
