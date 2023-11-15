import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class DailyRecordCard extends StatelessWidget {
  const DailyRecordCard({super.key,
  required this.color,
  required this.cardIcon,
  required this.cardTitle,
  required this.cardSubTitle,
  required this.cardDate
  });

  final cardIcon;
  final color;
  final String cardTitle, cardSubTitle, cardDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: myBackgroundLightColor,
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(cardIcon,
                              size: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          cardDate.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      // Wrap the Column with Expanded
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cardTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            cardSubTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}