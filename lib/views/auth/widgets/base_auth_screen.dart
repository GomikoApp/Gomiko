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
    final keyboardOpenMultiplier = _isKeyboardVisible ? 0.1 : 0.25;
    final logoTopPaddingMultiplier = _isKeyboardVisible ? 0.05 : 0.1;


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
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: screenHeight * (_isKeyboardVisible ? 0.05 : 0.15), // Smaller space above logo when keyboard is visible
                  curve: Curves.easeInOut,
                ),
                if (widget.logo != null)
                  AnimatedOpacity(
                    opacity: _isKeyboardVisible ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    // Removed AnimatedContainer wrapper, rely on Opacity and natural layout adjustment
                    child: SizedBox( // Use a SizedBox to give the logo a consistent space when visible
                      height: screenHeight * 0.15, // Standard height for the logo area
                      child: FittedBox(child: widget.logo!),
                    )
                  ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: screenHeight * (_isKeyboardVisible ? 0.02 : 0.05), // Space between logo and header text
                  curve: Curves.easeInOut,
                ),
                if (widget.headerTextWidget != null)
                  AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: _isKeyboardVisible ? 5.0 : 10.0),
                    child: widget.headerTextWidget!,
                  ),
                SizedBox(height: screenHeight * 0.03), // Space before form content
                widget.formContent,
                SizedBox(height: screenHeight * 0.05), // Space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
