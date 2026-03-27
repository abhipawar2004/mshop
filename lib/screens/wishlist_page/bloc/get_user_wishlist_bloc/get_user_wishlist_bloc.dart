
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/wishlist_page/model/user_wishlist_model.dart';
import 'package:hyper_local/screens/wishlist_page/repo/wishlist_repo.dart';
import 'get_user_wishlist_state.dart';
part 'get_user_wishlist_event.dart';

class UserWishlistBloc extends Bloc<UserWishlistEvent, UserWishlistState> {
  UserWishlistBloc() : super(UserWishlistInitial()) {
    on<GetUserWishlistRequest>(_onGetUserWishlistRequest);
    on<GetMoreUserWishlistRequest>(_onGetMoreUserWishlistRequest);
    on<CreateNewWishlist>(_onCreateNewWishlist);
    on<AddItemInWishlist>(_onAddItemInWishlist);
    on<UpdateUserWishlist>(_onUpdateUserWishlist);
    on<DeleteWishlist>(_onDeleteWishlist);
    on<RemoveItemFromWishlist>(_onRemoveItemFromWishlist);
    on<MoveItemToAnotherWishlist>(_onMoveItemToAnotherWishlist);
    on<OptimisticAddToWishlist>(_onOptimisticAddToWishlist);
    on<OptimisticRemoveFromWishlist>(_onOptimisticRemoveFromWishlist);

  }

  final UserWishlistRepository repository = UserWishlistRepository();
  int currentPage = 0;
  int perPage = 48;
  int? lastPage;
  bool hasReachedMax = false;
  bool isLoadingMore = false;
  bool loadMore = false;
  
  // Local cache for optimistic updates: Map<productId_productVariantId_storeId, wishlistItemId>
  // If value is null, product is not wishlisted. If value is non-null, product is wishlisted.
  final Map<String, int?> _localWishlistCache = {};
  
  // Track pending operations: Set of cache keys for add operations, Set of itemIds for remove operations
  final Set<String> _pendingAddOperations = {}; // Format: "productId_productVariantId_storeId_wishlistTitle"
  final Set<int> _pendingRemoveOperations = {}; // itemIds
  
  // Check if an add operation is pending for a product in a specific wishlist
  bool isAddOperationPending(int productId, int productVariantId, int storeId, String wishlistTitle) {
    final key = '${_getCacheKey(productId, productVariantId, storeId)}_$wishlistTitle';
    return _pendingAddOperations.contains(key);
  }
  
  // Check if a remove operation is pending for an item
  bool isRemoveOperationPending(int itemId) {
    return _pendingRemoveOperations.contains(itemId);
  }
  
  // Helper method to generate cache key
  String _getCacheKey(int productId, int productVariantId, int storeId) {
    return '${productId}_${productVariantId}_$storeId';
  }
  
  // Public method to check if product is wishlisted (checks both server state and local cache)
  bool isProductWishlisted(int productId, int productVariantId, int storeId) {
    final cacheKey = _getCacheKey(productId, productVariantId, storeId);
    if (_localWishlistCache.containsKey(cacheKey)) {
      return _localWishlistCache[cacheKey] != null;
    }
    // If not in cache, check server state
    if (state is UserWishlistLoaded) {
      final loadedState = state as UserWishlistLoaded;
      for (final wishlist in loadedState.wishlistData) {
        if (wishlist.items != null) {
          for (final item in wishlist.items!) {
            if (item.product?.id == productId && 
                item.variant?.id == productVariantId && 
                item.store?.id == storeId) {
              // Update cache with server state
              _localWishlistCache[cacheKey] = item.id;
              return true;
            }
          }
        }
      }
    }
    return false;
  }
  
