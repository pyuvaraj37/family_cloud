import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  bool sending = false; 
  bool selecting = false; 
  var url = Uri.parse("http://127.0.0.1:5000/upload");
  List<int> _selectedFile;
  Uint8List _bytesData;
  GlobalKey _formKey = new GlobalKey();

  Future sendImages() async{
    var request = new http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromBytes(
        'file', _selectedFile,
        contentType: new MediaType('application', 'octet-stream'),
        filename: "file_up"));
    request.send().then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) print("Uploaded!");
    });
    setState(() {
      sending = true;
    });

  }
  void _handleResult(Object result) {
  setState(() {
          _bytesData = Base64Decoder().convert(result.toString().split(",").last);
          _selectedFile = _bytesData;
  });
} 

  startWebFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });
      reader.readAsDataUrl(file);
    });
    
    setState(() {
      selecting = true; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Form(
            autovalidate: true,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                selecting? CircularProgressIndicator():FlatButton(
                  child: Text('Get documents'),
                  onPressed: startWebFilePicker,
                ),
                sending? CircularProgressIndicator():FlatButton(
                  child: Text('Send Files'),
                  onPressed: sendImages,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}