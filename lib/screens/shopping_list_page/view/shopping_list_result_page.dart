import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_local/screens/shopping_list_page/bloc/shopping_list_bloc/shopping_list_bloc.dart';
import 'package:hyper_local/screens/shopping_list_page/widgets/shopping_list_widget.dart';
import 'package:hyper_local/utils/widgets/custom_circular_progress_indicator.dart';
import 'package:hyper_local/utils/widgets/custom_scaffold.dart';
import 'package:hyper_local/utils/widgets/empty_states_page.dart';
import 'package:hyper_local/l10n/app_localizations.dart';

class ShoppingListResultPage extends StatefulWidget {
  const ShoppingListResultPage({super.key});

  @override
  State<ShoppingListResultPage> createState() => _ShoppingListResultPageState();
}

class _ShoppingListResultPageState extends State<ShoppingListResultPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: true,
      title: AppLocalizations.of(context)!.shoppingList,
      showAppBar: true,
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (BuildContext context, ShoppingListState state) {

          if(state is ShoppingListLoaded) {
            final shoppingListLength = state.shoppingListData.where((item) => item.totalProducts! > 0 ).length;
            return shoppingListLength > 0 ? ListView.builder(
                itemCount: shoppingListLength,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ShoppingListWidget(
                      product: state.shoppingListData[index].products!,
                      title: state.shoppingListData[index].keyword ?? '',
                      totalProducts: state.shoppingListData[index].totalProducts ?? 0,
                    ),
                  );
                }
            ) : NoProductPage();
          }
          if(state is ShoppingListLoading){
            return CustomCircularProgressIndicator();
          }
          return CustomCircularProgressIndicator();
        },
      )
    );
  }
}
