import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final onChanged;
  final validator;
  final hintText;
  final onSave;
  final prefixIcon;
  final suffixIcon;
 final keyboardType;
  const TextFormFieldWidget({Key key,this.keyboardType, this.onChanged, this.validator, this.hintText, this.onSave, this.prefixIcon, this.suffixIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
          keyboardType:keyboardType,
          onChanged: onChanged,
          validator:validator,
          onSaved: onSave,

          cursorColor: const Color(0xff336699),
          // onChanged: ()=>,
          decoration: InputDecoration(
            // labelText: 'Email',
            labelStyle: TextStyle(
              color: const Color(0xff336699),
              fontSize: 12,
            ),
            hintText:hintText, //: str,
            hintStyle: TextStyle(
              color: Colors.black45,
              fontSize: 12,
            ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon
          )
        //  )
      ),
    );
  }
}