  // Get wishlist item ID for a product
  int? getWishlistItemId(int productId, int productVariantId, int storeId) {
    final cacheKey = _getCacheKey(productId, productVariantId, storeId);
    if (_localWishlistCache.containsKey(cacheKey)) {
      return _localWishlistCache[cacheKey];
    }
    // If not in cache, check server state
    if (state is UserWishlistLoaded) {
      final loadedState = state as UserWishlistLoaded;
      for (final wishlist in loadedState.wishlistData) {
        if (wishlist.items != null) {
          for (final item in wishlist.items!) {
            if (item.product?.id == productId && 
                item.variant?.id == productVariantId && 
                item.store?.id == storeId) {
              _localWishlistCache[cacheKey] = item.id;
              return item.id;
            }
          }
        }
      }
    }
    return null;
  }
  
  // Check if bloc has data for this product (either from cache or server state)
  bool hasProductData(int productId, int productVariantId, int storeId) {
    final cacheKey = _getCacheKey(productId, productVariantId, storeId);
    // If in cache, we have data (even if value is null, it means we know it's not wishlisted)
    if (_localWishlistCache.containsKey(cacheKey)) {
      return true;
    }
    // If state is loaded, we have server data
    return state is UserWishlistLoaded;
  }

  Future<void> _onGetUserWishlistRequest(GetUserWishlistRequest event, Emitter<UserWishlistState> emit) async {
    emit(UserWishlistLoading());
    try{
      List<WishlistData> wishlistData = [];
      currentPage = 1;
      hasReachedMax = false;
      isLoadingMore = false;
      final response = await repository.getUserWishlist(perPage: perPage, currentPage: currentPage);
      wishlistData = List<WishlistData>.from(response['data']['data'].map((data) => WishlistData.fromJson(data)));

      final currentTotal = int.parse(response['data']['current_page'].toString());
      final lastPageNum = int.parse(response['data']['last_page'].toString());
      hasReachedMax = currentTotal >= lastPageNum || wishlistData.length < perPage;
      if(response['success'] == true){
        // Update local cache with server data
        _updateLocalCacheFromWishlistData(wishlistData);
        emit(UserWishlistLoaded(
            message: response['message'],
            wishlistData: wishlistData,
            hasReachedMax: hasReachedMax
        ));
      } else if (response['error'] == true){
        emit(UserWishlistFailed(message: response['message']));
      }
    }catch(e) {
      emit(UserWishlistFailed(message: e.toString()));
    }
  }
  
  // Helper method to update local cache from wishlist data
  void _updateLocalCacheFromWishlistData(List<WishlistData> wishlistData) {
    for (final wishlist in wishlistData) {
      if (wishlist.items != null) {
        for (final item in wishlist.items!) {
          if (item.product?.id != null && item.variant?.id != null && item.store?.id != null) {
            final cacheKey = _getCacheKey(item.product!.id!, item.variant!.id!, item.store!.id!);
            _localWishlistCache[cacheKey] = item.id;
          }
        }
      }
    }
  }

  Future<void> _onGetMoreUserWishlistRequest(GetMoreUserWishlistRequest event, Emitter<UserWishlistState> emit) async {
    if (hasReachedMax || isLoadingMore) return;
    final currentState = state;
    if(currentState is UserWishlistLoaded) {
      isLoadingMore = true;
      try{
        List<WishlistData> newWishlistData = [];
        currentPage += 1;

        final response = await repository.getUserWishlist(perPage: perPage, currentPage: currentPage);
        newWishlistData = List<WishlistData>.from(response['data']['data'].map((data) => WishlistData.fromJson(data)));

        final currentTotal = int.parse(response['data']['current_page'].toString());
        final lastPageNum = int.parse(response['data']['last_page'].toString());
        hasReachedMax = currentTotal >= lastPageNum || newWishlistData.length < perPage;
        final updatedWishlistData = List<WishlistData>.from(currentState.wishlistData);
        for (final newWishlist in newWishlistData) {
          if (!updatedWishlistData.any((existing) => existing.id == newWishlist.id)) {
            updatedWishlistData.add(newWishlist);
          }
        }
        // Update local cache with new wishlist data
        _updateLocalCacheFromWishlistData(newWishlistData);
        emit(UserWishlistLoaded(
            message: response['message'],
            wishlistData: updatedWishlistData,
            hasReachedMax: hasReachedMax
        ));

      } catch(e) {
        currentPage -= 1;
        emit(UserWishlistFailed(message: e.toString()));
      } finally {
        isLoadingMore = false;
      }
    }

  }

