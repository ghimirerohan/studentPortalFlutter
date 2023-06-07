import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'constants.dart';


class entranceOpenInfo{

  List<dynamic> DataColl =[];
  List<dynamic> DataCollApp =[];
  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');


  Future<List<String>> getDDList(List<int> id , int ind)async{
    var date = formatter.format(now);
    List<String> DDList = [];
    switch(ind){
      case 0 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          for(var i = 0 ; i < DataCollApp.length ; i++){
            if(!DDList.contains(DataCollApp[i]['n_intake_ID']['identifier'].toString())) {
              DDList.add(
                  DataCollApp[i]['n_intake_ID']['identifier'].toString());
            }
          }
          return DDList;
          }
      case 1 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} and n_intake_ID eq ${id[1]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          for(var i = 0 ; i < DataCollApp.length ; i++){
            if(!DDList.contains(DataCollApp[i]['n_faculty_ID']['identifier'].toString())) {
              DDList.add(
                  DataCollApp[i]['n_faculty_ID']['identifier'].toString());
            }
          }
          return DDList;
        }
      case 2 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} '
            'and n_intake_ID eq ${id[1]} and n_faculty_ID eq ${id[2]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          for(var i = 0 ; i < DataCollApp.length ; i++){
            if(!DDList.contains(DataCollApp[i]['n_program_ID']['identifier'].toString())) {
              DDList.add(
                  DataCollApp[i]['n_program_ID']['identifier'].toString());
            }
          }
          return DDList;
        }
      case 3 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} '
            'and n_intake_ID eq ${id[1]} and n_faculty_ID eq ${id[2]} and n_program_ID eq ${id[3]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          for(var i = 0 ; i < DataCollApp.length ; i++){
            if(!DDList.contains(DataCollApp[i]['n_subject_ID']['identifier'].toString())) {
              DDList.add(
                  DataCollApp[i]['n_subject_ID']['identifier'].toString());
            }
          }
          return DDList;
        }
      default :
        return DDList;
    }

  }
  Future<List<dynamic>> getFilteredRecords(List<int> id , int ind)async{
    var date = formatter.format(now);
    switch(ind){
      case 0 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          return DataCollApp;
        }
      case 1 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} and n_intake_ID eq ${id[1]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          return DataCollApp;
        }
      case 2 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} '
            'and n_intake_ID eq ${id[1]} and n_faculty_ID eq ${id[2]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          return DataCollApp;
        }
      case 3 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} '
            'and n_intake_ID eq ${id[1]} and n_faculty_ID eq ${id[2]} and n_program_ID eq ${id[3]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          return DataCollApp;
        }
      case 4 :
        var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\' and n_aca_year_ID eq ${id[0]} '
            'and n_intake_ID eq ${id[1]} and n_faculty_ID eq ${id[2]} and n_program_ID eq ${id[3]} and n_subject_ID eq ${id[4]}');
        var response  = await http.get(url,
          headers:  <String, String>{
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json',
            'Authorization': Bearer,
          },);

        if(response.statusCode == 200);{
          Map<dynamic,dynamic> DataColl = jsonDecode(response.body);
          List<dynamic> DataCollApp = DataColl['records'];
          return DataCollApp;
        }
      default :
        return DataCollApp;
    }

  }
  Future<List<dynamic>> getInfo()async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_entrance_reg?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);

    if(response.statusCode == 200);{
      Map<dynamic,dynamic> DataCollApp = jsonDecode(response.body);
      List<dynamic> Rec = DataCollApp['records'];
      return Rec;
    }
  }

  Future<List<dynamic>> openInfo()async {
    var date = formatter.format(now);
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_entrance_open?\$filter=apply_uptolate ge \'$date\'');
    var response  = await http.get(url,
    headers:  <String, String>{
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
      'Authorization': Bearer,
    },);

    if(response.statusCode == 200);{
      Map<dynamic,dynamic> DataCollApp = jsonDecode(response.body);
      List<dynamic> Rec = DataCollApp['records'];
      return Rec;
    }
  }

  Future<void> postAppInfo(int index , List<dynamic> Data)async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_entrance_reg');

    final msg = jsonEncode({
      "docStatus": {
        "propertyLabel": "Document Status",
        "id": "DR",
        "identifier": "Drafted",
        "model-name": "ad_ref_list"
      },
      "C_BPartner_ID": {
        "propertyLabel": "Business Partner",
        "id": CBpartnerID,
        "identifier": CBpartnerName,
        "model-name": "c_bpartner"
      },
      "n_aca_year_ID":
      Data[index]['n_aca_year_ID'],
      "n_intake_ID":
      Data[index]['n_intake_ID'],
      "n_faculty_ID":
      Data[index]['n_faculty_ID'],
      "n_level_ID":
      Data[index]['n_level_ID'],
      "n_program_ID":
      Data[index]['n_program_ID'],
      "n_subject_ID":
      Data[index]['n_subject_ID'],
      "n_entrance_open_ID": {
        "propertyLabel": "Entrance Detail",
        "id": Data[index]['id'],
        "identifier": "-1",
        "model-name": "n_entrance_open"
      },
      "model-name": "n_entrance_reg"

    });
    var response  = await http.post(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },
    body: msg
    );

    if(response.statusCode == 201);{
      print('Success data creation !');
      // return DataColl;
    }
  }
  
}