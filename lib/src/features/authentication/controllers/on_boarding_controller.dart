
import 'package:everyday_chronicles/src/features/authentication/controllers/splash_screen_controller.dart';
import 'package:everyday_chronicles/src/features/authentication/screens/welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';

import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/text_strings.dart';
import '../models/model_on_boarding.dart';
import '../screens/on_boarding/on_boarding_page_widget.dart';

class OnBoardingController extends GetxController{

  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final pages = [
    OnBoardingPageWidget(
      boardingModel: OnBoardingModel(
        image: myOnBoardingImage1,
        title: myOnBoardingTitle1,
        subtitle: myOnBoardingSubTitle1,
        counterText: myOnBoardingCounter1,
        bgColor: Get.isDarkMode ? myOnBoardingPage1DarkColor : myOnBoardingPage1Color,
      ),
    ),
    OnBoardingPageWidget(
      boardingModel: OnBoardingModel(
        image: myOnBoardingImage2,
        title: myOnBoardingTitle2,
        subtitle: myOnBoardingSubTitle2,
        counterText: myOnBoardingCounter2,
        bgColor: Get.isDarkMode ? myOnBoardingPage2DarkColor : myOnBoardingPage2Color,
      ),
    ),
    OnBoardingPageWidget(
      boardingModel: OnBoardingModel(
        image: myOnBoardingImage3,
        title: myOnBoardingTitle3,
        subtitle: myOnBoardingSubTitle3,
        counterText: myOnBoardingCounter3,
        bgColor: Get.isDarkMode ? myOnBoardingPage3DarkColor : myOnBoardingPage3Color,
      ),
    ),
  ];

  onPageChangedCallBack(int activePageIndex) {
    currentPage.value = activePageIndex;
  }

  skip() => controller.jumpToPage(page: pages.length - 1);


  // animateToNextSlide(){
  //   int nextPage = controller.currentPage+1;
  //   controller.animateToPage(page: nextPage);
  // }

  openWelcomeScreen(){
   SplashScreenController.find.setOnboardingCompleted();
   Get.off( () => const WelcomeScreen());
  }

}