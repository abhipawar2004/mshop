class ProductFAQModel {
  bool success;
  String message;
  ProductFAQData data;

  ProductFAQModel({
    this.success = false,
    this.message = '',
    ProductFAQData? data,
  }) : data = data ?? ProductFAQData();

  ProductFAQModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        message = json['message'] ?? '',
        data = json['data'] != null
            ? ProductFAQData.fromJson(json['data'])
            : ProductFAQData();

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ProductFAQData {
  int currentPage;
  List<ProductFAQ> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<Links> links;
  String nextPageUrl;
  String path;
  int perPage;
  String prevPageUrl;
  int to;
  int total;

  ProductFAQData({
    this.currentPage = 1,
    List<ProductFAQ>? data,
    this.firstPageUrl = '',
    this.from = 0,
    this.lastPage = 1,
    this.lastPageUrl = '',
    List<Links>? links,
    this.nextPageUrl = '',
    this.path = '',
    this.perPage = 10,
    this.prevPageUrl = '',
    this.to = 0,
    this.total = 0,
  }) : data = data ?? [],
        links = links ?? [];

  ProductFAQData.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] ?? 1,
        data = json['data'] != null
            ? (json['data'] as List).map((v) => ProductFAQ.fromJson(v)).toList()
            : [],
        firstPageUrl = json['first_page_url'] ?? '',
        from = json['from'] ?? 0,
        lastPage = json['last_page'] ?? 1,
        lastPageUrl = json['last_page_url'] ?? '',
        links = json['links'] != null
            ? (json['links'] as List).map((v) => Links.fromJson(v)).toList()
            : [],
        nextPageUrl = json['next_page_url'] ?? '',
        path = json['path'] ?? '',
        perPage = json['per_page'] ?? 10,
        prevPageUrl = json['prev_page_url'] ?? '',
        to = json['to'] ?? 0,
        total = json['total'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data.map((v) => v.toJson()).toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links.map((v) => v.toJson()).toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
  }
}

class ProductFAQ {
  int id;
  int productId;
  String productSlug;
  Product product;
  String question;
  String answer;
  String status;
  String createdAt;
  String updatedAt;

  ProductFAQ({
    this.id = 0,
    this.productId = 0,
    this.productSlug = '',
    Product? product,
    this.question = '',
    this.answer = '',
    this.status = '',
    this.createdAt = '',
    this.updatedAt = '',
  }) : product = product ?? Product();

  ProductFAQ.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        productId = json['product_id'] ?? 0,
        productSlug = json['product_slug'] ?? '',
        product = json['product'] != null
            ? Product.fromJson(json['product'])
            : Product(),
        question = json['question'] ?? '',
        answer = json['answer'] ?? '',
        status = json['status'] ?? '',
        createdAt = json['created_at'] ?? '',
        updatedAt = json['updated_at'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_slug': productSlug,
      'product': product.toJson(),
      'question': question,
      'answer': answer,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Product {
  int id;
  String title;
  String slug;

  Product({
    this.id = 0,
    this.title = '',
    this.slug = '',
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        title = json['title'] ?? '',
        slug = json['slug'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
    };
  }
}

class Links {
  String url;
  String label;
  int page;
  bool active;

  Links({
    this.url = '',
    this.label = '',
    this.page = 0,
    this.active = false,
  });

  Links.fromJson(Map<String, dynamic> json)
      : url = json['url'] ?? '',
        label = json['label'] ?? '',
        page = json['page'] ?? 0,
        active = json['active'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}