  Future<void> _onCreateNewWishlist(CreateNewWishlist event, Emitter<UserWishlistState> emit) async {
    emit(UserWishlistLoading());
    try{

      final response = await repository.createWishlist(title: event.title);

      if(response['success'] == true){
        add(GetUserWishlistRequest());
      } else if (response['error'] == true){
        emit(UserWishlistFailed(message: response['message']));
      }
    }catch(e) {
      emit(UserWishlistFailed(message: e.toString()));
    }
  }

  Future<void> _onAddItemInWishlist(AddItemInWishlist event, Emitter<UserWishlistState> emit) async {
    // Store original state to revert if API fails
    WishlistData? originalWishlist;
    
    // Mark operation as pending
    final pendingKey = '${_getCacheKey(event.productId, event.productVariantId, event.storeId)}_${event.wishlistTitle}';
    _pendingAddOperations.add(pendingKey);
    
    // Emit current state to trigger UI update with loading indicator
    if (state is UserWishlistLoaded) {
      emit((state as UserWishlistLoaded));
    }
    
    // Optimistically update ONLY item count and cache (for icon state)
    // Do NOT add item to items array until API succeeds
    if (state is UserWishlistLoaded) {
      final currentState = state as UserWishlistLoaded;
      
      // Find the wishlist to update
      final wishlistIndex = currentState.wishlistData.indexWhere(
        (wishlist) => wishlist.title == event.wishlistTitle,
      );
      
      if (wishlistIndex != -1) {
        originalWishlist = currentState.wishlistData[wishlistIndex];
        
        // Update only itemsCount optimistically, keep items array unchanged
        final updatedWishlist = originalWishlist.copyWith(
          items: originalWishlist.items, // Keep original items, don't add temp item
          itemsCount: (originalWishlist.itemsCount ?? 0) + 1,
        );
        
        final updatedWishlistData = List<WishlistData>.from(currentState.wishlistData);
        updatedWishlistData[wishlistIndex] = updatedWishlist;
        
        // Update local cache for icon state (but item not in array yet)
        final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
        _localWishlistCache[cacheKey] = -1; // Temporary ID for icon state
        
        // Emit updated state immediately (count updated, icon will show as wishlisted)
        emit(UserWishlistLoaded(
          message: currentState.message,
          wishlistData: updatedWishlistData,
          hasReachedMax: currentState.hasReachedMax,
        ));
      }
    }
    
    // Call API in background
    try{
      final response = await repository.addItemInWishlist(
         wishlistTitle : event.wishlistTitle,
         productId : event.productId,
         productVariantId : event.productVariantId,
         storeId : event.storeId,
      );

      // Remove from pending operations
      _pendingAddOperations.remove(pendingKey);

      if(response['success'] == true){
        // API succeeded - now refresh the wishlist to get actual item data with image
        // This will update the items array and isWishListed check
        if (state is UserWishlistLoaded) {
          final currentState = state as UserWishlistLoaded;
          final wishlistIndex = currentState.wishlistData.indexWhere(
            (wishlist) => wishlist.title == event.wishlistTitle,
          );
          
          if (wishlistIndex != -1) {
            // Refresh only this specific wishlist's data
            try {
              final refreshResponse = await repository.getUserWishlist(perPage: perPage, currentPage: 1);
              if (refreshResponse['success'] == true) {
                final refreshedWishlistData = List<WishlistData>.from(
                  refreshResponse['data']['data'].map((data) => WishlistData.fromJson(data))
                );
                
                // Update only the specific wishlist that was modified
                final updatedWishlistData = List<WishlistData>.from(currentState.wishlistData);
                final refreshedWishlist = refreshedWishlistData.firstWhere(
                  (w) => w.title == event.wishlistTitle,
                  orElse: () => currentState.wishlistData[wishlistIndex],
                );
                updatedWishlistData[wishlistIndex] = refreshedWishlist;
                
                // Update local cache with real item ID if found
                final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
                if (refreshedWishlist.items != null) {
                  for (final item in refreshedWishlist.items!) {
                    if (item.product?.id == event.productId && 
                        item.variant?.id == event.productVariantId && 
                        item.store?.id == event.storeId) {
                      _localWishlistCache[cacheKey] = item.id;
                      break;
                    }
                  }
                }
                
                emit(UserWishlistLoaded(
                  message: currentState.message,
                  wishlistData: updatedWishlistData,
                  hasReachedMax: currentState.hasReachedMax,
                ));
              } else {
                // If refresh fails, just emit current state to remove loading
                emit((state as UserWishlistLoaded));
              }
            } catch (e) {
              // If refresh fails, just emit current state to remove loading
              emit((state as UserWishlistLoaded));
            }
          } else {
            emit((state as UserWishlistLoaded));
          }
        }
      } else if (response['error'] == true){
        // Revert optimistic update on error
        if (state is UserWishlistLoaded && originalWishlist != null) {
          final currentState = state as UserWishlistLoaded;
          final wishlistIndex = currentState.wishlistData.indexWhere(
            (wishlist) => wishlist.id == originalWishlist!.id,
          );
          
          if (wishlistIndex != -1) {
            final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
            revertedWishlistData[wishlistIndex] = originalWishlist;
            
            // Revert cache
            final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
            _localWishlistCache.remove(cacheKey);
            
            emit(UserWishlistLoaded(
              message: response['message'] ?? 'Add failed',
              wishlistData: revertedWishlistData,
              hasReachedMax: currentState.hasReachedMax,
            ));
          }
        }
      }
    }catch(e) {
      // Remove from pending operations
      _pendingAddOperations.remove(pendingKey);
      
      // Revert optimistic update on error
      if (state is UserWishlistLoaded && originalWishlist != null) {
        final currentState = state as UserWishlistLoaded;
        final wishlistIndex = currentState.wishlistData.indexWhere(
          (wishlist) => wishlist.id == originalWishlist!.id,
        );
        
        if (wishlistIndex != -1) {
          final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
          revertedWishlistData[wishlistIndex] = originalWishlist;
          
          // Revert cache
          final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
          _localWishlistCache.remove(cacheKey);
          
          emit(UserWishlistLoaded(
            message: e.toString(),
            wishlistData: revertedWishlistData,
            hasReachedMax: currentState.hasReachedMax,
          ));
        }
      }
    }
  }

