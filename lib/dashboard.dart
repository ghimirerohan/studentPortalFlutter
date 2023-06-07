//  // import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'ad_user_model.dart';
// import 'authentication_ws.dart';
// import 'package:register_openu/login/login.dart';
// import 'package:get_storage/get_storage.dart';
// import 'ad_user_ws.dart';
//
// class DashBoard extends StatefulWidget {
//   String id = '';
//   var press_b1 = 0;
//   var press_b2 = 0;
//   int select = 0;
//   var ad = ad_user_ws.check_reg();
//   var registerStatus = GetStorage().read('reg_st');
//   DashBoard(String user_id) {id = user_id ;}
//
//   @override
//   State<DashBoard> createState() => _DashBoardState();
// }
//
// class _DashBoardState extends State<DashBoard> {
//   @override
//   void initState()  {
//
//     String id = widget.id;
//     super.initState();
//   }
//
//
//   Widget build(BuildContext context) {
//     var regSt = widget.registerStatus;
//     String id = widget.id;
//     return Scaffold(
//       body:SingleChildScrollView(
//         child:  Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end : Alignment.centerRight,
//               colors: [
//                 Color(0xFF7F7FD5),
//                 Color(0xFF86A8E7),
//                 Color(0xFF91EAE4),
//               ],
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Container(
//                   alignment: Alignment.centerLeft,
//                   height:MediaQuery.of(context).size.height-66,
//                   width: MediaQuery.of(context).size.width-66,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(14),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Expanded(
//                             flex: 1,
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 8,),
//                                 Image.asset('assets/images/logo.png',height: 77,width: 77,),
//                                 SizedBox(height: 15,),
//                                 Container(
//                                   padding: EdgeInsets.all(12),
//                                   child: Text(
//                                     'Welcome $id You are : ',
//                                     style: TextStyle(
//                                       fontSize: 21,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blueAccent,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 12,),
//                                  Text(
//                                   regSt == 1 ? 'Registered!' : 'Not Regsitered !',
//                                   style: TextStyle(
//                                     fontSize: 21,
//                                     fontWeight: FontWeight.bold,
//                                     color: regSt == 1 ?Colors.green : Colors.redAccent,
//                                   ),
//                                 ),
//                                 SizedBox(height: 12,),
//                                 GestureDetector(
//                                   onTap: (){
//                                     setState(() {
//                                       if (widget.press_b1 == 0 ){
//                                         widget.press_b1 = 1;
//                                         widget.press_b2 = 0;
//                                       }
//                                       widget.select == 0 ? widget.select = 1 : widget.select = 0;
//                                     });
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     width: (MediaQuery.of(context).size.width-66)/5,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.centerLeft,
//                                         end: Alignment.centerRight,
//                                         colors: widget.press_b1 == 0 ?[
//                                           Color(0xFF7F7FD5),
//                                           Color(0xFF86A8E7),
//                                           Color(0xFF91EAE4),]
//                                         :
//                                        [ Color(0xFF333333),
//                                         Color(0xFFdd1818),]
//                                         ,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(14),
//                                       child: Text(
//                                         'View Form',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 12,),
//                                 GestureDetector(
//                                   onTap: (){
//                                     setState(() {
//                                       if (widget.press_b2 == 0 ){
//                                         widget.press_b2 = 1;
//                                         widget.press_b1 = 0;
//                                       }
//                                       widget.select == 1 ? widget.select = 0 : widget.select = 1;
//
//                                     });
//                                   },
//                                   child: Container(
//                                     alignment: Alignment.center,
//                                     width: (MediaQuery.of(context).size.width-66)/5,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50),
//                                       gradient: LinearGradient(
//                                         begin: Alignment.centerLeft,
//                                         end: Alignment.centerRight,
//                                         colors: widget.press_b2 == 0 ?[
//                                           Color(0xFF7F7FD5),
//                                           Color(0xFF86A8E7),
//                                           Color(0xFF91EAE4),]
//                                             :
//                                         [ Color(0xFF333333),
//                                           Color(0xFFdd1818),]
//                                         ,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(14),
//                                       child: Text(
//                                         'My Form',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ),
//                         Expanded(
//                             flex: 4,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 SizedBox(height: 24,),
//                                 form(select: widget.select,),
//                                 SizedBox(height: 24,),
//
//                               ],
//                             )
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),);
//   }
// }
//
// class form extends StatelessWidget{
//   form({required this.select});
//   final int select;
//
//   @override
//   Widget build(BuildContext context) {
//     return select == 1 ?
//     Container(
//       width: (MediaQuery.of(context).size.width-66)/6,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           TextField(
//             onChanged: (value){},
//             decoration: InputDecoration(
//               labelText: 'Enter Student ID',
//               suffixIcon: Icon(Icons.perm_identity, size: 25,),
//             ),
//           ),
//           SizedBox(height: 15,),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                   onPressed: (){}
//                   , child: Text(
//                 'GO!',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//
//               )
//               )
//             ],
//           )
//         ],
//       ),
//     )
//     :
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         SizedBox(height: 33,),
//         textfield(label: 'Name', hint: 'Full Name'),
//         SizedBox(height: 8,),
//         textfield(label: 'Email', hint:'example@example.com' ),
//         SizedBox(height: 8,),
//         textfield(label:'Phone' , hint:'1234567890' ),
//         SizedBox(height: 8,),
//         textfield(label:'Date Of Birth' , hint: 'DD-MM-YYYY'),
//         SizedBox(height: 8,),
//         textfield(label: 'Gender', hint:'M/F/Other' ),
//         SizedBox(height: 33,),
//         SizedBox(height: 12,),
//         ElevatedButton(
//           style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
//             onPressed: (){}
//             , child: Text(
//           'SAVE',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//           ),
//
//         )
//         ),
//
//
//
//       ],
//     );
//
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }
//
//
// class textfield extends StatelessWidget{
//   String label;
//   String hint;
//   textfield({required this.label,required this.hint});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//       Container(
//       padding: EdgeInsets.all(15),
//       width :400,
//       child: TextFormField(
//       decoration: InputDecoration(
//       labelText: label,
//       hintText: hint,
//       ),
//       ),
//       ),
//
//       ],
//     );
//
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//
// }//