import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_authentication_alen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final CollectionReference registration =
      FirebaseFirestore.instance.collection('registration');
  TextEditingController dateController = TextEditingController();
  TextEditingController fname = TextEditingController();
  TextEditingController lname = TextEditingController();

  XFile? pickedFile; //for
  PlatformFile? pickedfilePDF;
  UploadTask? uploadTaskImage;
  UploadTask? uploadTaskPDF;

  String urlDownload1 = ''; ///image upload
  String urlDownload2 = ''; ///pdf upload

  File? imageFile;
  // final ImagePicker picker = ImagePicker();

  void addUser() {
    final data = {
      'fname': fname.text,
      'lname': lname.text,
      'dob': dateController.text,
      'profile_pic': urlDownload1,
      'id_proof': urlDownload2,
    };
    registration.add(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    dateController.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Create Account',
        style: TextStyle(color: Colors.white, fontSize: 22)
          )
        ),
        body: Stack(
          children: [
            // Container(
            //   padding: const EdgeInsets.only(left: 35, top: 30),
            //   child: const Text(
            //     'Create\nAccount',
            //     style: TextStyle(color: Colors.white, fontSize: 33),
            //   ),
            // ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.23), //.28 previous
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter first name';
                                }
                              },
                              controller: fname,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                // only accept letters from a to z
                                FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true)
                              ],
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "First Name",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: lname,
                              keyboardType: TextInputType.name,
                              inputFormatters: [
                                // only accept letters from a to z
                                FilteringTextInputFormatter(RegExp(r'[a-zA-Z]'), allow: true)
                              ],
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Last Name",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter second name';
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: dateController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  hintText: "Enter DOB",
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    // initialDate:  (DateTime.now()), //get today's date  change this
                                    firstDate: DateTime(
                                        1940), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy').format(
                                          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2022-07-04
                                  //You can format date as per your need
                                  setState(() {
                                    dateController.text =
                                        formattedDate; //set formatted date to TextField value.
                                    DateTime currentDate = DateTime.now();
                                    /////////////////////////////////////////
                                    int age =
                                        currentDate.year - pickedDate.year;
                                    int month1 = currentDate.month;
                                    int month2 = pickedDate.month;
                                    if (month2 > month1) {
                                      age--;
                                    } else if (month1 == month2) {
                                      int day1 = currentDate.day;
                                      int day2 = pickedDate.day;
                                      if (day2 > day1) {
                                        age--;
                                      }
                                    }
                                    print("updated age : $age");
                                  }); //set state closed
                                } else {
                                  print("Date is not selected");
                                }
                              }, // w
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Select date of birth';
                                }
                              }, // hen true user cannot edit text
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (urlDownload1 != '')
                                    // ? const Text('Image uploaded',textAlign: TextAlign.left,)
                                ? Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 1.0,           // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 38.0 ,vertical:  10.0), // Add horizontal padding
                                    child: Text(
                                      'Image uploaded', // Hint text or content
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                      ),
                                    ),
                                  ),
                                )

                                    :
                                const Text('Choose image'),
                                const SizedBox(width: 30,),
                                if (urlDownload1 == '')
                                  Flexible(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _getFromGallery();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          // backgroundColor: Colors.green.shade600,
                                          backgroundColor:
                                              const Color(0xff4c505b),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      icon: const Icon(
                                        // <-- Icon
                                        Icons.upload,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Choose Profile Picture',
                                        style: TextStyle(color: Colors.white),
                                      ), // <-- Text
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (pickedFile != null && urlDownload1 == '')
                              SizedBox(
                                height: 200,
                                child: Image.file(
                                  File(pickedFile!.path),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (pickedFile != null && urlDownload1 == '')
                              ElevatedButton(
                                  onPressed: uploadFile,
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.green.shade600,
                                      backgroundColor: const Color(0xff4c505b),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'Upload image',
                                    style: TextStyle(color: Colors.white),
                                  )),

                            const SizedBox(
                              height: 20,
                            ),
                            if (pickedFile != null && uploadTaskImage != null)
                              buildProgress(),

                            /////////////////////////////////////////////////////
                            /// _getFromFile();

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (urlDownload2 != '')
                                // ? const Text('Image uploaded',textAlign: TextAlign.left,)
                                    ? Container(
                                  width: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white, // Border color
                                      width: 1.0,           // Border width
                                    ),
                                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 38.0 ,vertical:  10.0), // Add horizontal padding
                                    child: Text(
                                      'ID card uploaded', // Hint text or content
                                      style: TextStyle(
                                        color: Colors.white, // Text color
                                      ),
                                    ),
                                  ),
                                )

                                    :
                                const Text('Choose PDF file'),
                                const SizedBox(width: 30,),
                                if (urlDownload2 == '')
                                  Flexible(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _getFromFile();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        // backgroundColor: Colors.green.shade600,
                                          backgroundColor:
                                          const Color(0xff4c505b),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10))),
                                      icon: const Icon(
                                        // <-- Icon
                                        Icons.upload,
                                        size: 24.0,
                                        color: Colors.white,
                                      ),
                                      label: const Text(
                                        'Choose ID card',
                                        style: TextStyle(color: Colors.white),
                                      ), // <-- Text
                                    ),
                                  ),
                              ],
                            ),


                            if (pickedfilePDF != null && urlDownload2 == '')
                              Image.asset('assets/images/pdf.png'),
                              const SizedBox(
                                height: 20,
                              ),
                              if(urlDownload2 == '')
                              ElevatedButton(
                                  onPressed: uploadFilePDF,
                                  style: ElevatedButton.styleFrom(
                                    // backgroundColor: Colors.green.shade600,
                                      backgroundColor: const Color(0xff4c505b),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10))),
                                  child: const Text(
                                    'Upload ID Card',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            const SizedBox(
                              height: 20,
                            ),


                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 45,
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (urlDownload1 == '') {
                                        Fluttertoast.showToast(
                                            msg: 'Upload image');
                                      }
                                      else if(urlDownload2 == ''){
                                        Fluttertoast.showToast(
                                            msg: 'Upload ID proof');
                                      }
                                      else {
                                        print('Dob ${dateController.text}');
                                        addUser();
                                        clearText();
                                        Fluttertoast.showToast(
                                            msg: 'Registration Successful');
                                        Future.delayed(const Duration(seconds: 2),(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLogin()));
                                        });

                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.green.shade600,
                                      backgroundColor: const Color(0xff4c505b),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyLogin()));
                                  },
                                  style: const ButtonStyle(),
                                  child: const Text(
                                    'Already have account?',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTaskImage?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 50);
        }
      });
 /// to clear textformfields
  void clearText() {
    fname.clear();
    lname.clear();
    dateController.clear();
    urlDownload1='';
    urlDownload2='';
  }

  /// Get from gallery
  Future _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
        print(pickedFile!.name);///   picked file name
        print(imageFile);
      });
    }
  }

  /// Get from file
  Future _getFromFile() async {
    final result = await FilePicker.platform.pickFiles();
    if(result != null) {
      setState(() {
        pickedfilePDF = result.files.first;
        print(pickedfilePDF!.path);
        print(pickedfilePDF!.name);
      });
    }
  }
  /// Upload PDF to firebase
  Future<void> uploadFilePDF() async {
    print('Uploading to Firebase Storage');
    final path = 'pdf/${pickedfilePDF!.name}'; // Use pickedfilePDF!.name for the file name
    final file = File(pickedfilePDF!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTaskPDF = ref.putFile(file);
    });

    final snapshot = await uploadTaskPDF!.whenComplete(() {});
    print('Upload complete');

    urlDownload2 = await snapshot.ref.getDownloadURL();
    print('File Download link: $urlDownload2');

    setState(() {
      uploadTaskImage = null;
    });
  }

  /// Upload Image to firebase
  Future<void> uploadFile() async {
    print('uploading to firebase');
    final path = 'images/${pickedFile!.name}';
    final file = File(pickedFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTaskImage = ref.putFile(file);
    });

    final snapshot = await uploadTaskImage!.whenComplete(() {});
    print('upload complete');

    urlDownload1 = await snapshot.ref.getDownloadURL();
    print('Image Download link : $urlDownload1');

    setState(() {
      uploadTaskImage = null;
    });
  }

}
