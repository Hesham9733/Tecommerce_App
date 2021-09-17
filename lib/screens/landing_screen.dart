import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_app/consts/circle_icon_button.dart';
import 'package:shop_app/consts/reusable_button.dart';
import 'package:shop_app/consts/reusable_button2.dart';
import 'package:shop_app/services/global_methods.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  bool _isLoadingG = false;
  List images = [
    'https://wallpaperaccess.com/full/1261215.jpg',
    'https://i.pinimg.com/originals/86/2b/36/862b36d2601219865268c368a0e83e33.jpg',
    'https://4kwallpapers.com/images/walls/thumbs_2t/144.png',
  ];

  @override
  void initState() {
    super.initState();
    images.shuffle();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loginAnonymously() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.signInAnonymously();
      Navigator.pushNamed(context, 'Main');
      _globalMethods.flutterToast('Welcome Guest');
    } catch (error) {
      _globalMethods.authErrorHandle(error.message, context);
    } finally {
      setState(() {
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: images[1],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: FractionalOffset(_animation.value, 0),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'WELCOME',
                  style: GoogleFonts.abrilFatface(fontSize: 40, fontWeight: FontWeight.w600)
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'We Make Online Shopping Easier',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.bebasNeue(fontSize: 35, fontWeight: FontWeight.w400)
                  ),
                ),
                Container(
                  height: 250,
                  child: Image(
                    image: AssetImage('lib/assets/buy_me_logo4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ReusableButton2(
                        fct: () {
                          Navigator.pushNamed(context, 'Login');
                        },
                        icon: Feather.log_in,
                        label: 'Log in',
                        buttonColor: Colors.purple.shade400,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ReusableButton2(
                          fct: () {
                            Navigator.pushNamed(context, 'Signup');
                          },
                          icon: Feather.user_plus,
                          buttonColor: Colors.pink.shade400,
                          label: 'Sign Up'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  )),
                  Text(
                    'Or Continue With'.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          onTap: () {
                            _googleSignIn().then((value) =>
                                Navigator.pushNamed(context, 'Main'));
                          },
                          highlightColor: Colors.red.shade200,
                          child: CircleIcon(
                            icon: Entypo.google_,
                            color: Colors.red,
                          )),
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
                  _isLoading
                      ? CircularProgressIndicator()
                      : ReusableButton(
                          label: 'Sign In As Guest',
                          fct: (){
                            _loginAnonymously().then((value) =>
                                Navigator.pushNamed(context, 'Main'));
                          },
                        ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}
