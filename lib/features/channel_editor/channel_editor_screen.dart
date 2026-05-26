import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/chat.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_bloc.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';
import 'package:kepleomax/features/channel_editor/data/channel_editor_repository.dart';

class ChannelEditorScreen extends StatelessWidget {
  const ChannelEditorScreen({
    required this.channelData,
    required this.onSave,
    super.key,
  });

  final ChannelData? channelData;
  final ValueChanged<ChannelData>? onSave;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        /// TODO not working
        if (didPop) return;

        _showGoBackDialog(context);
      },
      child: BlocProvider<ChannelEditorBloc>(
        create: (context) => ChannelEditorBloc(
          repository: ChannelEditorRepositoryImpl(
            channelApi: Dependencies.of(context).channelApi,
          ),
          channelId: channelData?.id,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              channelData == null ? 'Create Channel' : 'Edit Channel',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: KlmBackButton(onPressed: () => _showGoBackDialog(context)),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
            child: _Body(initialChannelData: channelData, onSave: onSave),
          ),
        ),
      ),
    );
  }

  void _showGoBackDialog(BuildContext context) {
    AppNavigator.showGeneralDialog(
      context,
      barrierDismissible: true,
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Discard all changes?'),
        actions: [
          TextButton(
            onPressed: () {
              AppNavigator.pop(context);
            },
            style: TextButton.styleFrom(overlayColor: Colors.red),
            child: const Text('Discard', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Keep', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({required this.initialChannelData, required this.onSave});

  final ChannelData? initialChannelData;
  final ValueChanged<ChannelData>? onSave;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController(text: '${flavor.baseUrl}/');
  bool _showNameErrors = false;
  bool _showTagErrors = false;

  @override
  void initState() {
    if (widget.initialChannelData != null) {
      final data = widget.initialChannelData!;
      _nameController.text = data.name;
      _descriptionController.text = data.description;
      _tagController.text = data.fullTag;
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChannelEditorBloc, ChannelEditorState>(
      listener: (context, state) {
        if (state is ChannelEditorStateMessage) {
          context.showSnackBar(
            text: state.message,
            color: state.isError ? Colors.red : Colors.black,
          );
        }

        if (state is ChannelEditorStateExit) {
          if (state.message != null) {
            Fluttertoast.showToast(msg: state.message!);
          }

          AppNavigator.pop(context);

          widget.onSave?.call(state.newChannelData);
        }
      },
      buildWhen: (oldState, newState) {
        if (newState is! ChannelEditorStateBase) return false;

        if (oldState is! ChannelEditorStateBase) return true;

        return oldState.data != newState.data;
      },
      builder: (context, state) {
        if (state is! ChannelEditorStateBase) return const SizedBox();
        final data = state.data;

        final currentValues = ChannelEditingUiData(
          name: _nameController.text,
          description: _descriptionController.text,
          tag: _tagController.text.substring('${flavor.baseUrl}/'.length),
        );
        final initialValues = ChannelEditingUiData.fromChannelData(
          widget.initialChannelData,
        );
        final bool hasChanges = currentValues != initialValues;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 60,
                    width: 60,
                    child: ClipOval(
                      child: ChannelDefaultIconWidget(),
                      // child: _imageUrl == null || _imageUrl!.isEmpty
                      //     ? const DefaultChannelIconWidget()
                      //     : _isImageEdited
                      //     ? Image.file(File(_imageUrl!), fit: BoxFit.cover)
                      //     : KlmCachedImage(
                      //   imageUrl: flavor.imageUrl + _imageUrl!,
                      //   width: context.imageMaxWidth,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: KlmTextField(
                      controller: _nameController,
                      readOnly: data.isLoading,
                      label: 'Channel name',
                      validators: [channelNameValidator],
                      onFocusLost: () {
                        setState(() {
                          _showNameErrors = true;
                        });
                      },
                      showErrors: _showNameErrors,
                      onChanged: (s) {
                        /// for update button status
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose a name and photo for your channel',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(),
              const SizedBox(height: 24),
              KlmTextField(
                controller: _descriptionController,
                readOnly: data.isLoading,
                label: 'Description',
                showErrors: _showNameErrors,
                multiline: true,
                maxLength: 200,
                onChanged: (v) {
                  /// for update button status
                  setState(() {});
                },
              ),
              const SizedBox(height: 24),
              KlmTextField(
                controller: _tagController,
                readOnly: data.isLoading,
                hint: 'Channel tag',
                maxLength: '${flavor.baseUrl}/'.length + 32,
                showCounter: false,
                validators: [channelTagValidator],
                onFocusLost: () {
                  setState(() {
                    _showTagErrors = true;
                  });
                },
                showErrors: _showTagErrors,
                onChanged: (v) {
                  if (!v.startsWith('${flavor.baseUrl}/')) {
                    _tagController.text = '${flavor.baseUrl}/';
                  }

                  /// for update button status
                  setState(() {});
                },
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose a tag for the url',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              KlmTextButton(
                onPressed: () {
                  setState(() {
                    _showNameErrors = true;
                    _showTagErrors = true;
                  });

                  context.read<ChannelEditorBloc>().add(
                    widget.initialChannelData == null
                        ? ChannelEditorEventCreate(channelEditingData: currentValues)
                        : ChannelEditorEventSaveChanges(
                            channelEditingData: currentValues,
                          ),
                  );
                },
                enabled:
                    channelNameValidator(_nameController.text) == null &&
                    channelTagValidator(_tagController.text) == null &&
                    hasChanges,
                isLoading: data.isLoading,
                text: widget.initialChannelData == null ? 'Create' : 'Save changes',
              ),
            ],
          ),
        );
      },
    );
  }
}
