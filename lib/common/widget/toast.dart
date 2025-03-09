import 'package:fluent_ui/fluent_ui.dart';

enum ToastPosition { top, bottom }

class Toast extends StatefulWidget {
  const Toast._({
    required this.message,
    required this.onDismiss,
    required this.position,
  });

  final String message;
  final ToastPosition position;
  final VoidCallback onDismiss;

  static OverlayEntry? _overlayEntry;

  @override
  State<Toast> createState() => _ToastState();

  static void show({
    required BuildContext context,
    required String message,
  }) {
    if (_overlayEntry != null) {
      dismiss();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Toast._(
          //key: const ValueKey('message'),
          message: message,
          position: ToastPosition.bottom,
          onDismiss: dismiss,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void dismiss() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  static const Duration _revealDuration = Duration(milliseconds: 200);
  static const Duration _dismissDuration = Duration(milliseconds: 400);
  static const Duration _displayDuration = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _revealDuration,
      reverseDuration: _dismissDuration,
    )..forward();

    Future.delayed(_displayDuration, () {
      if (context.mounted) {
        _animationController.reverse().whenCompleteOrCancel(widget.onDismiss);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: switch (widget.position) {
        ToastPosition.top => 0,
        ToastPosition.bottom => null,
      },
      bottom: switch (widget.position) {
        ToastPosition.top => null,
        ToastPosition.bottom => 0,
      },
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeIn,
        ),
        child: Dismissible(
          key: Key(widget.message),
          onDismissed: (_) => widget.onDismiss(),
          direction: switch (widget.position) {
            ToastPosition.top => DismissDirection.up,
            ToastPosition.bottom => DismissDirection.down,
          },
          child: Card(
            backgroundColor: FluentTheme.of(context).activeColor,
            child: Text(widget.message),
          ),
        ),
      ),
    );
  }
}
