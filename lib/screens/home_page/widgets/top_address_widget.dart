import 'package:flutter/material.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import '../../../model/user_location/user_location_model.dart';
import 'location_bottom_sheet.dart';

class TopAddressWidget extends StatefulWidget {
  final Color textColor;
  const TopAddressWidget({super.key, required this.textColor});

  @override
  State<TopAddressWidget> createState() => _TopAddressWidgetState();
}

class _TopAddressWidgetState extends State<TopAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<UserLocation>('userLocationBox').listenable(),
      builder: (context, Box<UserLocation> box, _) {
        box.get('user_location');
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: LocationBottomSheet()),
                    ],
                  ),
                );
              },
              child: CustomButton(
                child: Text(AppLocalizations.of(context)!.dataPlaceholder),
              ),
            ),
            // Uncomment if you need the AnimatedOpacity section
            /*AnimatedOpacity(
              opacity: _appBarOpacity,
              duration: Duration(milliseconds: 200),
              child: Visibility(
                visible: !_isBodyAtTop,
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(HeroiconsSolid.user),
                ),
              ),
            ),*/
          ],
        );
      },
    );
  }
}
