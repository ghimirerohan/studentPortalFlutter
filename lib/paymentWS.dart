import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class paymentWS{

  String Bearer = GetStorage().read('FinalToken').toString();
  int CBpartnerID = GetStorage().read('bPartnerID') as int;
  String CBpartnerName = GetStorage().read('bPartnerName');
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  Future<List> getPayments()async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/C_Payment?\$filter=C_BPartner_ID eq $CBpartnerID');
    var response  = await http.get(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },);
    if(response.statusCode == 200);{
      Map<dynamic,dynamic>DataCollAppScholarshipInfoAddMap = jsonDecode(response.body);
      List<dynamic> DataCollAppScholarshipInfo = DataCollAppScholarshipInfoAddMap['records'];
      return DataCollAppScholarshipInfo;
    }
  }

  Future<void> updateVoucherAttachId(int aId , int cId) async{
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/C_Payment/$cId');
    final msg = jsonEncode({
      "AD_Attachment_ID" : aId
    });
    var response  = await http.put(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body : msg);
    if (kDebugMode) {
      print(response.body);
    }
  }

  Future<int?> VoucherPay(int damt , String ddate ,String dmarks ,String doc , int docId ) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/C_Payment');
    final msg = jsonEncode({
      "C_Currency_ID": {
        "propertyLabel": "Currency",
        "id": 288,
        "identifier": "NPR",
        "model-name": "c_currency"
      },
      "C_BankAccount_ID": {
        "propertyLabel": "Bank Account",
        "id": 1000000,
        "identifier": "NEPAL KHULLA BISHWOBIDHYALAYA (Nepal Open University)_Global IME Bank_--",
        "model-name": "c_bankaccount"
      },
      "TenderType": {
        "propertyLabel": "Tender type",
        "id": "X",
        "identifier": "Attachment Upload/Other",
        "model-name": "ad_ref_list"
      },
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": docId,
        "identifier": doc,
        "model-name": "c_doctype"
      },
      "PayAmt": damt,
      "C_BPartner_ID": {
        "propertyLabel": "Student/Staff/BP",
        "id": CBpartnerID,
        "model-name": "c_bpartner"
      },
      "DateTrx": ddate,
      "IsOnline": true,
      "Description": dmarks,
      "DateAcct": formatter.format(now),
      "model-name": "c_payment"
    });
    var response  = await http.post(url,
      headers:  <String, String>{
        'Access-Control-Allow-Origin': '*',
        'Content-Type': 'application/json',
        'Authorization': Bearer,
      },
    body : msg);


    if(response.statusCode == 200 || response.statusCode == 500){
      print('Done voucher payment ');
      var urlForId = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/C_Payment?\$filter=C_DocType_ID eq $docId and PayAmt eq $damt'
          ' and C_BPartner_ID eq $CBpartnerID and DateTrx eq $ddate and Description eq \'$dmarks\'');
      var response  = await http.get(urlForId,
          headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
          },);
      print(response.body);
      Map<dynamic, dynamic> DataColl = jsonDecode(response.body);
      List<dynamic> DataCollRec = DataColl['records'];
      int id = int.parse(DataCollRec[0]['id'].toString());
      return id;
    }
  }

  Future<void> OnlinePay(int damt  ,String dmarks , int txnId ,String doc , int docId) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/C_Payment');
    final msg = jsonEncode({
      "C_Currency_ID": {
        "propertyLabel": "Currency",
        "id": 288,
        "identifier": "NPR",
        "model-name": "c_currency"
      },
      "C_BankAccount_ID": {
        "propertyLabel": "Bank Account",
        "id": 1000000,
        "identifier": "NEPAL KHULLA BISHWOBIDHYALAYA (Nepal Open University)_Global IME Bank_--",
        "model-name": "c_bankaccount"
      },
      "TenderType": {
        "propertyLabel": "Tender type",
        "id": "T",
        "identifier": "Online NPS Payment",
        "model-name": "ad_ref_list"
      },
      "DiscountAmt": 0,
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": docId,
        "identifier": doc,
        "model-name": "c_doctype"
      },
      "PayAmt": damt,
      "C_BPartner_ID": {
        "propertyLabel": "Student/Staff/BP",
        "id": CBpartnerID,
        "model-name": "c_bpartner"
      },
      "Orig_TrxID" : txnId,
      "DateTrx": formatter.format(now),
      "IsOnline": true,
      "Description": dmarks,
      "DateAcct": formatter.format(now),
      "model-name": "c_payment"
    });
    var response  = await http.post(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body : msg);
    print(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      print('Done Online payment ');

    }
  }

  Future<void> OfflinePay(int damt , String ddate ,String dmarks , int txnId,String doc , int docId) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/C_Payment');
    final msg = jsonEncode({
      "C_Currency_ID": {
        "propertyLabel": "Currency",
        "id": 288,
        "identifier": "NPR",
        "model-name": "c_currency"
      },
      "C_BankAccount_ID": {
        "propertyLabel": "Bank Account",
        "id": 1000000,
        "identifier": "NEPAL KHULLA BISHWOBIDHYALAYA (Nepal Open University)_Global IME Bank_--",
        "model-name": "c_bankaccount"
      },
      "TenderType": {
        "propertyLabel": "Tender type",
        "id": "A",
        "identifier": "GIBL Branch Deposit",
        "model-name": "ad_ref_list"
      },
      "DiscountAmt": 0,
      "C_DocType_ID": {
        "propertyLabel": "Document Type",
        "id": docId,
        "identifier": doc,
        "model-name": "c_doctype"
      },
      "PayAmt": damt,
      "C_BPartner_ID": {
        "propertyLabel": "Student/Staff/BP",
        "id": CBpartnerID,
        "model-name": "c_bpartner"
      },
      "Orig_TrxID" : txnId,
      "DateTrx": ddate,
      "IsOnline": true,
      "Description": dmarks,
      "DateAcct": formatter.format(now),
      "model-name": "c_payment"
    });
    var response  = await http.post(url,
        headers:  <String, String>{
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body : msg);
    print(response.body);

    if(response.statusCode == 200 || response.statusCode == 201){
      print('Done Offline payment ');

    }
  }

  Future<String> paymentData(var amt , String remarks) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/npg/v1/generateLink?Amount=$amt&Remarks=$remarks');
    var response  = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'text/html',
      },
    );
    if(response.statusCode == 200){
      var document = parse(response.body);
      return document.outerHtml;
    }
    else{
      throw('Server error');
    }
  }
  // webview() async {
  //   final client = HttpClient();
  //   var uri = Uri.parse(
  //       "https://gatewaysandbox.nepalpayment.com/Payment/Index");
  //   var request = await client.postUrl(uri);
  //   request.followRedirects = false;
  //   var response = await request.close();
  //   while (response.isRedirect) {
  //     response.drain();
  //     final location = response.headers.value(HttpHeaders.locationHeader);
  //     if (location != null) {
  //       uri = uri.resolve(location);
  //       request = await client.getUrl(uri);
  //       // Set the body or headers as desired.
  //       request.followRedirects = false;
  //       response = await request.close();
  //     }
  //   }
  // }
  Future<String> getReport(String txnid) async {
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/npg/v1/process/student_payment_receipt');
    final msg = jsonEncode({
      "merchanttxnid" : txnid,
      "report-type" : "PDF",
    });
    var response  = await http.post(
      url,
      headers: <String, String>{
        'Access-Control_Allow_Origin': '*',
        'Accept': '*/*',
        'Authorization': Bearer,
      },
      body: msg
    );
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body);
      final String base64 = json['exportFile'];
      print(base64);
      return base64;
    }
    else{
      throw('Server error');
    }
  }

  Future<String> postPayment(List<dynamic> data) async {
    var formData = FormData.fromMap({
      'MerchantName':data[0]['MerchantName'].toString(),
      'MerchantId':data[0]['MerchantId'].toString(),
      'Amount':data[0]['Amount'].toString(),
      // 'InstrumentCode' : 'TMBANK',
      'TransactionRemarks':data[0]['TransactionRemarks'].toString(),
      'MerchantTxnId':data[0]['MerchantTxnId'].toString(),
      'ProcessID':data[0]['ProcessID'].toString()
    });
    var dio = Dio();
    dio.options.headers['content-Type'] = 'multipart/form-data';
    dio.options.headers['accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8';
    dio.options.headers['accept-encoding'] = 'gzip, deflate, br';
// {'accept-encoding: gzip, deflate, br
// accept-language: en-US,en;q=0.5
// cache-control: max-age=0
// content-length: 161
// content-type: application/x-www-form-urlencoded
// origin: null
// sec-fetch-dest: document
// sec-fetch-mode: navigate
// sec-fetch-site: cross-site
// sec-fetch-user: ?1
// sec-gpc: 1
// upgrade-insecure-requests: 1}
    var response = await dio.post('https://gatewaysandbox.nepalpayment.com/Payment/Index', data: formData);
    print(response.statusCode);
    // response.followRedirects = false;
    String urll = response.data;
    return  urll;
  }

  postOffline(int amount , int id , String date) async {
    int id  = 0;
    var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
        .baseUrl}/api/v1/models/n_entrance_reg?filter=C_BPartner_ID=$CBpartnerID');
    var response  = await http.get(
      url,
      headers: <String, String>{
        'Access-Control_Allow_Origin': '*',
        'Accept': '*/*',
        'Authorization': Bearer,
      },
    );
    if(response.statusCode == 200){
      Map<dynamic,dynamic> data = jsonDecode(response.body);
      id  = data['records'][0]['id'];
      var url = Uri.parse('${ApiConstants.protocol}://${ApiConstants
          .baseUrl}/api/v1/models/n_entrance_reg/$id');
      final msg = jsonEncode({
        "deposit_amount" : amount,
        "bank_voucher_attachment" : id,
        "enter_date" : date
      });
      var responseF  = await http.post(url,
        headers:  <String, String>{
          'Access-Control_Allow_Origin': '*',
          'Content-Type': 'application/json',
          'Authorization': Bearer,
        },
        body: msg
      );
      if(responseF.statusCode == 201){
        print("Offline payment saved for entrance ");
      }
      else{
        throw("Some error");
      }

    }
    else{
      throw('Server error');
    }
  }
}