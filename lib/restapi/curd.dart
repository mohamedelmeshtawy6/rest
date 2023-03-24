import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('waell:wael12345'));

Map<String, String> myheaders = {'authorization': _basicAuth};

mixin Curd {
  getRequest(String uri) async {
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      } else {}
    } catch (e) {
      //hgbngh
    }
  }

  postRequest(String uri, Map data) async {
    try {
      var response =
          await http.post(Uri.parse(uri), body: data, headers: myheaders);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      //ghjkl
    }
  }

  postRequestWithFile(String uri, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(uri));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multiPartFile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    request.headers.addAll(myheaders);
    request.files.add(multiPartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myRequest = await request.send();
    var response = await http.Response.fromStream(myRequest);

    if (myRequest.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      //print('error${myRequest.statusCode}');
    }
  }
}
