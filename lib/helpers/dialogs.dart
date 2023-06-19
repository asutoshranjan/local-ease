import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_ease/theme/app-theme.dart';
import 'package:local_ease/theme/colors.dart';
import 'package:local_ease/utils/sizeConfig.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


  static void showNotificationDialog(BuildContext context, String title, String description) {
    final alert = Stack(
      children: [
        AlertDialog(
          content: Container(
            height: SizeConfig.safeBlockVertical!*35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 33,
                ),
                Text(title, textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                Text(description, textAlign: TextAlign.center, style: textTheme.displaySmall!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.3),),
                const Spacer(),
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.safeBlockVertical!*24,
          left: SizeConfig.safeBlockHorizontal!*41,
          child: Container(
            height: SizeConfig.safeBlockHorizontal!*18,
            width: SizeConfig.safeBlockHorizontal!*18,
            decoration: BoxDecoration(
              color: AppColors.pink,
             borderRadius: BorderRadius.circular(SizeConfig.safeBlockHorizontal!*9),
              border: Border.all(width: 5, color: AppColors.white)
            ),
            child: Icon(Icons.notifications_active_outlined, color: AppColors.white, size: SizeConfig.safeBlockHorizontal!*6.5,),
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showOpenCloseDialog({required BuildContext context, required String title, required String description, required void Function() onBtnClk, required IconData icon} ) {
    final alert = Stack(
      children: [
        AlertDialog(
          content: Container(
            height: SizeConfig.safeBlockVertical!*35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 33,
                ),
                Text(title, textAlign: TextAlign.center,),
                const SizedBox(height: 5,),
                Text(description, textAlign: TextAlign.center, style: textTheme.displaySmall!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.3),),
                const Spacer(),
                TextButton(
                  onPressed: onBtnClk,
                  child: Text("Confirm"),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.safeBlockVertical!*24,
          left: SizeConfig.safeBlockHorizontal!*41,
          child: Container(
            height: SizeConfig.safeBlockHorizontal!*18,
            width: SizeConfig.safeBlockHorizontal!*18,
            decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(SizeConfig.safeBlockHorizontal!*9),
                border: Border.all(width: 5, color: AppColors.white)
            ),
            child: Icon(icon , color: AppColors.white, size: SizeConfig.safeBlockHorizontal!*6.5,),
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  static void notificationSentDialog({required BuildContext context,  required void Function() onBtnClk,} ) {
    final alert = Stack(
      children: [
        AlertDialog(
          content: Container(
            height: SizeConfig.safeBlockVertical!*35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 33,
                ),
                Text("Notification Sent", textAlign: TextAlign.center,),
                SizedBox(height: 5,),
                Text( "Successfully sent your notification to your subscribed users!", textAlign: TextAlign.center, style: textTheme.displaySmall!.copyWith(fontSize: SizeConfig.safeBlockHorizontal!*4.3),),
                Spacer(),
                TextButton(
                  onPressed: () {
                    onBtnClk();
                  },
                  child: Text("Okay"),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.safeBlockVertical!*24,
          left: SizeConfig.safeBlockHorizontal!*41,
          child: Container(
            height: SizeConfig.safeBlockHorizontal!*18,
            width: SizeConfig.safeBlockHorizontal!*18,
            decoration: BoxDecoration(
                color: AppColors.pink,
                borderRadius: BorderRadius.circular(SizeConfig.safeBlockHorizontal!*9),
                border: Border.all(width: 5, color: AppColors.white)
            ),
            child: Icon(Icons.notifications_active_outlined , color: AppColors.white, size: SizeConfig.safeBlockHorizontal!*6.5,),
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  static void showLoaderDialog(BuildContext context, String msg) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          SizedBox(width: SizeConfig.safeBlockHorizontal!*9,),
          Container(
              margin: EdgeInsets.only(left: 7),
              child: Text(
                msg,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.black54),
              ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}