  Future<void> _onUpdateUserWishlist(UpdateUserWishlist event, Emitter<UserWishlistState> emit) async {
    // Store original wishlist to revert if API fails
    WishlistData? originalWishlist;
    
    // Optimistically update the wishlist in state without showing loading
    if (state is UserWishlistLoaded) {
      final currentState = state as UserWishlistLoaded;
      originalWishlist = currentState.wishlistData.firstWhere(
        (wishlist) => wishlist.id == event.wishlistId,
        orElse: () => WishlistData(),
      );
      
      final updatedWishlistData = currentState.wishlistData.map((wishlist) {
        if (wishlist.id == event.wishlistId) {
          // Create updated wishlist with new title
          return WishlistData(
            id: wishlist.id,
            title: event.title,
            slug: wishlist.slug,
            itemsCount: wishlist.itemsCount,
            items: wishlist.items,
            createdAt: wishlist.createdAt,
            updatedAt: wishlist.updatedAt,
          );
        }
        return wishlist;
      }).toList();
      
      // Emit updated state immediately
      emit(UserWishlistLoaded(
        message: currentState.message,
        wishlistData: updatedWishlistData,
        hasReachedMax: currentState.hasReachedMax,
      ));
    }
    
    // Call API in background
    try{
      final response = await repository.updateWishlist(title: event.title, wishlistId: event.wishlistId);

      if(response['success'] == true){
        // API succeeded - state already updated optimistically, no need to refresh
        // The optimistic update is already in place, so we're done
      } else if (response['error'] == true){
        // Revert optimistic update on error
        if (state is UserWishlistLoaded && originalWishlist != null && originalWishlist.id != null) {
          final currentState = state as UserWishlistLoaded;
          final revertedWishlistData = currentState.wishlistData.map((wishlist) {
            if (wishlist.id == originalWishlist!.id) {
              return originalWishlist;
            }
            return wishlist;
          }).toList();
          
          emit(UserWishlistLoaded(
            message: response['message'] ?? 'Update failed',
            wishlistData: revertedWishlistData,
            hasReachedMax: currentState.hasReachedMax,
          ));
        } else {
          // If we can't revert, just refresh silently
          add(GetUserWishlistRequest());
        }
      }
    }catch(e) {
      // Revert optimistic update on error
      if (state is UserWishlistLoaded && originalWishlist != null && originalWishlist.id != null) {
        final currentState = state as UserWishlistLoaded;
        final revertedWishlistData = currentState.wishlistData.map((wishlist) {
          if (wishlist.id == originalWishlist!.id) {
            return originalWishlist;
          }
          return wishlist;
        }).toList();
        
        emit(UserWishlistLoaded(
          message: e.toString(),
          wishlistData: revertedWishlistData,
          hasReachedMax: currentState.hasReachedMax,
        ));
      } else {
        // If we can't revert, just refresh silently
        add(GetUserWishlistRequest());
      }
    }
  }

