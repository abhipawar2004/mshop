class PrepareWalletRechargeModel {
  bool? success;
  String? message;
  PrepareWalletRechargeData? data;

  PrepareWalletRechargeModel({this.success, this.message, this.data});

  PrepareWalletRechargeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PrepareWalletRechargeData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PrepareWalletRechargeData {
  Wallet? wallet;
  Transaction? transaction;
  PaymentResponse? paymentResponse;

  PrepareWalletRechargeData({this.wallet, this.transaction, this.paymentResponse});

  PrepareWalletRechargeData.fromJson(Map<String, dynamic> json) {
    wallet =
    json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
    paymentResponse = json['payment_response'] != null
        ? PaymentResponse.fromJson(json['payment_response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    if (paymentResponse != null) {
      data['payment_response'] = paymentResponse!.toJson();
    }
    return data;
  }
}

class Wallet {
  int? id;
  int? userId;
  String? balance;
  String? blockedBalance;
  String? currencyCode;
  String? createdAt;
  String? updatedAt;

  Wallet(
      {this.id,
        this.userId,
        this.balance,
        this.blockedBalance,
        this.currencyCode,
        this.createdAt,
        this.updatedAt});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    blockedBalance = json['blocked_balance'];
    currencyCode = json['currency_code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['balance'] = balance;
    data['blocked_balance'] = blockedBalance;
    data['currency_code'] = currencyCode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Transaction {
  int? id;
  int? walletId;
  int? userId;
  int? orderId;
  String? storeId;
  String? transactionType;
  String? paymentMethod;
  String? amount;
  String? currencyCode;
  String? status;
  String? transactionReference;
  String? description;
  String? createdAt;
  String? updatedAt;

  Transaction(
      {this.id,
        this.walletId,
        this.userId,
        this.orderId,
        this.storeId,
        this.transactionType,
        this.paymentMethod,
        this.amount,
        this.currencyCode,
        this.status,
        this.transactionReference,
        this.description,
        this.createdAt,
        this.updatedAt});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletId = json['wallet_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    storeId = json['store_id'];
    transactionType = json['transaction_type'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    currencyCode = json['currency_code'];
    status = json['status'];
    transactionReference = json['transaction_reference'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_id'] = walletId;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['store_id'] = storeId;
    data['transaction_type'] = transactionType;
    data['payment_method'] = paymentMethod;
    data['amount'] = amount;
    data['currency_code'] = currencyCode;
    data['status'] = status;
    data['transaction_reference'] = transactionReference;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PaymentResponse {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  Notes? notes;
  String? offerId;
  String? receipt;
  String? status;

  PaymentResponse(
      {this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        this.notes,
        this.offerId,
        this.receipt,
        this.status});

  PaymentResponse.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    notes = json['notes'] != null ? Notes.fromJson(json['notes']) : null;
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['amount_due'] = amountDue;
    data['amount_paid'] = amountPaid;
    data['attempts'] = attempts;
    data['created_at'] = createdAt;
    data['currency'] = currency;
    data['entity'] = entity;
    data['id'] = id;
    if (notes != null) {
      data['notes'] = notes!.toJson();
    }
    data['offer_id'] = offerId;
    data['receipt'] = receipt;
    data['status'] = status;
    return data;
  }
}

class Notes {
  String? transactionId;
  String? type;
  int? userId;

  Notes({this.transactionId, this.type, this.userId});

  Notes.fromJson(Map<String, dynamic> json) {
    transactionId = json['transaction_id'];
    type = json['type'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transaction_id'] = transactionId;
    data['type'] = type;
    data['user_id'] = userId;
    return data;
  }
}
