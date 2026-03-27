import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class CustomFilterSortBtnWidget extends StatelessWidget {
  final IconData iconData;
  final String buttonName;
  final VoidCallback onTap;
  const CustomFilterSortBtnWidget({
    super.key,
    required this.iconData,
    required this.buttonName,
    required this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 6
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1.0
            )
        ),
        child: Row(
          children: [
            Icon(iconData, size: 18,),
            SizedBox(width: 5,),
            Text(buttonName),
            SizedBox(width: 5,),
            Icon(TablerIcons.chevron_down, size: 15,)
          ],
        ),
      ),
    );
  }
}
