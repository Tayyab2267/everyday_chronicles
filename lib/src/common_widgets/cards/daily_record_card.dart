
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class DailyRecordCard extends StatelessWidget {
  const DailyRecordCard({super.key,
    required this.color,
    required this.cardIcon,
    required this.cardTitle,
    required this.cardSubTitle,
    required this.cardDate,
    this.onTap,
  });

  final cardIcon;
  final color;
  final String cardTitle, cardSubTitle, cardDate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        elevation: 3, // Adjust the elevation value as needed
        shadowColor: Get.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    //color: myCardBackgroundLightColor, // This is the card background color
                    color: Get.isDarkMode ? myCardBackgroundDarkColor : myCardBackgroundLightColor, // This is the card Dark background color
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
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
                              child: Icon(
                                  cardIcon, size: 30, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              cardDate.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                            ),
                          ],
                        ),
                        VerticalDivider(
                          color: Get.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                          thickness: 2,
                          width: 20.0,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          // Wrap the Column with Expanded
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cardTitle,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headlineSmall,
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
        ),
      ),
    );
  }
}