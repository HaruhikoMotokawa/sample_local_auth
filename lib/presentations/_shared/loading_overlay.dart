import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  // ローディングオーバーレイを表示
  static void show(BuildContext context) {
    if (_overlayEntry != null) return; // 既に表示中の場合は何もしない

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 半透明の背景
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // インジケータを中央に表示
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );

    // オーバーレイにエントリを挿入
    overlay.insert(_overlayEntry!);
  }

  // ローディングオーバーレイを非表示
  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
