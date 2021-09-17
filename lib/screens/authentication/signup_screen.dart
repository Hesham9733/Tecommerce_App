import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/consts/circle_icon_button.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/consts/list_body_tile.dart';
import 'package:shop_app/consts/reusable_button.dart';
import 'package:shop_app/consts/reusable_button2.dart';
import 'package:shop_app/consts/text_field_reusable.dart';
import 'package:shop_app/services/global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _emailAddress = '';
  String _name = '';
  String _password = '';
  String _url;
  int _phoneNumber;
  final _formKey = GlobalKey<FormState>();
  File _pickedImage;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isLoadingG = false;
  bool _isLoadingGT = false;
  GlobalMethods _globalMethods = GlobalMethods();

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateparse = DateTime.parse(date);
    var formattedDate =
        "${dateparse.day} - ${dateparse.month} - ${dateparse.year}";
    if (isValid) {
      _formKey.currentState.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Please pick an image', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersImages')
              .child(_name + '.jpg');
          await ref.putFile(_pickedImage);
          _url = await ref.getDownloadURL();
          await _auth.createUserWithEmailAndPassword(
            email: _emailAddress.toLowerCase().trim(),
            password: _password.trim(),
          );
          final User user = _auth.currentUser;
          final _uid = user.uid;
          user.updatePhotoURL(_url);
          user.updateDisplayName(_name);
          user.reload();
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _name,
            'email': _emailAddress,
            'phoneNumber': _phoneNumber,
            'imageUrl': _url,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.pushNamed(context, 'Main');
          _globalMethods.flutterToast('Signed Up Successfully');
          // ignore: unnecessary_statements
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loginAnonymously() async {
    setState(() {
      _isLoadingGT = true;
    });
    try {
      await _auth.signInAnonymously();
      Navigator.pushNamed(context, 'Main');

      _globalMethods.flutterToast('Welcome Guest');
    } catch (error) {
      _globalMethods.authErrorHandle(error.message, context);
    } finally {
      setState(() {
        _isLoadingGT = false;
      });
    }
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _isLoadingG = true;
    });
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          var date = DateTime.now().toString();
          var dateparse = DateTime.parse(date);
          var formattedDate =
              "${dateparse.day} - ${dateparse.month} - ${dateparse.year}";
          final authResult =
              await _auth.signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'id': authResult.user.uid,
            'name': authResult.user.displayName,
            'email': authResult.user.email,
            'phoneNumber': authResult.user.phoneNumber,
            'imageUrl': authResult.user.photoURL,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.pushNamed(context, 'Main');
          _globalMethods.flutterToast('Logged In Successfully');
        } catch (error) {
          _globalMethods.authErrorHandle(error.message, context);
        } finally {
          setState(() {
            _isLoadingG = false;
          });
        }
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 10);
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [ColorsConsts.gradiendFStart, ColorsConsts.gradiendLStart],
                    [ColorsConsts.gradiendFEnd, ColorsConsts.gradiendLEnd],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.15, 0.2],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: ColorsConsts.gradiendLEnd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: ColorsConsts.gradiendFEnd,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 120,
                        left: 120,
                        child: RawMaterialButton(
                          elevation: 10,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15.0),
                          fillColor: ColorsConsts.gradiendLEnd,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Choose Option',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: ColorsConsts.gradiendLStart),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          ListBodyTile(
                                            icon: Icons.camera,
                                            iconColor: Colors.purpleAccent,
                                            labelText: 'Camera',
                                            onTapFct: _pickImageCamera,
                                            textColor: ColorsConsts.title,
                                          ),
                                          ListBodyTile(
                                            icon: Icons.image,
                                            iconColor: Colors.purpleAccent,
                                            labelText: 'Gallery',
                                            onTapFct: _pickImageGallery,
                                            textColor: ColorsConsts.title,
                                          ),
                                          ListBodyTile(
                                            icon: Icons.remove_circle,
                                            iconColor: Colors.red,
                                            labelText: 'Remove',
                                            onTapFct: _removeImage,
                                            textColor: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Icon(Icons.add_a_photo),
                        ))
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldRe(
                            labelText: 'Full Name',
                            prefixIcon: Icons.person,
                            valueKey: 'name',
                            fctValid: (value) {
                              if (value.isEmpty) {
                                return 'Name can not be null';
                              }
                              return null;
                            },
                            inputType: TextInputType.name,
                            onSavedFct: (value) {
                              _name = value;
                            },
                            onEditCompleteFct: null),
                        TextFieldRe(
                            labelText: 'Phone Number',
                            prefixIcon: Icons.phone_android,
                            valueKey: 'Phone Number',
                            fctValid: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid phone number';
                              }
                              return null;
                            },
                            inputType: TextInputType.phone,
                            onSavedFct: (value) {
                              _phoneNumber = int.parse(value);
                            },
                            onEditCompleteFct: null),
                        TextFieldRe(
                            labelText: 'Email Address',
                            prefixIcon: Icons.email,
                            valueKey: 'email',
                            fctValid: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            inputType: TextInputType.emailAddress,
                            onSavedFct: (value) {
                              _emailAddress = value;
                            },
                            onEditCompleteFct: null),
                        TextFieldRePass(
                            onSavedFct: (value) {
                              _password = value;
                            },
                            onEditCompleteFct: _submitForm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isLoading
                                ? CircularProgressIndicator()
                                : ReusableButton2(
                                    icon: Feather.user_plus,
                                    label: 'Sign Up',
                                    fct: () {
                                      Navigator.pushNamed(context, 'Signup');
                                    },
                                    buttonColor: Colors.pink.shade400,
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                            )),
                            Text(
                              'Or Continue With'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600),
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Divider(
                                color: Colors.white,
                                thickness: 2,
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _isLoadingG
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: _googleSignIn,
                                    highlightColor: Colors.red.shade200,
                                    child: CircleIcon(
                                      icon: Entypo.google_,
                                      color: Colors.red,
                                    ),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {},
                                highlightColor: Colors.blue.shade200,
                                child: CircleIcon(
                                  icon: Entypo.facebook_with_circle,
                                  color: Colors.blue,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            _isLoadingGT
                                ? CircularProgressIndicator()
                                : ReusableButton(
                                    label: 'Sign In As Guest',
                                    fct: _loginAnonymously,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