  Future<void> _onDeleteWishlist(DeleteWishlist event, Emitter<UserWishlistState> emit) async {
    // Store the deleted wishlist to revert if API fails
    WishlistData? deletedWishlist;
    
    // Optimistically remove the wishlist from state without showing loading
    if (state is UserWishlistLoaded) {
      final currentState = state as UserWishlistLoaded;
      deletedWishlist = currentState.wishlistData.firstWhere(
        (wishlist) => wishlist.id == event.wishlistId,
        orElse: () => WishlistData(),
      );
      
      final updatedWishlistData = currentState.wishlistData
          .where((wishlist) => wishlist.id != event.wishlistId)
          .toList();
      
      // Also remove items from local cache if this wishlist had any
      if (deletedWishlist.items != null) {
        for (final item in deletedWishlist.items!) {
          if (item.product?.id != null && item.variant?.id != null && item.store?.id != null) {
            final cacheKey = _getCacheKey(item.product!.id!, item.variant!.id!, item.store!.id!);
            _localWishlistCache.remove(cacheKey);
          }
        }
      }
      
      // Emit updated state immediately
      emit(UserWishlistLoaded(
        message: currentState.message,
        wishlistData: updatedWishlistData,
        hasReachedMax: currentState.hasReachedMax,
      ));
    }
    
    // Call API in background
    try{
      final response = await repository.deleteWishlist(wishlistId: event.wishlistId);

      if(response['success'] == true){
        // API succeeded - state already updated optimistically, no need to refresh
        // The optimistic update already removed the wishlist from state
      } else if (response['error'] == true){
        // Revert optimistic update on error
        if (state is UserWishlistLoaded && deletedWishlist != null && deletedWishlist.id != null) {
          final currentState = state as UserWishlistLoaded;
          final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
          revertedWishlistData.add(deletedWishlist);
          
          // Restore cache entries
          if (deletedWishlist.items != null) {
            for (final item in deletedWishlist.items!) {
              if (item.product?.id != null && item.variant?.id != null && item.store?.id != null && item.id != null) {
                final cacheKey = _getCacheKey(item.product!.id!, item.variant!.id!, item.store!.id!);
                _localWishlistCache[cacheKey] = item.id;
              }
            }
          }
          
          emit(UserWishlistLoaded(
            message: response['message'] ?? 'Delete failed',
            wishlistData: revertedWishlistData,
            hasReachedMax: currentState.hasReachedMax,
          ));
        } else {
          // If we can't revert, just refresh
          add(GetUserWishlistRequest());
        }
      }
    }catch(e) {
      // Revert optimistic update on error
      if (state is UserWishlistLoaded && deletedWishlist != null && deletedWishlist.id != null) {
        final currentState = state as UserWishlistLoaded;
        final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
        revertedWishlistData.add(deletedWishlist);
        
        // Restore cache entries
        if (deletedWishlist.items != null) {
          for (final item in deletedWishlist.items!) {
            if (item.product?.id != null && item.variant?.id != null && item.store?.id != null && item.id != null) {
              final cacheKey = _getCacheKey(item.product!.id!, item.variant!.id!, item.store!.id!);
              _localWishlistCache[cacheKey] = item.id;
            }
          }
        }
        
        emit(UserWishlistLoaded(
          message: e.toString(),
          wishlistData: revertedWishlistData,
          hasReachedMax: currentState.hasReachedMax,
        ));
      } else {
        // If we can't revert, just refresh
        add(GetUserWishlistRequest());
      }
    }
  }

