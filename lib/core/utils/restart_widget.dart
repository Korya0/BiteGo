import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class RestartWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onRestart;

  const RestartWidget({
    super.key,
    required this.child,
    this.onRestart,
  });

  static void restartToHome(BuildContext context) {
    final state = context.findAncestorStateOfType<_RestartWidgetState>();
    state?._restartToHome();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  late Key _key = UniqueKey();

  void _restartToHome() {
    setState(() {
      _key = UniqueKey();
    });
    widget.onRestart?.call();
    if (mounted) {
      GoRouter.of(context).go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _key,
      child: widget.child,
    );
  }
}
