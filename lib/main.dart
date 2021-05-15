import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// const request = "https://api.hgbrasil.com/finance?format=json-cors&key=8a244f65";
const request = "https://api.hgbrasil.com/finance/stock_price?key=8a244f65&symbol=bidi4";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.red[300], primaryColor: Colors.red[300]),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final acaoController = TextEditingController();

  String acao;

  void _acaoChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    acaoController.text = (acao);
  }

  void _clearAll() {
    acaoController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("\$ Conversor de Moedas \$"),
            centerTitle: true,
            backgroundColor: Colors.red[300]),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando dados...",
                    style: TextStyle(color: Colors.red[300], fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao carregar dados...",
                      style: TextStyle(color: Colors.red[300], fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    acao = snapshot.data["results"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.table_chart_sharp,
                              size: 150.0, color: Colors.red[300]),
                          buildTextFormField(
                              "Nome da ação", "", acaoController, _acaoChange),
                          buildTextFormField(
                              "", "", acaoController, _acaoChange),
                        ],
                      ),
                    );
                  }
              }
            }));
  }

  Widget buildTextFormField(String label, String prefix,
      TextEditingController controller, Function f) {
    return TextField(
      onChanged: f,
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.red[300]),
          border: OutlineInputBorder(),
          prefixText: ""),
      style: TextStyle(color: Colors.red[300], fontSize: 25.0),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    );
  }
}
