part of '../chat_screen.dart';

class _ChatBottom extends StatelessWidget {
  const _ChatBottom({
    required this.controller,
    required this.onSend,
    required this.onEdit,
    required this.isLoading,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String>? onSend;
  final ValueChanged<String>? onEdit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Container(
        width: context.screenSize.width,
        color: Colors.white,
        constraints: const BoxConstraints(minHeight: 65, maxHeight: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end, // for multiline input case
          children: [
            /// left buttons
            _AttachFilesButton(onPressed: () {}),

            /// input field
            const SizedBox(width: 4),
            Expanded(
              child: KlmTextField(
                key: const Key('message_input_field'),
                controller: controller,
                hint: 'Message',
                onChanged: onEdit,
                multiline: true,
                maxLength: 4000,
                textCapitalization: TextCapitalization.sentences,
                showCounter: false,
                backgroundColor: Colors.grey.shade100,
                borderColor: Colors.grey.shade300,
                hintColor: Colors.grey.shade500,
              ),
            ),

            /// right buttons
            const SizedBox(width: 3),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: controller.text.isNotEmpty
                  ? _SendMessageButton(
                      onPressed: onSend == null || isLoading
                          ? null
                          : _sendButtonAction,
                    )
                  : _VoiceMessageButton(onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  void _sendButtonAction() {
    if (controller.text.isEmpty || isLoading) return;
    onSend!(controller.text.trim());
    controller.clear();
  }
}

class _SendMessageButton extends StatelessWidget {
  const _SendMessageButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('send_message_button'),
      onPressed: () {
        onPressed!();
      },
      style: IconButton.styleFrom(backgroundColor: KlmColors.primaryColor),
      icon: const Icon(Icons.arrow_upward, color: Colors.white),
    );
  }
}

class _VoiceMessageButton extends StatelessWidget {
  const _VoiceMessageButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        key: const Key('voice_message_button'),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(
          Icons.keyboard_voice_outlined,
          color: KlmColors.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}

class _AttachFilesButton extends StatelessWidget {
  const _AttachFilesButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 30,
      margin: const EdgeInsets.only(bottom: 5),
      child: IconButton(
        key: const Key('attach_media_button'),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
        ),
        icon: Transform.rotate(
          angle: math.pi / 180 * 45,
          child: const Icon(
            Icons.attach_file_sharp,
            color: KlmColors.primaryColor,
            fontWeight: FontWeight.w100,
            size: 30,
          ),
        ),
      ),
    );
  }
}
