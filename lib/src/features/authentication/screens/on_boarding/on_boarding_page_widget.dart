import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../utils/theme/widget_themes/text_theme.dart';
import '../../models/model_on_boarding.dart';

class OnBoardingPageWidget extends StatelessWidget {
  const OnBoardingPageWidget({super.key, required this.boardingModel});

  final OnBoardingModel boardingModel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(myDefaultSize),
      color: boardingModel.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
              image: AssetImage(boardingModel.image),
              height: size.height * 0.4),
          Column(
            children: [
              Text(boardingModel.title,
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(boardingModel.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
          Text(boardingModel.counterText,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
