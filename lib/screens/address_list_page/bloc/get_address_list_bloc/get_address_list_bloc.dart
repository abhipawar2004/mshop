import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/address/selected_address_hive.dart';
import '../../model/get_address_list_model.dart';
import '../../repo/address_repo.dart';

part 'get_address_list_event.dart';
part 'get_address_list_state.dart';

class GetAddressListBloc extends Bloc<GetAddressListEvent, GetAddressListState> {
  GetAddressListBloc() : super(GetAddressListInitial()) {
    on<FetchUserAddressList>(_onFetchUserAddressList);
    on<RemoveAddressLocally>(_onRemoveAddressLocally);
    on<AddAddressRequest>(_onAddAddressRequest);
    on<UpdateAddressRequest>(_onUpdateAddressRequest);
    on<RemoveAddressRequest>(_onRemoveAddressRequest);
  }

  int currentPage = 0;
  int perPage = 0;
  int? lastPage;
  bool _hasReachedMax = false;
  bool loadMore = false;
  final AddressRepository repository = AddressRepository();
  String fullAddress = '';

  Future<void> _onFetchUserAddressList(FetchUserAddressList event, Emitter<GetAddressListState> emit) async {
    emit(GetAddressListLoading());
    try{
      List<AddressListData> addressList = [];
      perPage = 18;
      currentPage = 1;
      _hasReachedMax = false;
      loadMore = false;
      final response = await repository.fetchAddressList(deliveryZoneId: event.deliveryZoneId);
      addressList = List<AddressListData>.from(response['data']['data'].map((data) => AddressListData.fromJson(data)));
      currentPage += 1;
      _hasReachedMax = addressList.length < perPage;
      final bool isFetchingAllAddresses = event.deliveryZoneId == null || event.deliveryZoneId.toString() == '';
      if(response['success'] == true) {
        if (isFetchingAllAddresses && addressList.isEmpty) {
          log('No addresses exist globally → clearing Hive selected address');
          HiveSelectedAddressHelper.clearSelectedAddress();
        }
        if (!HiveSelectedAddressHelper.hasSelectedAddress() && addressList.isNotEmpty) {
          HiveSelectedAddressHelper.setSelectedAddress(addressList.first);
        }
        emit(GetAddressListLoaded(
            message: response['message'],
            addressList: addressList,
            hasReachedMax: _hasReachedMax,
          isUpdating: false,
          isAdding: false,
          isRemoving: false,
          isUpdated: false,
          isAdded: false,
          isRemoved: false,
        ));

      } else if (response['error'] == true) {
        emit(GetAddressListFailed(error: response['message']));
      }
    }catch (e) {
      emit(GetAddressListFailed(error: e.toString()));
    }
  }

  Future<void> _onRemoveAddressLocally(RemoveAddressLocally event, Emitter<GetAddressListState> emit) async {
    if (state is GetAddressListLoaded) {
      final currentState = state as GetAddressListLoaded;

      emit(currentState.copyWith(isRemoving: true));


      final updatedAddressList = currentState.addressList.where((address) => address.id != event.addressId).toList();

      emit(currentState.copyWith(
        addressList: updatedAddressList,
        isRemoving: false,
        isRemoved: true,
      ));

      await Future.delayed(const Duration(seconds: 2));
      if (state is GetAddressListLoaded) {
        emit((state as GetAddressListLoaded).copyWith(isRemoved: false));
      }
    }
  }

  Future<void> _onAddAddressRequest(AddAddressRequest event, Emitter<GetAddressListState> emit) async {
    if (state is GetAddressListLoaded) {
      final currentState = state as GetAddressListLoaded;

      emit(currentState.copyWith(isAdding: true));

      try {
        final response = await AddressRepository().addAddressRequest(
            addressLine1: event.addressLine1,
            addressLine2: event.addressLine2,
            city: event.city,
            landmark: event.landmark,
            state: event.state,
            zipcode: event.zipcode,
            mobile: event.mobile,
            addressType: event.addressType,
            country: event.country,
            countryCode: event.countryCode,
            latitude: event.latitude,
            longitude: event.longitude
        );

        if (response.isNotEmpty) {

          add(FetchUserAddressList(deliveryZoneId: event.deliveryZoneId));


          emit(currentState.copyWith(
            isAdding: false,
            isAdded: true,
          ));

          await Future.delayed(const Duration(seconds: 1));
          if (state is GetAddressListLoaded) {
            emit((state as GetAddressListLoaded).copyWith(isAdded: false));
            if(!HiveSelectedAddressHelper.hasSelectedAddress() && response['data'] != null){
              HiveSelectedAddressHelper.setSelectedAddress(response['data']);
            }
          }
        }
      } catch (e) {
        emit(currentState.copyWith(isAdding: false));
      }
    }
  }

