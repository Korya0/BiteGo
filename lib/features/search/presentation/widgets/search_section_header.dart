import 'package:bite_go/core/theme/fonts/app_text_styles.dart';
import 'package:bite_go/core/utils/context_extension.dart';
import 'package:flutter/material.dart';

class SearchSectionHeader extends StatelessWidget {
  const SearchSectionHeader({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.font15Medium(context).copyWith(
        color: context.color.textPrimaryStrong,
      ),
    );
  }
}