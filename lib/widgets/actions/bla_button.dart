import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/theme/theme.dart';

class BlaButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  const BlaButton({super.key,required this.text,required this.onPressed,this.icon,this.isPrimary=true});

  @override
  Widget build(BuildContext context) {
    return isPrimary?
    // primary button if it is true
    ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(text,style: BlaTextStyles.button,),
      icon: icon!=null?Icon(icon, size: 18,color: BlaColors.white,) : const SizedBox(),
      style: ElevatedButton.styleFrom(
        foregroundColor: BlaColors.white, backgroundColor: BlaColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ):
    // secondary button if it is false
    OutlinedButton.icon(
      onPressed: onPressed,
      label: Text(text,style: BlaTextStyles.button,),
      icon: icon!=null?Icon(icon, size: 18,color: BlaColors.primary,) : const SizedBox(),
      style: ElevatedButton.styleFrom(
        foregroundColor: BlaColors.primary, backgroundColor: BlaColors.white,
        side: BorderSide(color: BlaColors.primary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}