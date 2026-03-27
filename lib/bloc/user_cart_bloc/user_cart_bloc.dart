import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_event.dart';
import 'package:hyper_local/bloc/user_cart_bloc/user_cart_state.dart';

import '../../config/global.dart';
import '../../model/user_cart_model/cart_sync_action.dart';
import '../../screens/cart_page/bloc/get_user_cart/get_user_cart_bloc.dart';
import '../../services/user_cart/user_cart_local.dart';
import '../../services/user_cart/user_cart_remote.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartLocalRepository localRepo;
  final CartRemoteRepository remoteRepo;

  Timer? _debounce;

  CartBloc(this.localRepo, this.remoteRepo)
      : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateCartQty>(_onUpdateQty);
    on<RemoveFromCart>(_onRemoveItem);
    on<RemoveLocally>(_onRemoveLocally);
    on<ClearCart>(_onClearCart);
    on<SyncLocalCart>(_onSyncLocalCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    emit(CartLoaded(localRepo.getAllItems()));
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    debugPrint('ADD → ${event.item.productId} ${event.item.variantId}');
    final bool isLoggedIn = Global.userData != null && Global.token!.isNotEmpty;
    
    if (isLoggedIn) {
      // Normal behavior: mark for sync
      localRepo.addItem(event.item); // this sets syncAction.add
      _debouncedSync(
        context:  event.context,
        addressId: event.addressId,
        promoCode: event.promoCode,
        rushDelivery: event.rushDelivery,
        useWallet: event.useWallet,
        isFromCartPage: event.isFromCartPage,
      );
    } else {
      // Guest mode: add locally but DO NOT mark for sync
      localRepo.addItemGuest(event.item); // New method → see below
      // Do NOT call _debouncedSync
    }

    emit(CartLoaded(localRepo.getAllItems()));
  }

  void _onUpdateQty(UpdateCartQty event, Emitter<CartState> emit) {
    emit(CartLoading());
    log('Update Quantity');
    final bool isLoggedIn = Global.userData != null;

    if (isLoggedIn) {
      // Normal logged-in flow
      localRepo.updateQuantity(event.cartKey, event.quantity);
      _debouncedSync(
          context:  event.context,
        addressId: event.addressId,
        promoCode: event.promoCode,
        rushDelivery: event.rushDelivery,
        useWallet: event.useWallet,
        isFromCartPage: event.isFromCartPage,
      );
    } else {
      // Guest mode: update locally only
      localRepo.updateQuantityGuest(event.cartKey, event.quantity);
      // No _debouncedSync
    }

    emit(CartLoaded(localRepo.getAllItems()));

    /*// Just update quantity - it will automatically set the correct syncAction
    localRepo.updateQuantity(event.cartKey, event.quantity);

    emit(CartLoaded(localRepo.getAllItems()));
    _debouncedSync(event.context);*/
  }

  void _onRemoveItem(RemoveFromCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    debugPrint('🗑 REMOVE → ${event.cartKey}');

    final bool isLoggedIn = Global.userData != null && Global.token!.isNotEmpty;

    if (isLoggedIn) {
      // Normal behavior: mark for sync
      localRepo.markForDelete(event.cartKey); // this sets syncAction.add
      _debouncedSync(
          context:  event.context,
        addressId: event.addressId,
        promoCode: event.promoCode,
        rushDelivery: event.rushDelivery,
        useWallet: event.useWallet,
        isFromCartPage: event.isFromCartPage,
      );
    } else {
      // Guest mode: add locally but DO NOT mark for sync
      localRepo.removeItemGuest(event.cartKey); // New method → see below
      // Do NOT call _debouncedSync
    }

    emit(CartLoaded(localRepo.getAllItems()));
    
    /*localRepo.markForDelete(event.cartKey);
    emit(CartLoaded(localRepo.getAllItems()));
    _debouncedSync(event.context);*/
  }

  void _onRemoveLocally(RemoveLocally event, Emitter<CartState> emit) {
    emit(CartLoading());
    debugPrint('🗑 REMOVE → ${event.cartKey}');
    localRepo.deleteLocally(event.cartKey);
    emit(CartLoaded(localRepo.getAllItems()));
    _debouncedSync(
      context: event.context,
    );
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(CartLoading());
    debugPrint('🧹 CLEAR CART');
    localRepo.clearLocalCart();
    emit(CartLoaded([]));
    _debouncedSync(context:  event.context);
  }

  void _debouncedSync({
    required BuildContext context,
    int? addressId,
    String? promoCode,
    bool? rushDelivery,
    bool? useWallet,
    bool? isFromCartPage,
  }) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      add(SyncLocalCart(
        context: context,
        addressId: addressId,
        promoCode: promoCode,
        rushDelivery: rushDelivery,
        useWallet: useWallet,
        isFromCartPage: isFromCartPage,
      ));
    });
  }

  Future<void> _onSyncLocalCart(
      SyncLocalCart event,
      Emitter<CartState> emit,
      ) async {
    final pendingItems = localRepo.getPendingSyncItems();

    if (pendingItems.isEmpty) {
      debugPrint('✅ SYNC → Nothing to sync');
      return;
    }

    debugPrint('🌐 SYNC START → ${pendingItems.length} items');

    for (final item in pendingItems) {
      try {
        debugPrint('🔄 Processing sync for ${item.cartKey} | Action: ${item.syncAction} | ServerID: ${item.serverCartItemId}');

        switch (item.syncAction) {
          case CartSyncAction.add:
            debugPrint('🌐 ADD API → ${item.cartKey}');
            final res = await remoteRepo.addItemToCart(
              productVariantId: int.parse(item.variantId),
              storeId: int.parse(item.vendorId),
              quantity: item.quantity,
            );
            if (res['success'] == true && res['data'] != null) {
              final itemsList = res['data']['items'] as List<dynamic>?;

              if (itemsList != null) {
                final addedServerItem = itemsList.firstWhere(
                      (serverItem) =>
                  serverItem['product_variant_id'].toString() == item.variantId &&
                      serverItem['store_id'].toString() == item.vendorId,
                  orElse: () => null,
                );

                if (addedServerItem != null) {
                  final serverCartItemId = addedServerItem['id'] as int;

                  localRepo.markSynced(
                    item.cartKey,
                    serverCartItemId: serverCartItemId,
                  );

                  debugPrint('✅ ADD synced locally with serverCartItemId: $serverCartItemId');
                } else {
                  debugPrint('⚠️ Could not find matching item in server response');
                }
              }
            } else {
              final errorMessage = res['message'] as String? ?? 'Failed to add item to cart';

              localRepo.deleteLocally(item.cartKey);
              // ← THIS LINE MUST BE EXACTLY LIKE THIS
              emit(CartLoaded(localRepo.getAllItems(), errorMessage: errorMessage));
              return;
            }

            break;

          case CartSyncAction.update:
          // ALWAYS get the absolute latest item from Hive
            final freshItem = localRepo.getItemByKey(item.cartKey);
            log('OFIEFBN');
            if (freshItem == null) {
              debugPrint('❌ Item disappeared from local storage: ${item.cartKey}');
              break;
            }

            if (freshItem.serverCartItemId == null) {
              debugPrint('❌ No serverCartItemId yet for ${item.cartKey}');
              debugPrint('   Current syncAction: ${freshItem.syncAction}');
              debugPrint('   Quantity: ${freshItem.quantity}');
              debugPrint('   Will retry on next sync');
              break;
            }

            debugPrint('🌐 UPDATE API → ${item.cartKey} (qty: ${freshItem.quantity}, serverCartItemId: ${freshItem.serverCartItemId})');

            try {
              await remoteRepo.updateItemQuantity(
                cartItemId: freshItem.serverCartItemId!,
                quantity: freshItem.quantity,
              );

              localRepo.markSynced(item.cartKey);
              debugPrint('✅ UPDATE successful → qty: ${freshItem.quantity}, serverId: ${freshItem.serverCartItemId}');
            } catch (e) {
              debugPrint('❌ UPDATE API failed → $e');
            }
            break;

          case CartSyncAction.delete:
            debugPrint('🌐 DELETE API → ${item.cartKey} (serverCartItemId: ${item.serverCartItemId})');

            if (item.serverCartItemId != null) {
              try {
                await remoteRepo.removeItemFromCart(
                  cartItemId: item.serverCartItemId!,
                );
                debugPrint('✅ DELETE API successful → ${item.cartKey}');
              } catch (e) {
                debugPrint('❌ DELETE API failed → $e');
                // Still remove locally even if API fails (optional: you can retry instead)
              }
            }

            // Remove from local storage after server sync
            localRepo.removeLocal(item.cartKey);
            debugPrint('✅ Removed locally → ${item.cartKey}');
            break;

          case CartSyncAction.none:
            break;
        }
      } catch (e, stackTrace) {
        debugPrint('❌ SYNC FAILED → ${item.cartKey} → $e');
        debugPrint('Stack trace: ${stackTrace.toString()}');
        // Continue with other items instead of returning
        continue;
      }
    }

    debugPrint('✅ SYNC COMPLETE');
    emit(CartLoaded(localRepo.getAllItems()));

    if(event.isFromCartPage == true){
      if(event.context.mounted){
        event.context.read<GetUserCartBloc>().add(FetchUserCart(
          addressId: event.addressId,
          rushDelivery: event.rushDelivery,
          useWallet: event.useWallet,
          promoCode: event.promoCode,
        ));
      }
    } else {
      if(event.context.mounted){
        event.context.read<GetUserCartBloc>().add(FetchUserCart());
      }
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}