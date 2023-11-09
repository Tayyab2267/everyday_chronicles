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
                  style: MyTextTheme.lightTextTheme.headline3),
              Text(boardingModel.subtitle, textAlign: TextAlign.center),
            ],
          ),
          Text(boardingModel.counterText,
              style: MyTextTheme.lightTextTheme.headline6),
          const SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
