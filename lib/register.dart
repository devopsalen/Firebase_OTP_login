import 'dart:io';

import 'package:firebase_authentication_alen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController dateController = TextEditingController();

  XFile? pickedFile;
  UploadTask? uploadTask;
  String urlDownload = '';
  File? imageFile;

  // final ImagePicker picker = ImagePicker();

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
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 30),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextField(
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
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
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
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
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
                                hintStyle: const TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      DateTime.now(), //get today's date
                                  firstDate: DateTime(
                                      2000), //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101));

                              if (pickedDate != null) {
                                print(
                                    pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                String formattedDate = DateFormat('dd-MM-yyyy')
                                    .format(
                                        pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                print(
                                    formattedDate); //formatted date output using intl package =>  2022-07-04
                                //You can format date as per your need

                                setState(() {
                                  dateController.text =
                                      formattedDate; //set foratted date to TextField value.
                                  print(DateTime.now().year -
                                      pickedDate.year); //prints age
                                });
                              } else {
                                print("Date is not selected");
                              }
                            }, // when true user cannot edit text
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // const Text("Profile picture"),
                              // (pickedFile != null)
                              //     ? const Text('Image selected')
                              //     : const Text('No image selected'),

                              (urlDownload != '')
                                  ? const Text('Image uploaded')
                                  : const Text('Choose image'),

                              if (urlDownload == '')
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _getFromGallery();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      // backgroundColor: Colors.green.shade600,
                                      backgroundColor: const Color(0xff4c505b),
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
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (pickedFile != null && urlDownload == '')
                            SizedBox(
                              height: 200,
                              child: Image.file(
                                File(pickedFile!.path),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (pickedFile != null && urlDownload == '')
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
                          if (pickedFile != null && uploadTask != null)
                            buildProgress(),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text("ID Proof"),
                          //     ElevatedButton.icon(
                          //       onPressed: _getFromGallery,
                          //       style: ElevatedButton.styleFrom(
                          //         // backgroundColor: Colors.green.shade600,
                          //           backgroundColor: const Color(0xff4c505b),
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10))),
                          //       icon: const Icon( // <-- Icon
                          //         Icons.upload,
                          //         size: 24.0,
                          //         color: Colors.white,
                          //       ),
                          //       label: Text('Choose image' ,style: TextStyle(color: Colors.white),), // <-- Text
                          //     ),
                          //
                          //   ],
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  print('Dob ${dateController.text}');
                                  print("Age = $dateController");
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
      stream: uploadTask?.snapshotEvents,
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

  /// Get from gallery
  Future _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile!.path);
        print(pickedFile!.name);

        ///   picked file name
        print(imageFile);
      });
    }
  }

  /// Upload to firebase
  Future<void> uploadFile() async {
    print('uploading to firebase');
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    print('upload complete');

    urlDownload = await snapshot.ref.getDownloadURL();
    print('Download link : $urlDownload');

    setState(() {
      uploadTask = null;
    });
  }

//we can upload image from camera or from gallery based on parameter
  // Future getImage(ImageSource media) async {
  //   var img = await picker.pickImage(source: media);
  //
  //   setState(() {
  //     image = img;
  //     print(image);
  //   });
  // }
}