  Future<void> _onUpdateAddressRequest(UpdateAddressRequest event, Emitter<GetAddressListState> emit) async {
    if (state is GetAddressListLoaded) {
      final currentState = state as GetAddressListLoaded;

      emit(currentState.copyWith(isUpdating: true));

      try {
        final response = await repository.updateAddress(
          addressId: event.addressId,
          addressLine1: event.addressLine1,
          addressLine2: event.addressLine2,
          city: event.city,
          landmark: event.landmark,
          state: event.state,
          zipcode: event.zipcode,
          mobile: event.mobile,
          addressType: event.addressType,
          country: event.country,
          countryCode: event.countryCode,
          latitude: event.latitude,
          longitude: event.longitude,
        );


        if (response['success'] == true && response['data'] != null) {
          final updatedAddress =
          AddressListData.fromJson(response['data']);

          final updatedList = currentState.addressList.map((address) {
            return address.id == updatedAddress.id
                ? updatedAddress
                : address;
          }).toList();

          emit(currentState.copyWith(
            addressList: updatedList,
            isUpdating: false,
            isUpdated: true,
            message: response['message'] ?? 'Address updated',
          ));

          await Future.delayed(const Duration(seconds: 1));
          if (state is GetAddressListLoaded) {
            emit((state as GetAddressListLoaded)
                .copyWith(isUpdated: false));
          }
        } else {
          emit(currentState.copyWith(isUpdating: false));
          emit(GetAddressListFailed(
            error: response['message'] ?? 'Failed to update address',
          ));
        }

      } catch (e) {
        emit(currentState.copyWith(isUpdating: false));
        emit(GetAddressListFailed(error: e.toString()));
      }
    }
  }

  Future<void> _onRemoveAddressRequest(RemoveAddressRequest event, Emitter<GetAddressListState> emit) async {
    if (state is GetAddressListLoaded) {
      final currentState = state as GetAddressListLoaded;
      emit(currentState.copyWith(isRemoving: true));

      try {
        final response = await repository.removeAddress(
          addressId: event.addressId,
        );

        if (response['success'] == true) {
          final updatedAddressList = currentState.addressList.where((address) => address.id != event.addressId).toList();

          if (updatedAddressList.isEmpty) {
            HiveSelectedAddressHelper.clearSelectedAddress();
          } else if (HiveSelectedAddressHelper.getSelectedAddress()?.id == event.addressId) {
            HiveSelectedAddressHelper.clearSelectedAddress();
          }

          emit(GetAddressListLoaded(
            message: response['message'] ?? currentState.message,
            addressList: updatedAddressList,
            hasReachedMax: currentState.hasReachedMax,
            isUpdating: false,
            isUpdated: false,
            isAdding: false,
            isAdded: false,
            isRemoving: false,
            isRemoved: true,
          ));
        } else {
          emit(GetAddressListLoaded(
            message: currentState.message,
            addressList: currentState.addressList,
            hasReachedMax: currentState.hasReachedMax,
            isUpdating: false,
            isUpdated: false,
            isAdding: false,
            isAdded: false,
            isRemoving: false,
            isRemoved: false,
          ));
          emit(GetAddressListFailed(error: response['message'] ?? 'Failed to remove address'));
        }
      } catch (e) {
        // Reset isRemoving on error
        emit(GetAddressListLoaded(
          message: currentState.message,
          addressList: currentState.addressList,
          hasReachedMax: currentState.hasReachedMax,
          isUpdating: false,
          isUpdated: false,
          isAdding: false,
          isAdded: false,
          isRemoving: false,
          isRemoved: false,
        ));
        emit(GetAddressListFailed(error: e.toString()));
      }
    }
  }
}