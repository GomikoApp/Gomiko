// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LSUtilities {
  static const Color textColor = Color(0xFF98CB51);

  static final RegExp _emailRegex = RegExp(
      r'[a-zA-Z0-9.!#$%&’+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:.[a-zA-Z0-9-]+)(.[a-zA-Z0-9-]+)');

  /// Returns the RegEx used for email input validation by the Login/Signup Pages
  RegExp get emailRegex => _emailRegex;

  static final RegExp _passwordRegex =
      RegExp(r"[a-zA-Z0-9.!#@$%&’*+/=?^_`{|}~-]");

  /// Returns the RegEx used for password input validation by the Login/Signup Pages
  RegExp get passwordRegex => _passwordRegex;

  static const int _passwordMinLength = 5;
  int get passwordMinLength => _passwordMinLength;

  static const int _passwordMaxLength = 32;
  int get passwordMaxLength => _passwordMaxLength;

  /// A prebuilt function to validate an email form used in a [GomikoTextField].
  ///
  /// It checks two things: Whether the [email] was supplied and if it matches the correct email format [RegExp].
  static String? emailFormValidator({String? email}) {
    if (email == null ||
        email.isEmpty ||
        !LSUtilities._emailRegex.hasMatch(email)) {
      return "Please enter a valid email";
    }

    return null;
  }

  /// A prebuilt function to validate a password form used in a [GomikoTextField].
  ///
  /// It checks two things: Whether the [password] was supplied and if it is of the length in the range supplied by
  /// [passwordLengthMinimum] - [passwordLengthMinimum].
  static String? passwordFormValidator(
      {String? password,
      int minLength = LSUtilities._passwordMinLength,
      int maxLength = LSUtilities._passwordMaxLength}) {
    if (password == null || password.isEmpty) {
      return "Your password must not be empty.";
    }

    // NOTE: we use String.characters.length because complex characters will only count as one instead of
    // the >1 value that String.length can give.
    if (password.characters.length < minLength ||
        password.characters.length > maxLength) {
      return "Your password must contain $minLength-$maxLength characters.";
    }

    return null;
  }
}

/// A [TextFormField] used in the login/signup page sequence.
class GomikoTextFormField extends StatelessWidget {
  /// Creates a [GomikoTextFormField].
  const GomikoTextFormField({
    Key? key,
    required this.hintText,
    this.hintColor = Colors.lightGreen,
    this.icon,
    this.iconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.controller,
    this.validator,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  /// [Text] that displays in the [TextField].
  final String hintText;

  /// [Color] of the hint's text, default black.
  final Color? hintColor;

  /// [Icon] that shows on the left side of the [TextField]. If not supplied, there will be none instead.
  final Icon? icon;

  /// The [Icon]'s [Color].
  final Color? iconColor;

  /// [Icon] that shows on the right side of the [TextField]. If not supplied, there will be none instead.
  final Icon? suffixIcon;

  /// The [SuffixIcon]'s [Color].
  final Color? suffixIconColor;

  /// An optional [TextEditingController].
  final TextEditingController? controller;

  /// An optional function that acts as its validator. If using [Form.key.currentState.validate()], you will need this.
  final String? Function(String?)? validator;

  /// An optional [List] of [TextInputFormatter].
  final List<TextInputFormatter>? inputFormatters;

  /// An optional argument to supply a different [AutovalidateMode]. Default is [AutovalidateMode.onUserInteraction].
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor: iconColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        suffixIcon: suffixIcon,
      ),
      controller: controller,
      // Validate string
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
    );
  }
}

