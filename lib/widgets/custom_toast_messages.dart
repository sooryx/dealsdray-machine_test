
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

customSuccessToast(BuildContext context, String message) {
  toastification.show(
    context: context,
    title: Text(message),
    animationDuration: const Duration(milliseconds: 300),
    autoCloseDuration: const Duration(seconds: 2),
    style: ToastificationStyle.minimal,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.success,
    showProgressBar: true,
    borderRadius: BorderRadius.circular(30),
    margin: const EdgeInsets.symmetric(horizontal: 50),
    dragToClose: true,
    closeButtonShowType: CloseButtonShowType.always,
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

customErrorToast(BuildContext context, String message) {
  toastification.show(
    context: context,
    applyBlurEffect: false,
    title: Text(message),
    animationDuration: const Duration(milliseconds: 300),
    autoCloseDuration: const Duration(seconds: 2),
    style: ToastificationStyle.minimal,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.error,
    showProgressBar: true,
    borderRadius: BorderRadius.circular(30.r),
    margin: EdgeInsets.symmetric(horizontal: 50.w),
    dragToClose: true,
    closeButtonShowType: CloseButtonShowType.always,
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

customRandomToast(BuildContext context, String message) {
  toastification.show(
    context: context,
    title: Text(message),
    animationDuration: const Duration(milliseconds: 300),
    autoCloseDuration: const Duration(seconds: 2),
    style: ToastificationStyle.minimal,
    alignment: Alignment.bottomCenter,
    type: ToastificationType.info,
    showProgressBar: true,
    borderRadius: BorderRadius.circular(30.r),
    margin: EdgeInsets.symmetric(horizontal: 50.w),
    dragToClose: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    animationBuilder: (context, animation, alignment, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

customSnackBar(String text,TextStyle? textstyle) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,closeIconColor: Colors.red,
    dismissDirection: DismissDirection.down,
    backgroundColor: Colors.grey.withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
    content: Text(text,style: textstyle,),
  );
}






  void showCustomDialog({
    required BuildContext context,
    required String title,
    String? okbutton,
    String? cancelbutton,
    required String contentText1,
    required VoidCallback onCancel,
    required VoidCallback onConfirm,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 10,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.sp),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  Icons.help,
                  color: Theme.of(context).primaryColor,
                  size: 60.sp,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  contentText1,
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                onCancel();
                Navigator.pop(context);
              },
              child: Container(
                width: 120.w,

                padding: EdgeInsets.all(10.dg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    width: 2.w, color:Theme.of(context).primaryColor,),
                ),
                child: Center(child: Text(cancelbutton ?? "Cancel")),
              ),
            ),
            InkWell(
              onTap: ()  {
                onConfirm();
              },
              child: Container(
                width: 120.w,
                padding: EdgeInsets.all(10.dg),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    width: 5.w, color: Theme.of(context).primaryColor,),
                ),
                child:  Center(child: Text(okbutton ?? "Ok")),
              ),
            ),
          ],
        );
      },
    );
  }
