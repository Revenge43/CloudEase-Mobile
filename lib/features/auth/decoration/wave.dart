import 'package:flutter/material.dart';

class Wave extends StatelessWidget {
  const Wave({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: WaveClipper(),
          child: Container(
            color: Theme.of(context).primaryColor,
            height: 200,
          ),
        ),
        Positioned(
          top: 50, // You can adjust this value to position the text where you want
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'CloudEase',
              style: TextStyle(
                fontSize: 30, // Adjust the font size
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorLight, // Text color
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = Path();
    path.lineTo(0, 175);

    path.quadraticBezierTo(size.width * 0.25, size.height * 0.50 - 25,
        size.width * 0.50, size.height * 0.75);

    path.quadraticBezierTo(
        size.width * 0.75, size.height + 25, size.width, size.height * 0.75);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
