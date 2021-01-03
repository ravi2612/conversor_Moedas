
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const Request = 'https://api.hgbrasil.com/finance?format=json&key=c948a83a';

void main() async {

  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        hintStyle: TextStyle(color: Colors.amber),
      )),
)); 
}
Future<Map> getData() async{
  http.Response response = await http.get(Request);
  return json.decode(response.body);
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$Conversor\$'),
        backgroundColor: Colors.amber,
        centerTitle:true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando dados ',
                style:TextStyle(
                  color: Colors.amber,
                  fontSize:25.0),
                  textAlign: TextAlign.center,
                ),
              );
              default:
              if (snapshot.hasError) {
                return Center(
                child: Text('Erro ao Carregar',
                style:TextStyle(
                  color: Colors.amber,
                  fontSize:25.0),
                  textAlign: TextAlign.center
                ),
              );
            }else{
              dolar = snapshot.data['results']['currencies']['USD']['buy'];
              euro = snapshot.data['results']['currencies']['EUR']['buy'];

              return SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget> [
                    Icon(Icons.monetization_on, size: 150, color: Colors.amber, ),

                    buildTextField('Reais', 'R\$'),
                    Divider(),
                    buildTextField('Dólares', 'US\$'),
                    Divider(),
                    buildTextField('Euros', '€'),                  
                                        
                  ],
                ),
              );
            }
          }
        },
      ),

    );
  }
}


Widget buildTextField(String label, String prefix){
  return TextField(
                      decoration: InputDecoration(
                        labelText: label,
                        labelStyle: TextStyle(color: Colors.amber),
                        border: OutlineInputBorder(),
                        prefixText: prefix,
                      ),
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                    );
}
