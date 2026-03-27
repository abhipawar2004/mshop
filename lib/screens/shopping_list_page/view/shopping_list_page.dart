import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:hyper_local/l10n/app_localizations.dart';
import 'package:hyper_local/screens/shopping_list_page/bloc/shopping_list_bloc/shopping_list_bloc.dart';
import 'package:hyper_local/utils/widgets/custom_button.dart';
import 'package:hyper_local/utils/widgets/custom_toast.dart';
import '../../../router/app_routes.dart';
import '../../../services/shopping_list_hive.dart';
import '../../../utils/widgets/custom_scaffold.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingItem> items = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isAddingItem = false;

  @override
  void initState() {
    super.initState();
    _loadLastList();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isAddingItem) {
        setState(() {
          _controller.clear();
          _isAddingItem = false;
        });
      }
    });
  }

  Future<void> _loadLastList() async {
    final lastItems = await ShoppingListHiveHelper.getLastList();
    if (lastItems.isNotEmpty && mounted) {
      setState(() {
        items.clear();
        items.addAll(lastItems.map((name) => ShoppingItem(name: name)));
      });
    }
  }

  void _saveCurrentList() {
    final names = items.map((e) => e.name).toList();
    ShoppingListHiveHelper.saveCurrentList(names);
  }

  void _addItem() {
    setState(() => _isAddingItem = true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  void _submitItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        items.add(ShoppingItem(name: text, isChecked: true));
        _controller.clear();
        _isAddingItem = false;
      });
      _saveCurrentList();
    }
  }

  void _removeItem(int index) {
    setState(() => items.removeAt(index));
    _saveCurrentList(); // Save instantly
  }

  void _toggleItem(int index) {
    setState(() => items[index].isChecked = !items[index].isChecked);
    // Optional: don't save on toggle
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showViewCart: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.2),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.shoppingList,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              '${items.length} ${AppLocalizations.of(context)!.itemsAdded}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Expanded(
              child: items.isEmpty && !_isAddingItem
                  ? _buildEmptyState()
                  : _buildListWithItems(),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildListWithItems() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length + (_isAddingItem ? 1 : 0) + 1,
      itemBuilder: (context, index) {
        // Add item input field
        if (_isAddingItem && index == items.length) {
          return _buildAddItemField();
        }

        // "Add Item" button at bottom
        if (index == items.length + (_isAddingItem ? 1 : 0)) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: GestureDetector(
              onTap: _addItem,
              child: Row(
                children: [
                  Icon(Icons.add, color: AppTheme.primaryColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.listItem,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // List item
        return _buildListItem(index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.yourShoppingListIsEmpty,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.addItemsToGetStarted,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context)!.addFirstItem),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _submitItem,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(4),
                color: Colors.transparent,
              ),
              child: const Icon(Icons.check, size: 18, color: AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              cursorColor: AppTheme.primaryColor,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.typeItemName,
                hintStyle: TextStyle(
                  color: Colors.grey
                ),
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(fontSize: 16),
              onSubmitted: (_) => _submitItem(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 24),
            onPressed: _submitItem,
            color: AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _toggleItem(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
                color: items[index].isChecked ? Colors.transparent : Colors.transparent,
              ),
              child: items[index].isChecked
                  ? const Icon(Icons.check, size: 18, color: AppTheme.primaryColor)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              items[index].name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    return items.isNotEmpty ? Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: CustomButton(
          onPressed: () {
            if (items.isEmpty) {
              ToastManager.show(
                context: context,
                message: AppLocalizations.of(context)!.pleaseAdd1ItemInShoppingList,
              );
              return;
            }

            final keywords = items.map((e) => e.name).join(',');
            context.read<ShoppingListBloc>().add(CreateShoppingList(keywords: keywords));
            GoRouter.of(context).push(AppRoutes.shoppingListResult);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.startShopping,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class ShoppingItem {
  String name;
  bool isChecked;

  ShoppingItem({required this.name, this.isChecked = false});
}