class NearByStoreModel {
  bool? success;
  String? message;
  Data? data;

  NearByStoreModel({this.success, this.message, this.data});

  NearByStoreModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? currentPage;
  List<StoreData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <StoreData>[];
      json['data'].forEach((v) {
        data!.add(StoreData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class StoreData {
  int? id;
  String? name;
  String? slug;
  int? productCount;
  String? description;
  String? contactNumber;
  String? contactEmail;
  String? address;
  String? latitude;
  String? longitude;
  double? distance;
  String? timing;
  String? logo;
  String? banner;
  String? createdAt;
  String? updatedAt;
  String? verificationStatus;
  String? visibilityStatus;
  Status? status;
  String? avgProductsRating;
  String? avgStoreRating;
  int? totalStoreFeedback;

  StoreData(
      {this.id,
        this.name,
        this.slug,
        this.productCount,
        this.description,
        this.contactNumber,
        this.contactEmail,
        this.address,
        this.latitude,
        this.longitude,
        this.distance,
        this.timing,
        this.logo,
        this.banner,
        this.createdAt,
        this.updatedAt,
        this.verificationStatus,
        this.visibilityStatus,
        this.status,
      this.avgProductsRating,
      this.avgStoreRating,
      this.totalStoreFeedback,
      });

  StoreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    productCount = json['product_count'];
    description = json['description'];
    contactNumber = json['contact_number'];
    contactEmail = json['contact_email'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = double.parse(json['distance'].toString());
    timing = json['timing'];
    logo = json['logo'];
    banner = json['banner'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    verificationStatus = json['verification_status'];
    visibilityStatus = json['visibility_status'];
    status =
    json['status'] != null ? Status.fromJson(json['status']) : null;
    avgProductsRating = json['avg_products_rating'];
    avgStoreRating = json['avg_store_rating'];
    totalStoreFeedback = json['total_store_feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['product_count'] = productCount;
    data['description'] = description;
    data['contact_number'] = contactNumber;
    data['contact_email'] = contactEmail;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['timing'] = timing;
    data['logo'] = logo;
    data['banner'] = banner;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['verification_status'] = verificationStatus;
    data['visibility_status'] = visibilityStatus;
    data['avg_products_rating'] = avgProductsRating;
    data['avg_store_rating'] = avgStoreRating;
    data['total_store_feedback'] = totalStoreFeedback;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Status {
  bool? isOpen;
  String? status;

  Status({this.isOpen, this.status});

  Status.fromJson(Map<String, dynamic> json) {
    isOpen = json['is_open'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_open'] = isOpen;
    data['status'] = status;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
