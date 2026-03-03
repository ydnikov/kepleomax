import 'package:flutter/material.dart';

void showMessagesMenu(
  BuildContext context, {
  required GlobalKey globalKey,
  required bool isCurrentUser,
  required List<MessageMenuItem> items,
}) {
  final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return;
  final pos = renderBox.localToGlobal(Offset.zero);

  showMenu(
    context: context,
    requestFocus: false,
    color: Colors.grey.shade50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    position: RelativeRect.fromRect(
      Rect.fromLTRB(
        pos.dx,
        pos.dy + renderBox.size.height,
        isCurrentUser ? 1000 : 0,
        0,
      ),
      Offset.zero & renderBox.size,
    ),
    items: items
        .map(
          (item) => PopupMenuItem<void>(
            key: item.key,
            onTap: item.onTap,
            child: Row(
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: item.color,
                  ),
                ),
                const Spacer(),
                Icon(item.icon, color: item.color),
              ],
            ),
          ),
        )
        .toList(),
  );
}

class MessageMenuItem {
  MessageMenuItem(
    this.name,
    this.icon,
    this.onTap, {
    this.color = Colors.black,
    this.key,
  });

  final String name;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Key? key;
}
