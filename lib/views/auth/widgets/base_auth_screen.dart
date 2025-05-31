import 'package:flutter/material.dart';

/// A base screen widget for authentication pages (Login, Signup, Forgot Password, etc.).
///
/// It provides a common layout structure including a background image,
/// a logo, a title, and a content area for specific form fields.
/// It also handles keyboard visibility by adjusting the layout with animations.
class BaseAuthScreen extends StatefulWidget {
  /// The title displayed on the screen (e.g., "Login", "Sign Up").
  final String title; // Though not directly used in this version, it's good practice for a base class.

  /// The widget containing the specific form fields and buttons for the auth screen.
  final Widget formContent;

  /// The asset path for the background image.
  final String backgroundImagePath;

  /// An optional widget for displaying the logo (e.g., GomikoLogo).
  final Widget? logo;

  /// An optional widget for the text that appears below the logo and above the formContent.
  final Widget? headerTextWidget;

  /// An optional custom widget to be used as the scaffold body.
  /// If this is not null, `formContent`, `logo`, and `headerTextWidget` will be ignored.
  final Widget? customScaffold;

  const BaseAuthScreen({
    super.key,
    required this.title,
    required this.formContent,
    required this.backgroundImagePath,
    this.logo,
    this.headerTextWidget,
    this.customScaffold,
  });

  @override
  State<BaseAuthScreen> createState() => _BaseAuthScreenState();
}

class _BaseAuthScreenState extends State<BaseAuthScreen>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final keyboardOpenMultiplier = _isKeyboardVisible ? 0.1 : 0.25; // No longer used with these changes
    // final logoTopPaddingMultiplier = _isKeyboardVisible ? 0.05 : 0.1; // No longer used with these changes

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.backgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: widget.customScaffold ??
          Padding(
            padding: EdgeInsets.only(
              // Adjust overall padding when keyboard is visible to push content up
              bottom: _isKeyboardVisible ? MediaQuery.of(context).viewInsets.bottom : 20,
              left: 20,
              right: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Task 2: Centering
              children: <Widget>[
                // Task 3: Initial Top Padding (Above Logo)
                SizedBox(height: screenHeight > 800 ? screenHeight * 0.1 : 40.0),

                if (widget.logo != null)
                  AnimatedOpacity(
                    opacity: _isKeyboardVisible ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      height: screenHeight * 0.15,
                      child: FittedBox(child: widget.logo!),
                    )
                  ),

                // Task 4: Spacing between Logo and Header
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isKeyboardVisible ? 5.0 : 35.0,
                  curve: Curves.easeInOut,
                ),

                if (widget.headerTextWidget != null)
                  widget.headerTextWidget!, // Removed AnimatedPadding wrapper, direct display

                // Task 4: Spacing between Header and Form Content
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: _isKeyboardVisible ? 5.0 : 20.0,
                  curve: Curves.easeInOut,
                ),
                widget.formContent,
                SizedBox(height: screenHeight * 0.05), // Space at the bottom (can be adjusted if needed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
