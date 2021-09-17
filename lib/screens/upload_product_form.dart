import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/consts/colors.dart';
import 'package:shop_app/provider/dark_theme_provider.dart';
import 'package:shop_app/services/global_methods.dart';
import 'package:uuid/uuid.dart';

class UploadProductForm extends StatefulWidget {
  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  String _productTitle = '';
  double _productPrice;
  String _productCategory = '';
  String _productBrand = '';
  String _productDescription = '';
  int _productQuantity;
  bool _popularity;
  String _url;
  var uuId = Uuid();
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethods _globalMethods = GlobalMethods();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  String _categoryValue;
  String _brandValue;
  bool _popularityValue;

  File _pickedImage;
  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
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
              .child('productimages')
              .child(_productTitle + '.jpg');
          await ref.putFile(_pickedImage);
          _url = await ref.getDownloadURL();
          final User user = _auth.currentUser;
          final _uid = user.uid;
          final _productId = uuId.v4();
          await FirebaseFirestore.instance
              .collection('products')
              .doc(_productId)
              .set({
            'productId': _productId,
            'productBrand': _productBrand,
            'productCategory': _productCategory,
            'productDescription': _productDescription,
            'productPrice': _productPrice,
            'productImage': _url,
            'productTitle': _productTitle,
            'productQuantity': _productQuantity,
            'createdAt': Timestamp.now(),
            'userId': _uid,
            'popularity': _popularity,
          });
          _globalMethods.flutterToast('Product Uploaded Successfully');
          // ignore: unnecessary_statements
          Navigator.pushNamed(context, 'Main');
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

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload New Product',
          // ignore: deprecated_member_use
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: themeState.darkTheme
              ? Colors.purple.shade900
              : Colors.pink.shade100,
          child: InkWell(
            onTap: _submitForm,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator())
                      : Text('Upload',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                ),
                GradientIcon(
                  Feather.upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow[800]
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    key: ValueKey('Title'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter a Title';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Product Title',
                                    ),
                                    onSaved: (value) {
                                      _productTitle = value;
                                    },
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  key: ValueKey('Price \$'),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Price is missed';
                                    }
                                    return null;
                                  },
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: 'Price \$',
                                    //  prefixIcon: Icon(Icons.mail),
                                    // suffixIcon: Text(
                                    //   '\n \n \$',
                                    //   textAlign: TextAlign.start,
                                    // ),
                                  ),
                                  //obscureText: true,
                                  onSaved: (value) {
                                    _productPrice = double.parse(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          /* Image picker here ***********************************/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                //  flex: 2,
                                child: this._pickedImage == null
                                    ? Container(
                                        margin: EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.all(10),
                                        height: 200,
                                        width: 200,
                                        child: Container(
                                          height: 200,
                                          // width: 200,
                                          decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.only(
                                            //   topLeft: const Radius.circular(40.0),
                                            // ),
                                            color: Theme.of(context)
                                                .backgroundColor,
                                          ),
                                          child: Image.file(
                                            this._pickedImage,
                                            fit: BoxFit.contain,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FittedBox(
                                    // ignore: deprecated_member_use
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageCamera,
                                      icon: Icon(Icons.camera,
                                          color: Colors.purpleAccent),
                                      label: Text(
                                        'Camera',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    // ignore: deprecated_member_use
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _pickImageGallery,
                                      icon: Icon(Icons.image,
                                          color: Colors.purpleAccent),
                                      label: Text(
                                        'Gallery',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              // ignore: deprecated_member_use
                                              .textSelectionColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    // ignore: deprecated_member_use
                                    child: FlatButton.icon(
                                      textColor: Colors.white,
                                      onPressed: _removeImage,
                                      icon: Icon(
                                        Icons.remove_circle_rounded,
                                        color: Colors.red,
                                      ),
                                      label: Text(
                                        'Remove',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          //    SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: Container(
                                    child: TextFormField(
                                      controller: _categoryController,
                                      textInputAction: TextInputAction.next,
                                      key: ValueKey('Category'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a Category';
                                        }
                                        return null;
                                      },
                                      //keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Add a new Category',
                                      ),
                                      onSaved: (value) {
                                        _productCategory = value;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text('Phones'),
                                    value: 'Phones',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Clothes'),
                                    value: 'Clothes',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Beauty & health'),
                                    value: 'Beauty',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Shoes'),
                                    value: 'Shoes',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Funiture'),
                                    value: 'Funiture',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Watches'),
                                    value: 'Watches',
                                  ),
                                ],
                                onChanged: (String value) {
                                  setState(() {
                                    _categoryValue = value;
                                    _categoryController.text = value;
                                    //_controller.text= _productCategory;
                                    print(_productCategory);
                                  });
                                },
                                hint: Text('Select a Category'),
                                value: _categoryValue,
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: Container(
                                    child: TextFormField(
                                      controller: _brandController,
                                      textInputAction: TextInputAction.next,
                                      key: ValueKey('Brand'),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Brand is missed';
                                        }
                                        return null;
                                      },
                                      //keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: 'Brand',
                                      ),
                                      onSaved: (value) {
                                        _productBrand = value;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              DropdownButton<String>(
                                items: [
                                  DropdownMenuItem<String>(
                                    child: Text('Brandless'),
                                    value: 'Brandless',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Addidas'),
                                    value: 'Addidas',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Apple'),
                                    value: 'Apple',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Dell'),
                                    value: 'Dell',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('H&M'),
                                    value: 'H&M',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Nike'),
                                    value: 'Nike',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Samsung'),
                                    value: 'Samsung',
                                  ),
                                  DropdownMenuItem<String>(
                                    child: Text('Huawei'),
                                    value: 'Huawei',
                                  ),
                                ],
                                onChanged: (String value) {
                                  setState(() {
                                    _brandValue = value;
                                    _brandController.text = value;
                                    print(_productBrand);
                                  });
                                },
                                hint: Text('Select a Brand'),
                                value: _brandValue,
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              key: ValueKey('Description'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'product description is required';
                                }
                                return null;
                              },
                              //controller: this._controller,
                              maxLines: 10,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                //  counterText: charLength.toString(),
                                labelText: 'Description',
                                hintText: 'Product description',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _productDescription = value;
                              },
                              onChanged: (text) {
                                // setState(() => charLength -= text.length);
                              }),
                          //    SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                //flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 9),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    key: ValueKey('Quantity'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Quantity is missed';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Quantity',
                                    ),
                                    onSaved: (value) {
                                      _productQuantity = int.parse(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DropdownButton<bool>(
                            items: [
                              DropdownMenuItem<bool>(
                                child: Text('Yes'),
                                value: true,
                              ),
                              DropdownMenuItem<bool>(
                                child: Text('No'),
                                value: false,
                              ),
                            ],
                            onChanged: (bool value) {
                              setState(() {
                                _popularityValue = value;
                                _popularity = value;
                              });
                            },
                            hint: Text('Popularity'),
                            value: _popularityValue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
