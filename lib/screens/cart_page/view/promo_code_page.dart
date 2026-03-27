import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_event.dart';
import 'package:hyper_local/screens/cart_page/bloc/promo_code/promo_code_state.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/widgets/custom_toast.dart';
import '../bloc/promo_code/promo_code_bloc.dart';
import '../bloc/validate_promo_code/validate_promo_code_bloc.dart';
import '../widgets/coupon_card.dart';

class PromoCodePage extends StatefulWidget {
  final double? cartAmount;
  final double? deliveryCharges;
  const PromoCodePage({super.key, this.cartAmount, this.deliveryCharges});

  @override
  State<PromoCodePage> createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {

  @override
  void initState() {
    // TODO: implement initState
    context.read<PromoCodeBloc>().add(FetchPromoCode());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CustomScaffold(
      showViewCart: false,
      appBar: AppBar(
        title: Text(l10n?.promoCodeCoupons ?? 'Promo Code & Coupons'),
      ),
      body: BlocListener<ValidatePromoCodeBloc, ValidatePromoCodeState>(
        listener: (context, state) {
          if(state is ValidatePromoCodeLoading){
            // Show loading
          }
          if(state is ValidatePromoCodeLoaded){
            context.read<PromoCodeBloc>().add(SelectPromoCode(context.read<ValidatePromoCodeBloc>().selectedPromoCode));
            GoRouter.of(context).pop(context.read<ValidatePromoCodeBloc>().selectedPromoCode);
          }
          if(state is ValidatePromoCodeFailed){
            ToastManager.show(context: context, message: state.error, type: ToastType.error);
          }
        },
        child: BlocBuilder<PromoCodeBloc, PromoCodeState>(
          builder: (BuildContext context, PromoCodeState state) {
            if(state is PromoCodeLoaded) {
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: state.promoCodeData.length,
                    itemBuilder: (context, index){
                      final coupon = state.promoCodeData[index];
                      return BlocBuilder<ValidatePromoCodeBloc, ValidatePromoCodeState>(
                        builder: (context, validateState) {
                          bool isThisCouponLoading = false;
                          if(validateState is ValidatePromoCodeLoading &&
                              context.read<ValidatePromoCodeBloc>().selectedPromoCode == coupon.code){
                            isThisCouponLoading = true;
                          }

                          return CouponCard(
                            title: coupon.description ?? '',
                            subtitle: coupon.description ?? '',
                            couponCode: coupon.code ?? '',
                            isCollected: context.read<PromoCodeBloc>().selectedPromoCode == coupon.code,
                            isLoading: isThisCouponLoading,
                            onTap: (){
                              final code = coupon.code ?? '';
                              if(code.isNotEmpty){
                                 // Store selected code temporarily in bloc validtor
                                 context.read<ValidatePromoCodeBloc>().selectedPromoCode = code;
                                 context.read<ValidatePromoCodeBloc>().add(ValidatePromoCodeRequest(
                                   promoCode: code,
                                   cartAmount: widget.cartAmount?.toInt() ?? 0,
                                   deliveryCharges: widget.deliveryCharges?.toInt() ?? 0
                                 ));
                              }
                            },
                          );
                        }
                      );
                    }
                  ),
                ],
              );
            }
            return CustomCircularProgressIndicator();
          },
        ),
      )
    );
  }
}
