import 'package:bite_go/core/common/app_gap.dart';
import 'package:bite_go/core/constants/app_assets.dart';
import 'package:bite_go/core/constants/app_strings.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptySearchResult extends StatelessWidget {
  const EmptySearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.space.symmetric(horizontal: context.space.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AppAssets.svgsCouldntFindResult),
            AppGap.h(context.space.lg),
            Text(
              AppStrings.searchEmptyResult,
              textAlign: TextAlign.center,
              style: context.textStyle.body.copyWith(
                fontSize: context.fontSize.sm,
                color: context.color.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}