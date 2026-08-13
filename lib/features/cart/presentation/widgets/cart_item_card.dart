import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/common/image_with_shimmer.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:bite_go/core/utils/price_formatter.dart';
import 'package:bite_go/features/cart/data/models/cart_item.dart';
import 'package:bite_go/features/home/presentation/widgets/home_success_view/quantity_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    super.key,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.backgroundPrimary,
        borderRadius: BorderRadius.circular(context.radius.md),
        boxShadow: context.shadow.sm,
      ),
      child: Padding(
        padding: context.space.all(context.space.smMd),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radius.sm),
              child: SizedBox(
                width: context.iconSize.thumbnail,
                height: context.iconSize.thumbnail,
                child: ImageWithShimmer(imageUrl: item.food.imageUrl),
              ),
            ),
            AppGap.w(context.space.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyle.title.copyWith(
                      fontSize: context.fontSize.md,
                      color: context.color.textPrimary,
                    ),
                  ),
                  AppGap.h(context.space.xs),
                  Text(
                    formatPrice(item.food.price, withUnit: true),
                    style: context.textStyle.title.copyWith(
                      fontSize: context.fontSize.sm,
                      color: context.color.primary,
                    ),
                  ),
                  AppGap.h(context.space.smMd),
                  Row(
                    children: [
                      QuantityControl(
                        quantity: item.quantity,
                        onIncrement: onIncrement,
                        onDecrement: onDecrement,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onRemove,
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          AppAssets.svgsRemove,
                          key: const Key('cart_remove_item'),
                          width: context.iconSize.sm,
                          height: context.iconSize.sm,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