/// A [TextFormField] used specifically for emails in the login/signup page sequence.
class GomikoEmailTextFormField extends StatelessWidget {
  /// Creates a [GomikoEmailTextFormField].
  GomikoEmailTextFormField({
    Key? key,
    required this.hintText,
    this.hintColor = Colors.lightGreen,
    this.iconColor,
    this.suffixIcon,
    this.suffixIconColor,
    this.controller,
    this.validator,
    List<TextInputFormatter>? inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key) {
    if (inputFormatters != null && inputFormatters.isNotEmpty) {
      for (var formatter in inputFormatters) {
        this.inputFormatters.add(formatter);
      }
    }
  }

  /// [Text] that displays in the [TextField].
  final String hintText;

  /// [Color] of the hint's text, default black.
  final Color? hintColor;

  /// The [Icon]'s [Color].
  final Color? iconColor;

  /// [Icon] that shows on the right side of the [TextField]. If not supplied, there will be none instead.
  final Icon? suffixIcon;

  /// The [SuffixIcon]'s [Color].
  final Color? suffixIconColor;

  /// An optional [TextEditingController].
  final TextEditingController? controller;

  /// An optional function that acts as its validator. If using [Form.key.currentState.validate()], you will need this.
  final String? Function(String?)? validator;

  /// An optional [List] of [TextInputFormatter].
  final List<TextInputFormatter> inputFormatters = <TextInputFormatter>[];

  /// An optional argument to supply a different [AutovalidateMode]. Default is [AutovalidateMode.onUserInteraction].
  final AutovalidateMode autovalidateMode;

  String _currentEmail = '';
  String get currentEmail => _currentEmail;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        // save for sign up screen
        // enabledBorder: const OutlineInputBorder(
        //   borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 2.0),
        //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // ),
        // focusedBorder: const OutlineInputBorder(
        //   borderSide: BorderSide(color: Color(0xFF98CB51), width: 2.0),
        //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // ),
        // focusedErrorBorder: const OutlineInputBorder(
        //   borderSide: BorderSide(color: Color(0xFFF08181), width: 2.0),
        //   borderRadius: BorderRadius.all(Radius.circular(15.0)),
        // ),

        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        prefixIcon: const Icon(Icons.email_outlined),
        prefixIconColor: iconColor,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
        ),
        suffixIcon: suffixIcon,
      ),
      onChanged: (String value) {
        _currentEmail = value;
      },
      controller: controller,
      // Validate string
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
    );
  }
}

/// A [TextFormField] used specifically for emails in the login/signup page sequence.
class GomikoPasswordTextFormField extends StatelessWidget {
  /// Creates a [GomikoPasswordTextFormField].
  ///
  /// NOTE: When using these, your form must pre-initialize them to grab the password correctly or else it grabs
  /// all the asterisks for a authentication.
  GomikoPasswordTextFormField({
    Key? key,
    required this.hintText,
    this.hintColor = Colors.lightGreen,
    this.iconColor,
    this.suffixIcon,
    this.suffixIconColor,
    required this.controller,
    this.validator,
    List<TextInputFormatter>? inputFormatters,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.passwordMaximum = LSUtilities._passwordMaxLength,
  }) : super(key: key) {
    if (inputFormatters != null && inputFormatters.isNotEmpty) {
      for (var formatter in inputFormatters) {
        this.inputFormatters.add(formatter);
      }
    }
  }

  /// [Text] that displays in the [TextField].
  final String hintText;

  /// [Color] of the hint's text, default black.
  final Color? hintColor;

  /// The [Icon]'s [Color].
  final Color? iconColor;

  /// [Icon] that shows on the right side of the [TextField]. If not supplied, there will be none instead.
  final Icon? suffixIcon;

  /// The [SuffixIcon]'s [Color].
  final Color? suffixIconColor;

  /// An optional [TextEditingController].
  final TextEditingController controller;

  /// An optional function that acts as its validator. If using [Form.key.currentState.validate()], you will need this.
  final String? Function(String?)? validator;

  /// An optional [List] of [TextInputFormatter].
  late final List<TextInputFormatter> inputFormatters = <TextInputFormatter>[
    LengthLimitingTextInputFormatter(passwordMaximum),
    FilteringTextInputFormatter.allow(LSUtilities._passwordRegex)
  ];

  /// An optional argument to supply a different [AutovalidateMode]. Default is [AutovalidateMode.onUserInteraction].
  final AutovalidateMode autovalidateMode;

  /// Maximum length of password allowed to be typed by the user.
  final int passwordMaximum;

