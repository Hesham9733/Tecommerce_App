import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/consts/circle_icon_button.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/consts/reusable_button.dart';
import 'package:shop_app/consts/reusable_button2.dart';
import 'package:shop_app/consts/text_field_reusable.dart';
import 'package:shop_app/services/global_methods.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _emailAddress = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isLoadingG = false;
  bool _isLoadingGT = false;
  GlobalMethods _globalMethods = GlobalMethods();

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

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState.save();
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _emailAddress.toLowerCase().trim(),
                password: _password.trim())
            .then((value) {
              Navigator.pushNamed(context, 'Main');
              _globalMethods.flutterToast('Logged In Successfully');
            });       
        
      } catch (error) {
        _globalMethods.authErrorHandle(error.message, context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
                Container(
                  margin: EdgeInsets.only(top: 80),
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://iconarchive.com/download/i77853/custom-icon-design/pretty-office-11/shop.ico'),
                          fit: BoxFit.fill),
                      shape: BoxShape.rectangle),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldRe(
                            onEditCompleteFct: null,
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
                            }),
                        TextFieldRePass(
                            onSavedFct: (value) {
                              _password = value;
                            },
                            onEditCompleteFct: _submitForm),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, 'Forget Password');
                                },
                                child: Text(
                                  'Forget password ?',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                  ),
                                )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _isLoading
                                ? CircularProgressIndicator()
                                : ReusableButton2(
                                    icon: Feather.log_in,
                                    label: 'Log in',
                                    fct: _submitForm,
                                    buttonColor: Colors.purple.shade400,
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
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
                                fct: _loginAnonymously,
                                label: 'Sign In As Guest'),
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
