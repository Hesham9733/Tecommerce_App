import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldRe extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final String valueKey;
  final Function fctValid;
  final Function onEditCompleteFct;
  final TextInputType inputType;
  final Function onSavedFct;

  const TextFieldRe(
      {@required this.labelText,
      @required this.prefixIcon,
      @required this.valueKey,
      @required this.fctValid,
      @required this.inputType,
      @required this.onSavedFct,
      @required this.onEditCompleteFct});

  @override
  _TextFieldReState createState() => _TextFieldReState();
}

class _TextFieldReState extends State<TextFieldRe> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        key: ValueKey(widget.valueKey),
        validator: widget.fctValid,
        keyboardType: widget.inputType,
        onEditingComplete: widget.onEditCompleteFct,
        inputFormatters: widget.inputType == TextInputType.phone
            ? [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            filled: true,
            prefixIcon: Icon(widget.prefixIcon),
            labelText: widget.labelText,
            fillColor: Theme.of(context).backgroundColor),
        onSaved: widget.onSavedFct,
      ),
    );
  }
}

class TextFieldRePass extends StatefulWidget {
  final Function onEditCompleteFct;
  final Function onSavedFct;

  const TextFieldRePass(
      {@required this.onSavedFct, @required this.onEditCompleteFct});

  @override
  _TextFieldRePassState createState() => _TextFieldRePassState();
}

class _TextFieldRePassState extends State<TextFieldRePass> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        obscureText: _obscureText,
        textInputAction: TextInputAction.next,
        key: ValueKey('password'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a valid password';
          }
          return null;
        },
        keyboardType: TextInputType.visiblePassword,
        onEditingComplete: widget.onEditCompleteFct,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            filled: true,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            ),
            labelText: 'Password',
            fillColor: Theme.of(context).backgroundColor),
        onSaved: widget.onSavedFct,
      ),
    );
  }
}
