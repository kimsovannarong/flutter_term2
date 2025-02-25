import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/theme/theme.dart';

class BlaInput extends StatelessWidget {
  final String labelText;
  final IconData iconForm;
  final VoidCallback onTap;
  final VoidCallback? onPressed;
  final IconData? iconSwitching;

  const BlaInput({
    super.key,
    required this.labelText,
    required this.iconForm,
    this.iconSwitching,
    required this.onTap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Open dialog when tapped
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: BlaColors.greyLight,
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(iconForm, color: BlaColors.iconLight),
          title: Text(
            labelText,
            style: TextStyle(color: BlaColors.neutralLight, fontSize: 16),
          ),
          trailing: iconSwitching != null
              ? IconButton(
                  onPressed: onPressed,
                  icon: Icon(iconSwitching, color: BlaColors.primary, size: 30),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