  String _currentPassword = '';
  String get currentPassword => _currentPassword;
  String obscuredText = '';
  bool showingPassword = false;

  @override
  Widget build(BuildContext context) {
    final showPasswordButton = IconButton(
        onPressed: () {
          if (!showingPassword) {
            obscuredText =
                _currentPassword.replaceAll(LSUtilities._passwordRegex, '*');
            controller.text = _currentPassword;
          } else {
            controller.text = obscuredText;
          }

          showingPassword = !showingPassword;
        },
        icon: const Icon(Icons.remove_red_eye_outlined));

    return TextFormField(
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE6E6E6), width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        prefixIconColor: iconColor,
        suffixIcon: showPasswordButton,
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintColor,
        ),
      ),
      controller: controller,
      onChanged: (String value) {
        int valueLength = value.characters.length;
        // When inputting characters, save the new character to the password, then hide the other characters
        // Adding character
        if (valueLength > _currentPassword.characters.length) {
          // Add last character to password field
          _currentPassword += value[valueLength - 1];
          if (valueLength > 1) {
            // Obscure all characters except the last inputted one with asterisks.
            // Also, move the pointer to the new spot.
            controller.text = '*' * (valueLength - 1) + value[valueLength - 1];
          }
        }
        // When deleting characters, delete the last character from the current password.
        else if (valueLength < _currentPassword.characters.length) {
          _currentPassword =
              _currentPassword.substring(0, _currentPassword.length - 1);
        }
      },
      // Validate string
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: autovalidateMode,
    );
  }
}

/// A big, green button used in the login/signup sequence as the main button
class GomikoMainActionButton extends StatelessWidget {
  /// Creates a [GomikoMainActionButton]
  const GomikoMainActionButton({
    Key? key,
    required this.labelText,
    required this.onPressed,
    this.buttonSize,
  }) : super(key: key);

  /// String that appears in the [Text] widget that is generated as a child of the button.
  final String labelText;

  /// Required [onPressed] function.
  final void Function() onPressed;

  /// Size of the button.
  final double? buttonSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        foregroundColor: Colors.black,
        backgroundColor: const Color(0xFF98CB51),
        minimumSize: const Size(300, 60),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        shadowColor: Colors.black,
        elevation: 5,
      ),
      child: Text(
        labelText,
        style: const TextStyle(
          fontSize: 16, 
          fontWeight: FontWeight.w500
        )
      ),
    );
  }
}

/// A Cupertino-style link for our app.
class GomikoLink extends StatelessWidget {
  /// Creates a [GomikoLink]
  const GomikoLink({
    Key? key,
    required this.label,
    this.labelSize,
    this.labelColor,
    this.labelWeight = FontWeight.w500,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }) : super(key: key);

  /// Text to be displayed in the [GomikoLink].
  final String label;

  /// The text label's [FontSize]. Defaults to 14.
  final double? labelSize;

  /// The text label's [Color]. Defaults to LSUtilities.textColor, which is a light green.
  final Color? labelColor;

  /// The text label's [FontWeight].
  final FontWeight labelWeight;

  /// Action to perform on single-tap.
  final void Function()? onTap;

  /// Action to perform on double-tap.
  final void Function()? onDoubleTap;

  /// Action to perform on long-press.
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    const linkColor = LSUtilities.textColor;
    final effectiveLabelColor = labelColor ?? linkColor;

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Text(
        label,
        style: TextStyle(
          fontSize: labelSize,
          color: effectiveLabelColor,
          fontWeight: labelWeight,
        )
      ),
    );
  }
}

/// A [Row] that contains a regular text and [GomikoLink] side by side.
/// Used for things such as the "Already have an account? Login" text on the starting page.
class GomikoContextLinkRow extends StatelessWidget {
  const GomikoContextLinkRow({
    Key? key,
    required this.contextLabel,
    required this.linkLabel,
    this.contextSize,
    this.contextColor,
    this.contextWeight = FontWeight.w500,
    this.linkSize = 14,
    this.linkColor,
    this.linkWeight = FontWeight.w500,
    this.gapWidth = 5,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }) : super(key: key);

