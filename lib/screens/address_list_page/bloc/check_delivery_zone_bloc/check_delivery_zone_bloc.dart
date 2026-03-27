import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/address_list_page/repo/check_delivery_zone_repo.dart';

part 'check_delivery_zone_event.dart';
part 'check_delivery_zone_state.dart';

class CheckDeliveryZoneBloc extends Bloc<CheckDeliveryZoneEvent, CheckDeliveryZoneState> {
  CheckDeliveryZoneBloc() : super(CheckDeliveryZoneInitial()) {
    on<CheckDeliveryZoneRequest>(_onCheckDeliveryZoneRequest);
  }

  Future<void> _onCheckDeliveryZoneRequest(CheckDeliveryZoneRequest event, Emitter<CheckDeliveryZoneState> emit) async {
    emit(CheckDeliveryZoneProgress());
    try{
      final response = await CheckDeliveryZoneRepository().checkDeliveryZone(
        latitude: event.latitude,
        longitude: event.longitude
      );

      if(response.first.success!){
        if(response.first.data!.isDeliverable!) {
          emit(CheckDeliveryZoneSuccess(message: response.first.message ?? 'Delivery is not available to this location'));
        } else {
          emit(CheckDeliveryZoneFailure(error: response.first.message ?? 'Delivery is not available to this location'));
        }
      }
    }catch(e){
      emit(CheckDeliveryZoneFailure(error: e.toString()));
    }
  }
}