  Future<void> _onRemoveItemFromWishlist(RemoveItemFromWishlist event, Emitter<UserWishlistState> emit) async {
    // Store original state to revert if API fails
    WishlistData? originalWishlist;
    Items? removedItem;
    int? wishlistIndex;
    
    // Mark operation as pending
    _pendingRemoveOperations.add(event.itemId);
    
    // Emit current state to trigger UI update with loading indicator
    if (state is UserWishlistLoaded) {
      emit((state as UserWishlistLoaded));
    }
    
    // Optimistically update the wishlist in state without showing loading
    if (state is UserWishlistLoaded) {
      final currentState = state as UserWishlistLoaded;
      
      // Find the item and its wishlist
      for (int i = 0; i < currentState.wishlistData.length; i++) {
        final wishlist = currentState.wishlistData[i];
        if (wishlist.items != null) {
          final itemIndex = wishlist.items!.indexWhere((item) => item.id == event.itemId);
          if (itemIndex != -1) {
            originalWishlist = wishlist;
            removedItem = wishlist.items![itemIndex];
            wishlistIndex = i;
            break;
          }
        }
      }
      
      if (originalWishlist != null && removedItem != null && wishlistIndex != null) {
        // Create updated wishlist with item removed
        final updatedItems = List<Items>.from(originalWishlist.items ?? []);
        updatedItems.removeWhere((item) => item.id == event.itemId);
        
        final updatedWishlist = originalWishlist.copyWith(
          items: updatedItems,
          itemsCount: (originalWishlist.itemsCount ?? 1) > 0 
              ? (originalWishlist.itemsCount ?? 1) - 1 
              : 0,
        );
        
        final updatedWishlistData = List<WishlistData>.from(currentState.wishlistData);
        updatedWishlistData[wishlistIndex] = updatedWishlist;
        
        // Update local cache - only clear if product is not in any other wishlist
        if (removedItem.product?.id != null && 
            removedItem.variant?.id != null && 
            removedItem.store?.id != null) {
          final cacheKey = _getCacheKey(
            removedItem.product!.id!, 
            removedItem.variant!.id!, 
            removedItem.store!.id!
          );
          
          // Check if product still exists in other wishlists
          bool foundInOtherWishlist = false;
          int? itemIdFromOtherWishlist;
          
          for (final wishlist in updatedWishlistData) {
            if (wishlist.items != null) {
              for (final item in wishlist.items!) {
                if (item.product?.id == removedItem.product!.id &&
                    item.variant?.id == removedItem.variant!.id &&
                    item.store?.id == removedItem.store!.id) {
                  foundInOtherWishlist = true;
                  itemIdFromOtherWishlist = item.id;
                  break;
                }
              }
              if (foundInOtherWishlist) break;
            }
          }
          
          // Only clear cache if product is not in any other wishlist
          if (!foundInOtherWishlist) {
            _localWishlistCache[cacheKey] = null;
          } else if (itemIdFromOtherWishlist != null) {
            // Update cache with ID from another wishlist
            _localWishlistCache[cacheKey] = itemIdFromOtherWishlist;
          }
        }
        
        // Emit updated state immediately
        emit(UserWishlistLoaded(
          message: currentState.message,
          wishlistData: updatedWishlistData,
          hasReachedMax: currentState.hasReachedMax,
        ));
      }
    }
    
    // If item ID is -1 (temporary), it was optimistically added and not yet confirmed by API
    // Just remove it from state without calling API
    if (removedItem != null && removedItem.id == -1) {
      // Remove from pending operations
      _pendingRemoveOperations.remove(event.itemId);
      // Item was optimistically added, already removed from state
      // No API call needed, but emit state to remove loading indicator
      if (state is UserWishlistLoaded) {
        emit((state as UserWishlistLoaded));
      }
      return;
    }
    
    // Call API in background for real items
    try{
      final response = await repository.removeItemFromWishlist(itemId: event.itemId);
      
      // Remove from pending operations
      _pendingRemoveOperations.remove(event.itemId);
      
      if(response['success'] == true){
        // API succeeded - state already updated optimistically
        // Update cache to reflect current state (check if product is in other wishlists)
        if (state is UserWishlistLoaded && removedItem != null &&
            removedItem.product?.id != null && 
            removedItem.variant?.id != null && 
            removedItem.store?.id != null) {
          final currentState = state as UserWishlistLoaded;
          final cacheKey = _getCacheKey(
            removedItem.product!.id!, 
            removedItem.variant!.id!, 
            removedItem.store!.id!
          );
          
          // Check if product still exists in other wishlists
          bool foundInOtherWishlist = false;
          int? itemIdFromOtherWishlist;
          
          for (final wishlist in currentState.wishlistData) {
            if (wishlist.items != null) {
              for (final item in wishlist.items!) {
                if (item.product?.id == removedItem.product!.id &&
                    item.variant?.id == removedItem.variant!.id &&
                    item.store?.id == removedItem.store!.id) {
                  foundInOtherWishlist = true;
                  itemIdFromOtherWishlist = item.id;
                  break;
                }
              }
              if (foundInOtherWishlist) break;
            }
          }
          
          // Update cache: clear if not in any wishlist, otherwise keep ID from another wishlist
          if (!foundInOtherWishlist) {
            _localWishlistCache[cacheKey] = null;
          } else if (itemIdFromOtherWishlist != null) {
            _localWishlistCache[cacheKey] = itemIdFromOtherWishlist;
          }
        }
        
        // Emit state to update UI (remove loading indicator)
        if (state is UserWishlistLoaded) {
          emit((state as UserWishlistLoaded));
        }
      } else if (response['error'] == true){
        // Revert optimistic update on error
        if (state is UserWishlistLoaded && originalWishlist != null && wishlistIndex != null) {
          final currentState = state as UserWishlistLoaded;
          final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
          revertedWishlistData[wishlistIndex] = originalWishlist;
          
          // Restore cache with the removed item's ID
          if (removedItem != null && 
              removedItem.product?.id != null && 
              removedItem.variant?.id != null && 
              removedItem.store?.id != null &&
              removedItem.id != null) {
            final cacheKey = _getCacheKey(
              removedItem.product!.id!, 
              removedItem.variant!.id!, 
              removedItem.store!.id!
            );
            // Check if product exists in other wishlists first
            bool foundInOtherWishlist = false;
            int? itemIdFromOtherWishlist;
            
            if (state is UserWishlistLoaded) {
              final currentState = state as UserWishlistLoaded;
              for (final wishlist in currentState.wishlistData) {
                if (wishlist.items != null) {
                  for (final item in wishlist.items!) {
                    if (item.product?.id == removedItem.product!.id &&
                        item.variant?.id == removedItem.variant!.id &&
                        item.store?.id == removedItem.store!.id) {
                      foundInOtherWishlist = true;
                      itemIdFromOtherWishlist = item.id;
                      break;
                    }
                  }
                  if (foundInOtherWishlist) break;
                }
              }
            }
            
            // Use ID from other wishlist if found, otherwise use removed item's ID
            _localWishlistCache[cacheKey] = itemIdFromOtherWishlist ?? removedItem.id;
          }
          
          emit(UserWishlistLoaded(
            message: response['message'] ?? 'Remove failed',
            wishlistData: revertedWishlistData,
            hasReachedMax: currentState.hasReachedMax,
          ));
        }
      }
    }catch(e) {
      // Remove from pending operations
      _pendingRemoveOperations.remove(event.itemId);
      
      // Revert optimistic update on error
      if (state is UserWishlistLoaded && originalWishlist != null && wishlistIndex != null) {
        final currentState = state as UserWishlistLoaded;
        final revertedWishlistData = List<WishlistData>.from(currentState.wishlistData);
        revertedWishlistData[wishlistIndex] = originalWishlist;
        
        // Restore cache - check if product exists in other wishlists first
        if (removedItem != null && 
            removedItem.product?.id != null && 
            removedItem.variant?.id != null && 
            removedItem.store?.id != null &&
            removedItem.id != null) {
          final cacheKey = _getCacheKey(
            removedItem.product!.id!, 
            removedItem.variant!.id!, 
            removedItem.store!.id!
          );
          
          // Check if product exists in other wishlists
          bool foundInOtherWishlist = false;
          int? itemIdFromOtherWishlist;
          
          if (state is UserWishlistLoaded) {
            final currentState = state as UserWishlistLoaded;
            for (final wishlist in currentState.wishlistData) {
              if (wishlist.items != null) {
                for (final item in wishlist.items!) {
                  if (item.product?.id == removedItem.product!.id &&
                      item.variant?.id == removedItem.variant!.id &&
                      item.store?.id == removedItem.store!.id) {
                    foundInOtherWishlist = true;
                    itemIdFromOtherWishlist = item.id;
                    break;
                  }
                }
                if (foundInOtherWishlist) break;
              }
            }
          }
          
          // Use ID from other wishlist if found, otherwise use removed item's ID
          _localWishlistCache[cacheKey] = itemIdFromOtherWishlist ?? removedItem.id;
        }
        
        emit(UserWishlistLoaded(
          message: e.toString(),
          wishlistData: revertedWishlistData,
          hasReachedMax: currentState.hasReachedMax,
        ));
      }
    }
  }
  
