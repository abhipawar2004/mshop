import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hyper_local/config/constant.dart';
import 'package:hyper_local/config/theme.dart';
import 'package:intl/intl.dart';

import '../model/prepare_wallet_recharge_model.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.transactionType?.toLowerCase() == 'deposit';
    final isWithdrawal = transaction.transactionType?.toLowerCase() == 'withdrawal';
    final isRefund = transaction.transactionType?.toLowerCase() == 'refund';

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode(context) ? AppTheme.darkProductCardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconBackgroundColor(isDeposit, isWithdrawal, isRefund),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getTransactionIcon(isDeposit, isWithdrawal, isRefund),
              color: _getIconColor(isDeposit, isWithdrawal, isRefund),
              size: 24,
            ),
          ),

          SizedBox(width: 14),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(
                  _formatDescription(transaction.description),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 5),

                // Date and Payment Method
                Row(
                  children: [
                    Icon(
                      TablerIcons.clock,
                      size: 13,
                      color: Colors.grey.shade500,
                    ),
                    SizedBox(width: 4),
                    Text(
                      _formatDate(transaction.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3),

                // Payment Method
                if (transaction.paymentMethod != null)
                  Row(
                    children: [
                      Icon(
                        _getPaymentMethodIcon(transaction.paymentMethod),
                        size: 13,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _formatPaymentMethod(transaction.paymentMethod),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount
              Text(
                '${isDeposit || isRefund ? '+' : '-'} ${_formatAmount(transaction.amount, transaction.currencyCode)}',
                style: TextStyle(
                  color: isDeposit || isRefund ? Color(0xFF10B981) : Color(0xFFEF4444),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 6),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusBackgroundColor(transaction.status),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatStatus(removeUnderscores(transaction.status!)),
                  style: TextStyle(
                    color: _getStatusTextColor(transaction.status),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getTransactionIcon(bool isDeposit, bool isWithdrawal, bool isRefund) {
    if (isDeposit) return TablerIcons.coins;
    if (isWithdrawal) return TablerIcons.coins;
    if (isRefund) return TablerIcons.coins;
    return TablerIcons.coins;
  }

  Color _getIconColor(bool isDeposit, bool isWithdrawal, bool isRefund) {
    if (isDeposit || isRefund) return Color(0xFF10B981);
    if (isWithdrawal) return Color(0xFFEF4444);
    return Color(0xFF6B7280);
  }

  Color _getIconBackgroundColor(bool isDeposit, bool isWithdrawal, bool isRefund) {
    if (isDeposit || isRefund) return Color(0xFF10B981).withValues(alpha: 0.1);
    if (isWithdrawal) return Color(0xFFEF4444).withValues(alpha: 0.1);
    return Color(0xFF6B7280).withValues(alpha: 0.1);
  }

  Color _getStatusBackgroundColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
      case 'success':
        return Color(0xFF10B981).withValues(alpha: 0.15);
      case 'pending':
        return Color(0xFFF59E0B).withValues(alpha: 0.15);
      case 'failed':
      case 'cancelled':
        return Color(0xFFEF4444).withValues(alpha: 0.15);
      default:
        return Colors.grey.withValues(alpha: 0.15);
    }
  }

  Color _getStatusTextColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
      case 'success':
        return Color(0xFF059669);
      case 'pending':
        return Color(0xFFD97706);
      case 'failed':
      case 'cancelled':
        return Color(0xFFDC2626);
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatStatus(String? status) {
    if (status == null) return 'N/A';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  String _formatDescription(String? description) {
    if (description == null || description == 'string') return 'Wallet Transaction';
    return description;
  }

  String _formatPaymentMethod(String? method) {
    if (method == null) return '';

    // Handle specific payment methods
    if (method.toLowerCase().contains('razorpay')) {
      return 'Razorpay';
    }

    // Convert snake_case or camelCase to Title Case
    return method
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}')
        .split(RegExp(r'[_\s]+'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ')
        .trim();
  }

  IconData _getPaymentMethodIcon(String? method) {
    if (method == null) return TablerIcons.credit_card;

    final lowercaseMethod = method.toLowerCase();
    if (lowercaseMethod.contains('razorpay')) return TablerIcons.brand_stripe;
    if (lowercaseMethod.contains('upi')) return TablerIcons.qrcode;
    if (lowercaseMethod.contains('card')) return TablerIcons.credit_card;
    if (lowercaseMethod.contains('wallet')) return TablerIcons.wallet;

    return TablerIcons.credit_card;
  }

  String _formatAmount(String? amount, String? currencyCode) {
    if (amount == null) return '0';

    final double amountValue = double.tryParse(amount) ?? 0;


    return '${AppConstant.currency}${amountValue.toStringAsFixed(2)}';
  }


  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        if (difference.inHours < 1) {
          return '${difference.inMinutes}m ago';
        }
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()}w ago';
      } else {
        return DateFormat('dd MMM').format(date);
      }
    } catch (e) {
      return dateStr;
    }
  }
}