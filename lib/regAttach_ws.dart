import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';



class regAttach {

  static void send_reg_attach(String fileName , String base64Code) async {
    String bearer = GetStorage().read('FinalToken').toString();
    var url =
        Uri.parse('${ApiConstants.protocol}://${ApiConstants
            .baseUrl}/api/v1/models/c_bpartner');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': bearer,
      },
      body : jsonEncode({
        "name": fileName,
        "data": base64Code
      })
    );
    print(response.statusCode);
  }
}