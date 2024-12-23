import 'package:agua_task/common_widgets/custom_icon_button.dart';
import 'package:agua_task/core/colors.dart';
import 'package:agua_task/core/common_enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final bool? enableBack;
  final String? appBarTitle;
  final bool isHome;
  final Function? onBackCalled;

  const CustomScaffold({super.key, required this.child, this.backgroundColor, this.enableBack, this.appBarTitle, this.isHome = false, this.onBackCalled});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? const Color.fromARGB(255, 215, 242, 252),
      appBar: enableBack == true
          ? AppBar(
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: CustomIconButton(
                  onTap: () {
                    GoRouter.of(context).pop();
                    onBackCalled?.call();
                  },
                  buttonColor: Colors.white54,
                  icon: Icons.arrow_back,
                  iconColor: ColorCode.colorList(context).customTextColor,
                ),
              ),
              title: (appBarTitle?.isEmpty == true || appBarTitle == null)
                  ? SizedBox.shrink()
                  : Text(
                      "$appBarTitle",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: ColorCode.colorList(context).customTextColor,
                          ),
                    ),
            )
          : null,
      body: SafeArea(child: child),
      floatingActionButton: isHome == false
          ? SizedBox.shrink()
          : Card(
              elevation: 5,
              shape: CircleBorder(),
              child: CustomIconButton(
                buttonSize: 55,
                buttonColor: ColorCode.colorList(context).bgColor,
                icon: Icons.add,
                iconColor: Colors.white,
                iconSize: 30,
                onTap: () {
                  context.pushNamed(RouteEnum.addTask.name);
                },
              ),
            ),
    );
  }
}
