import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

Future<List> getCurrencies() async {
  String apiURL = 'https://api.coinmarketcap.com/v1/ticker/?limit=50';
  http.Response resp = await http.get(apiURL);
  return json.decode(resp.body);
}
String variable = "bla bla bla eitaaa";

void main () async {
  List currencies = await getCurrencies();

  print(currencies);//print in console

  runApp(
      new MaterialApp(
        home: new CryptoListWidget(currencies)
      )
  );
}

class CryptoListWidget extends StatelessWidget {
  final List<MaterialColor> _colors = [Colors.blue, Colors.red, Colors.indigo, Colors.green, Colors.cyan, Colors.amber, Colors.blueGrey, Colors.purple];
  final List _currencies;

  CryptoListWidget(this._currencies);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: _buildBody(),
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildBody(){
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0,56.0,8.0,1.0),
      child: new Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _getAppTitleWidget(){
    return new Text(
      'Cryptocurrencies',
      style: new TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
      ),
    );
  }

  Widget _getListViewWidget() {
    return new Flexible(
        child: new ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (context, index){
            final Map currency = _currencies[index];
            final MaterialColor color =_colors[new Random().nextInt(_colors.length)];
            return _getListItemWidget(currency, color);
          },
        )
    );
  }

  Widget _getListItemWidget(Map currency, MaterialColor color) {
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: _getListTile(currency, color),
      )
    );
  }

  CircleAvatar _getLeadingWidget(String currencyName, MaterialColor color){
    return new CircleAvatar(
      backgroundColor: color,
      child: new Text(currencyName[0]+currencyName[1]),
    );
  }

  Text _getTitleWidget(String currencyName){
    return new Text(
      currencyName,
      style: new TextStyle(
          fontWeight: FontWeight.bold),
    );
  }

  Text _getSubtitleWidget(String priceUSD, String percentChange1h){
    return new Text(
      '\$$priceUSD\n1 hour: $percentChange1h%'
    );
  }

  RichText _getSubtitleText(String priceUSD, String percentChange1h){
    TextSpan priceTextWidget = new TextSpan(
      text: '\$$priceUSD\n',
      style: new TextStyle( color: Colors.black)
    );
    String percentChangeText = "1 hour: $percentChange1h%";
    TextSpan percentChangeTextWidget = new TextSpan(
        text: percentChangeText,
      style: new TextStyle(
        color: (double.parse(percentChange1h) > 0 ? _colors[0] : _colors[1] )
      )
    );

    return new RichText(text: new TextSpan(
      children: [
        priceTextWidget,
        percentChangeTextWidget
      ]
    ));
  }

  ListTile _getListTile(Map currency, MaterialColor color){
    return new ListTile(
      leading: _getLeadingWidget(currency['name'], color),
      title: _getTitleWidget(currency['name']),
      subtitle: _getSubtitleText(
          currency['price_usd'],
          currency['percent_change_1h']
      ),
      isThreeLine: true,
    );
  }




}
