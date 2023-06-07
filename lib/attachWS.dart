import 'dart:convert';
import 'dart:core';
import 'dart:html';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class attachWS {

  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  int enrollId = GetStorage().read('enrollId');

  Future<int?> getTableID(String modelName) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/ad_table?\$filter=tablename eq \'$modelName\'');

    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['records'];
      int tableId = DataCollRec[0]['id'];
      return tableId;
      // GetStorage().write('tableID', tableId);
    }
    else {
      return null;
    }
  }
  Future<String> getTableName(int id) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/ad_table/$id');

    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      final jsonst = "[" + response.body + "]";
      var json = jsonDecode(jsonst);
      String tableName = json[0]['TableName'];
      return tableName;
      // GetStorage().write('tableID', tableId);
    }
    else {
      throw('Problem in getting Table Name from ad_table model :');
    }
  }
  Future<int?> getAttachmentID(int tableId , int recordID) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/ad_attachment?\$filter=AD_Table_ID eq $tableId and Record_ID eq $recordID');

    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['records'];
      int attachId = DataCollRec[0]['id'];
      return attachId;
      // GetStorage().write('tableID', tableId);
    }
    else {
      return null;
    }
  }

  Future<void> deleteAttachment(Map<dynamic,dynamic> Data) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    if (kDebugMode) {
      // print('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
      //   '${Data['id']}/attachments');
      // print(Data);
    }
    var response  = await http.delete(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if (kDebugMode) {
      print(response.body);
    }
  }

  Future<List> getAttachFromId(int id) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/ad_attachment/'
        '$id');
    if (kDebugMode) {
      // print('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
      //   '${Data['id']}/attachments');
      // print(Data);
    }
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      final jsonst = "[" + response.body + "]";
      List<dynamic> json = jsonDecode(jsonst);
      return json;
      // GetStorage().write('tableID', tableId);
    }
    else {
      throw('Problem in getting Datas from ad_attachment model :');
    }
  }

  Future<void> uploadAttachment(List<dynamic> Data , String fileName , String base64Code)async{
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data[0]['model-name']}/'
          '${Data[0]['id']}/attachments');

      final msg  = jsonEncode({
          "name" : fileName,
          "data" : base64Code
      });
      var response = await http.post(url,
      headers: <String , String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },
      body: msg
      );
      if(response.statusCode ==  201) {
        if (kDebugMode) {
          print('Success upload of attachment !');
        }
      }

  }

  Future<void> uploadAttachmentSingle(Map<dynamic,dynamic> Data , String fileName , String base64Code)async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    final msg  = jsonEncode({
      "name" : fileName,
      "data" : base64Code
    });
    print(msg);
    var response = await http.post(url,
        headers: <String , String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Accept':'application/json',
          'Authorization': Bearer,
        },
        body: msg
    );
    print(response.body);
    if(response.statusCode ==  201) {
      if (kDebugMode) {
        print('Success upload of attachment !');
      }
    }

  }

  Future<void> uploadVoucher(int payId , String fileName , String base64Code)async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/C_Payment/'
        '$payId/attachments');

    final msg  = jsonEncode({
      "name" : fileName,
      "data" : base64Code
    });
    var response = await http.post(url,
        headers: <String , String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Accept':'application/json',
          'Authorization': Bearer,
        },
        body: msg
    );
    if(response.statusCode ==  201) {
      if (kDebugMode) {
        print('Success upload of attachment !');
      }
    }

  }

  Future<int?>isAttachmentEmpty(Map<dynamic,dynamic>Data) async{
    int attachEmpty = 0;
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200) {
      Map<dynamic, dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['attachments'];
      if(DataCollRec.isEmpty){attachEmpty = 1;}
      return attachEmpty;
    }
  }

  Future<String?>AttchType(Map<dynamic,dynamic>Data) async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200) {
      Map<dynamic, dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['attachments'];
      return DataCollRec[0]['contentType'].toString();
    }
  }

  Future<Uint8List?> getAttachment(Map<dynamic,dynamic>Data) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['attachments'];
      var dio = Dio();
      final responseS = await dio.get(
        '${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
            '${Data['id']}/attachments/${DataCollRec[0]['name']}',
        options: Options(
          responseType: ResponseType.bytes,
          headers: {'Authorization': Bearer,
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Accept':'application/octet-stream'},
          contentType: 'application/octet-stream',
        ),
      );
  Uint8List Bytes = responseS.data.buffer.asUint8List();

      return Bytes;
      // GetStorage().write('tableID', tableId);
    }
    else {
      return null;
    }
  }

  Future<List> getAttchTypeList(var Data) async{
    List<String> attType = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['attachments'];
      for(var  i = 0 ; i < DataCollRec.length ; i++){
        attType.add(DataCollRec[i]['contentType']);
      }
    return attType;
    }else{
      throw('problem in getting content type list');
    }
  }
  Future<List<Uint8List>?> getAttachmentList(Map<dynamic,dynamic>Data) async {
    List<Uint8List> attchFiles = [];
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants.baseUrl}/api/v1/models/${Data['model-name']}/'
        '${Data['id']}/attachments');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200){
      Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['attachments'];
      for(var i = 0 ; i < DataCollRec.length ; i++) {
        var dio = Dio();
        final responseS = await dio.get(
          '${ApiConstants.protocol}://${ApiConstants
              .baseUrl}/api/v1/models/${Data['model-name']}/'
              '${Data['id']}/attachments/${DataCollRec[i]['name']}',
          options: Options(
            responseType: ResponseType.bytes,
            headers: {'Authorization': Bearer,
              'Access-Control-Allow-Origin': '*',
              'Content-Type': 'application/json',
              'Accept': 'application/octet-stream'},
            contentType: 'application/octet-stream',
          ),
        );
        Uint8List Bytes = responseS.data.buffer.asUint8List();
        attchFiles.add(Bytes);
      }

      return attchFiles;
      // GetStorage().write('tableID', tableId);
    }
    else {
      return null;
    }
  }


}