enum SortType {
  relevance,
  priceLowToHigh,
  priceHighToLow,
  averageRated,
  bestSeller,
  featured,
}

class SortOption {
  final SortType type;
  final String displayName;
  final String apiValue;

  const SortOption({
    required this.type,
    required this.displayName,
    required this.apiValue,
  });

  static const List<SortOption> sortOptions = [
    SortOption(
      type: SortType.relevance,
      displayName: 'Relevance (default)',
      apiValue: 'relevance',
    ),
    SortOption(
      type: SortType.priceLowToHigh,
      displayName: 'Price (low to high)',
      apiValue: 'price_asc',
    ),
    SortOption(
      type: SortType.priceHighToLow,
      displayName: 'Price (high to low)',
      apiValue: 'price_desc',
    ),
    SortOption(
      type: SortType.averageRated,
      displayName: 'Top Rated',
      apiValue: 'avg_rated',
    ),
    SortOption(
      type: SortType.bestSeller,
      displayName: 'Best Seller',
      apiValue: 'best_seller',
    ),
    SortOption(
      type: SortType.featured,
      displayName: 'Featured',
      apiValue: 'featured',
    ),
  ];

  static SortOption getSortOptionByType(SortType type) {
    return sortOptions.firstWhere((option) => option.type == type);
  }

  static SortOption getSortOptionByApiValue(String apiValue) {
    return sortOptions.firstWhere(
          (option) => option.apiValue == apiValue,
      orElse: () => sortOptions.first,
    );
  }
}