  // Optimistic update handlers
  Future<void> _onOptimisticAddToWishlist(OptimisticAddToWishlist event, Emitter<UserWishlistState> emit) async {
    final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
    _localWishlistCache[cacheKey] = event.wishlistItemId ?? -1; // Use -1 as temporary ID
    
    // Emit current state to trigger UI update
    if (state is UserWishlistLoaded) {
      emit((state as UserWishlistLoaded));
    } else if (state is UserWishlistInitial) {
      // If no state loaded yet, emit a minimal loaded state
      emit(UserWishlistLoaded(
        message: '',
        wishlistData: [],
        hasReachedMax: true,
      ));
    }
  }
  
  Future<void> _onOptimisticRemoveFromWishlist(OptimisticRemoveFromWishlist event, Emitter<UserWishlistState> emit) async {
    final cacheKey = _getCacheKey(event.productId, event.productVariantId, event.storeId);
    _localWishlistCache[cacheKey] = null;
    
    // Emit current state to trigger UI update
    if (state is UserWishlistLoaded) {
      emit((state as UserWishlistLoaded));
    } else if (state is UserWishlistInitial) {
      emit(UserWishlistLoaded(
        message: '',
        wishlistData: [],
        hasReachedMax: true,
      ));
    }
  }

  Future<void> _onMoveItemToAnotherWishlist(MoveItemToAnotherWishlist event, Emitter<UserWishlistState> emit) async {
    emit(UserWishlistLoading());
    try{
      final response = await repository.moveItemToAnotherWishlist(itemId: event.itemId, wishlistId: event.wishlistId);

      if(response['success'] == true){
        add(GetUserWishlistRequest());
      } else if (response['error'] == true){
        emit(UserWishlistFailed(message: response['message']));
      }
    }catch(e) {
      emit(UserWishlistFailed(message: e.toString()));
    }
  }
}