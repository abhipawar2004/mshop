import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hyper_local/screens/product_detail_page/widgets/qa_card.dart';

import '../../../../utils/widgets/custom_scaffold.dart';
import '../../bloc/product_faq_bloc/product_faq_bloc.dart';

class FaqListPage extends StatefulWidget {
  final String productSlug;
  const FaqListPage({super.key, required this.productSlug});

  @override
  State<FaqListPage> createState() => _FaqListPageState();
}

class _FaqListPageState extends State<FaqListPage> {

  @override
  void initState() {
    // TODO: implement initState
    context.read<ProductFAQBloc>().add(FetchProductFAQ(productSlug: widget.productSlug));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Frequently asked questions',
      showAppBar: true,
      showViewCart: false,
      body: BlocBuilder<ProductFAQBloc, ProductFAQState>(
        builder: (context, state) {
          if (state is ProductFAQLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductFAQLoaded) {
            final faqData = state.productData;
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              itemCount: faqData.first.data.length,
              itemBuilder: (context, index) {
                final faq = faqData.first.data[index];
                return SizedBox(
                  width: 250.w,
                  child: QaCard(
                    question: faq.question,
                    answer: faq.answer,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
