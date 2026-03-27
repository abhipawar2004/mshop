import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/utils/widgets/custom_image_container.dart';
import '../../l10n/app_localizations.dart';

import 'custom_button.dart';

class EmptyStatePage extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback? onRetry;

  const EmptyStatePage({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration (replace with Image.asset(imageAsset) for real images)
              Container(
                height: 200,
                // width: 250,
                decoration: BoxDecoration(
                  // color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: CustomImageContainer(imagePath:  imageAsset),
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8),
              // Text(
              //   description,
              //   style: Theme.of(context).textTheme.bodyMedium,
              //   textAlign: TextAlign.center,
              // ),
              if (onRetry != null) ...[
                const SizedBox(height: 10),
                CustomButton(
                  onPressed: onRetry!,
                  child: Text(l10n?.retry ?? 'Retry'),
                ),
              ],
            ],
          ),

      ),
    );
  }
}

class EmptyStatePageOnLocation extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback? onRetry;

  const EmptyStatePageOnLocation({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration (replace with Image.asset(imageAsset) for real images)
            Container(
              height: 110,
              // width: 250,
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomImageContainer(imagePath:  imageAsset),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              CustomButton(
                onPressed: onRetry!,
                child: Text(l10n?.changeLocation ?? 'Change Location'),
              ),
            ],
          ],
        ),

      ),
    );
  }
}

// class NoDeliveryLocationStatePage extends StatelessWidget {
//   final String title;
//   final String description;
//   final String imageAsset;
//   final VoidCallback? onRetry;
//
//   const NoDeliveryLocationStatePage({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.imageAsset,
//     this.onRetry,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Container(
//       color: Theme.of(context).colorScheme.surface,
//       child: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Illustration (replace with Image.asset(imageAsset) for real images)
//             Container(
//               height: 200,
//               // width: 250,
//               decoration: BoxDecoration(
//                 // color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: CustomImageContainer(imagePath:  imageAsset),
//             ),
//             SizedBox(height: 10),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             SizedBox(height: 8),
//             // Text(
//             //   description,
//             //   style: Theme.of(context).textTheme.bodyMedium,
//             //   textAlign: TextAlign.center,
//             // ),
//             if (onRetry != null) ...[
//               const SizedBox(height: 10),
//               CustomButton(
//                 onPressed: onRetry!,
//                 child: Text(l10n?.retry ?? 'Retry'),
//               ),
//             ],
//           ],
//         ),
//
//       ),
//     );
//   }
// }

// Specific pages
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noInternetConnection ?? 'No Internet Connection',
      description: l10n?.checkConnectionAndTryAgain ?? 'Please check your connection and try again.',
      imageAsset: 'assets/images/empty-states/no-internet-connection.png', // Placeholder asset
      onRetry: () => Navigator.pop(context),
    );
  }
}

class MaintenancePage extends StatelessWidget {
  final VoidCallback? onRetry;
  const MaintenancePage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.appUnderMaintenance ?? 'App Under Maintenance',
      description: l10n?.weWillBeBackSoon ?? 'We\'ll be back soon. Hang tight!',
      imageAsset: 'assets/images/empty-states/app-under-maintenance.png',
      onRetry: onRetry ?? () => Navigator.pop(context),
    );
  }
}

class NoOrderPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoOrderPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noOrderFound ?? 'No Order Found',
      description: l10n?.noOrdersYetDescription ?? 'It looks like you don\'t have any orders yet.',
      imageAsset: 'assets/images/empty-states/no-product-found.png',
      onRetry: onRetry ?? () => Navigator.pop(context),
    );
  }
}

class NoCategoryPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoCategoryPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noCategoryFound ?? 'No Category Found',
      description: l10n?.weCouldntFindAnyCategories ?? 'We couldn\'t find any categories.',
      imageAsset: 'assets/images/empty-states/no-product-found.png',
      onRetry: onRetry,
    );
  }
}

class NoSearchPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoSearchPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noSearchResults ?? 'No Search Results',
      description: l10n?.tryAdjustingSearchTerms ?? 'Try adjusting your search terms.',
      imageAsset: 'assets/images/empty-states/no-search-results.png',
      onRetry: onRetry,
    );
  }
}

class NoProductPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoProductPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noProductFound ?? 'No Product Found',
      description: l10n?.noProductMatchingSearch ?? 'We couldn\'t find any products matching your search.',
      imageAsset: 'assets/images/empty-states/no-product-found.png',
      onRetry: onRetry,
    );
  }
}

class NoStorePage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoStorePage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePage(
      title: l10n?.noStoreFound ?? 'No Store Found',
      description: l10n?.weCouldntFindAnyStoreInYourSelectLocation ?? 'We couldn\'t find any store in your select location.',
      imageAsset: 'assets/images/empty-states/no-product-found.png',
      onRetry: onRetry,
    );
  }
}

class NoDeliveryLocationPage extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoDeliveryLocationPage({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return EmptyStatePageOnLocation(
      title: l10n?.wereNotHereYet ?? 'We’re not here yet',
      description: l10n?.noStoresOrProductsAreAvailableInThisAreaRightNow ?? 'No stores or products are available in this area right now.',
      imageAsset: 'assets/images/icons/delivery_pin.png',
      onRetry: onRetry,
    );
  }
}