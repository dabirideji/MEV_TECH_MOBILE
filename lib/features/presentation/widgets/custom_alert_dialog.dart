import 'package:flutter/material.dart';
import 'package:template/core/utils/colors.dart';

// class CustomAlertDialog extends StatelessWidget {
//   const CustomAlertDialog({
//     required this.title,
//     required this.message,
//     required this.onCancel,
//     required this.onConfirm,
//     super.key,
//     this.cancelText = 'Cancel',
//     this.confirmText = 'Confirm',
//   });
//   final String title;
//   final String message;
//   final String cancelText;
//   final String confirmText;
//   final VoidCallback onCancel;
//   final VoidCallback onConfirm;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: contentBox(context),
//     );
//   }

//   Widget contentBox(BuildContext context) {
//     return Container(
//       width: 280, // Compact width
//       padding: const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         // shape: BoxShape.rectangle,
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0, 10),
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             message,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.black54,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: onCancel,
//                 child: Text(
//                   cancelText,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               ElevatedButton(
//                 onPressed: onConfirm,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                   ),
//                 ),
//                 child: Text(
//                   confirmText,
//                   style: const TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class AnimatedAlertDialog extends StatefulWidget {
  const AnimatedAlertDialog({
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
    super.key,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.alignment,
  });
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final AlignmentGeometry? alignment;

  @override
  _AnimatedAlertDialogState createState() => _AnimatedAlertDialogState();
}

class _AnimatedAlertDialogState extends State<AnimatedAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          alignment: widget.alignment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: 280, // Compact width
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        color: AppColor.primaryLight2,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedButton(
                text: widget.cancelText,
                onPressed: widget.onCancel,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              AnimatedButton(
                text: widget.confirmText,
                onPressed: widget.onConfirm,
                color: AppColor.primary,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    required this.text,
    required this.onPressed,
    required this.color,
    super.key,
    this.isPrimary = false,
  });
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isPrimary;

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: widget.isPrimary ? widget.color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: widget.color, width: 0.5),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 12,
              color: widget.isPrimary ? Colors.white : widget.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
/*
// void showAnimatedAlert(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AnimatedAlertDialog(
//         title: 'Confirm Action',
//         message: 'Are you sure you want to proceed with this action?',
//         cancelText: 'No',
//         confirmText: 'Yes',
//         onCancel: () {
//           Navigator.of(context).pop();
//         },
//         onConfirm: () {
//           Navigator.of(context).pop();
//           print('Confirmed!');
//         },
//       );
//     },
//   );
// }
*/

class AnimatedSlideAlertDialog extends StatefulWidget {
  const AnimatedSlideAlertDialog({
    required this.title,
    required this.message,
    required this.onCancel,
    required this.onConfirm,
    super.key,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.icon = Icons.info_outline,
  });
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final IconData icon;

  @override
  _AnimatedSlideAlertDialogState createState() =>
      _AnimatedSlideAlertDialogState();
}

class _AnimatedSlideAlertDialogState extends State<AnimatedSlideAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: 280, // Compact width
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        gradient: const LinearGradient(
          colors: [AppColor.primaryLight2, AppColor.primaryFaint],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            widget.icon,
            size: 40,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(height: 12),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AnimatedButton(
                text: widget.cancelText,
                onPressed: widget.onCancel,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              AnimatedButton(
                text: widget.confirmText,
                onPressed: widget.onConfirm,
                color: Colors.amber,
                isPrimary: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnimatedButtonSlide extends StatefulWidget {
  const AnimatedButtonSlide({
    required this.text,
    required this.onPressed,
    required this.color,
    super.key,
    this.isPrimary = false,
  });
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isPrimary;

  @override
  _AnimatedButtonSlideState createState() => _AnimatedButtonSlideState();
}

class _AnimatedButtonSlideState extends State<AnimatedButtonSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isPrimary ? widget.color : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: widget.isPrimary
                ? null
                : Border.all(color: widget.color, width: 1.5),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              color: widget.isPrimary
                  ? Colors.black87
                  : widget.color.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
/*
void showAnimatedSlideAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AnimatedSlideAlertDialog(
        title: 'Confirm Action',
        message: 'Are you sure you want to proceed with this action?',
        cancelText: 'No',
        confirmText: 'Yes',
        icon: Icons.warning_amber_rounded,
        onCancel: () {
          Navigator.of(context).pop();
        },
        onConfirm: () {
          Navigator.of(context).pop();
          print('Confirmed!');
        },
      );
    },
  );
}
*/

class CustomAlertDialogue extends StatefulWidget {
  const CustomAlertDialogue({
    required this.message,
    super.key,
    // this.alignment,
  });

  final String message;

  // final AlignmentGeometry? alignment;

  @override
  _CustomAlertDialogueState createState() => _CustomAlertDialogueState();
}

class _CustomAlertDialogueState extends State<CustomAlertDialogue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          // alignment: widget.alignment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
      ),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: 280, // Compact width
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 10),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 12),
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
