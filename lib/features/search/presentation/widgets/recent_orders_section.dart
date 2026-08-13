import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/features/search/data/models/order_model.dart';
import 'package:bite_go/features/search/presentation/widgets/recent_order_card.dart';
import 'package:bite_go/features/search/presentation/widgets/search_section_header.dart';
import 'package:flutter/material.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({required this.orders, super.key});

  final List<OrderModel> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SearchSectionHeader(title: AppStrings.searchMyRecentOrders),
        AppGap.h(context.space.smMd),
        for (var index = 0; index < orders.length; index++) ...[
          if (index > 0) AppGap.h(context.space.smMd),
          RecentOrderCard(order: orders[index]),
        ],
      ],
    );
  }
}