  /// String of text for the context [Text] on the left portion of the [Row].
  final String contextLabel;

  /// String of text for the [GomikoLink] on the right portion of the [Row].
  final String linkLabel;

  /// Size of the string of text for the [Text] on the left portion of the [Row].
  final double? contextSize;

  /// [Color] for the [Text] on the left portion of the [Row].
  final Color? contextColor;

   /// [FontWeight] for the [GomikoLink] on the right portion of the [Row]. Defaults to [FontWeight.w500]
  final FontWeight? contextWeight;

  /// Size of the string of text for the [GomikoLink] on the right portion of the [Row].
  final double? linkSize;

  /// [Color] for the [GomikoLink] on the right portion of the [Row].
  final Color? linkColor;
  
  /// [FontWeight] for the [GomikoLink] on the right portion of the [Row]. Defaults to [FontWeight.w500]
  final FontWeight linkWeight;

  /// Amount of space in between the context [Text] and [GomikoLink].
  final double gapWidth;

  /// Action to perform on single-tap.
  final void Function()? onTap;

  /// Action to perform on double-tap.
  final void Function()? onDoubleTap;

  /// Action to perform on long-press.
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      // NOTE:This might limit some styling by the designers in the future.
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          contextLabel,
          style: TextStyle(
            color: contextColor,
            fontSize: contextSize,
            fontWeight: contextWeight,
            ),
        ),
        SizedBox(width: gapWidth),
        GomikoLink(
          label: linkLabel,
          labelSize: linkSize,
          labelColor: linkColor,
          labelWeight: linkWeight,
          onTap: onTap,
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPress,
        )
      ],
    );
  }
}

/// A [Divider] with [Text] in the middle used as the context divider for items below it.
class GomikoTextDivider extends StatelessWidget {
  const GomikoTextDivider({
    Key? key,
    required this.label,
    this.labelSize,
    this.height,
    this.color,
    this.thickness = 1.5,
    this.leftIndent,
    this.leftEndIndent,
    this.rightIndent,
    this.rightEndIndent,
  }) : super(key: key);

  /// String of Text for the [GomikoTextDivider].
  final String label;

  /// [FontSize] of the label [Text].
  final double? labelSize;

  /// The divider's height extent.
  ///
  /// The divider itself is always drawn as a horizontal line that is centered within the height specified by this value.
  ///
  /// If this is null, then the [DividerThemeData.space] is used. If that is also null, then this defaults to 16.0.
  final double? height;

  /// The divider's color.
  final Color? color;

  /// The thickness of the line drawn within the divider.
  ///
  /// A divider with a [thickness] of 0.0 is always drawn as a line with a height of exactly one device pixel.
  ///
  /// If this is null, then the [DividerThemeData.thickness] is used. If that is also null, then this defaults to 0.0.
  final double? thickness;

  /// Amount of empty space leading up to the left [Divider].
  ///
  /// If this is null, then the [DividerThemeData.indent] is used. If that is also null, then this defaults to 0.0.
  final double? leftIndent;

  /// Amount of empty space after the left [Divider].
  ///
  /// If this is null, then the [DividerThemeData.endIndent] is used. If that is also null, then this defaults to 0.0.
  final double? leftEndIndent;

  /// Amount of empty space leading up to the right [Divider].
  ///
  /// If this is null, then the [DividerThemeData.indent] is used. If that is also null, then this defaults to 0.0.
  final double? rightIndent;

  /// Amount of empty space after the right [Divider].
  ///
  /// If this is null, then the [DividerThemeData.endIndent] is used. If that is also null, then this defaults to 0.0.
  final double? rightEndIndent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              height: height,
              thickness: thickness,
              indent: leftIndent,
              endIndent: leftEndIndent,
              color: color,
            ),
          )
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: labelSize,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              height: height,
              thickness: thickness,
              indent: rightIndent,
              endIndent: rightEndIndent,
              color: color,
            ),
          )
        )
      ],
    );
  }
}
