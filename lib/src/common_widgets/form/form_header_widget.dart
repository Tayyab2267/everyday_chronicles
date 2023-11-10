import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({super.key,
    this.imageColor,
    this.heightBetween,
    this.textAlign,
    this.imageHeight = 0.2,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image, title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(
          image: AssetImage(image),
          height: size.height * 0.25,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: textAlign,
        ),
      ],
    );
  }
}