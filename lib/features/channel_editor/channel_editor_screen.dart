import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/navigation/app_navigator.dart';
import 'package:kepleomax/core/presentation/channel_image_widget.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/presentation/klm_text_button.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_bloc.dart';
import 'package:kepleomax/features/channel_editor/bloc/channel_editor_state.dart';
import 'package:kepleomax/features/channel_editor/data/channel_editor_repository.dart';

class ChannelEditorScreen extends StatelessWidget {
  const ChannelEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChannelEditorBloc>(
      create: (context) => ChannelEditorBloc(
        repository: ChannelEditorRepositoryImpl(
          channelApi: Dependencies.of(context).channelApi,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create channel',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          leading: const KlmBackButton(),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: const SafeArea(child: _Body()),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController(text: 'https://kepleomax.com/');
  bool _showNameErrors = false;

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
                      onChanged: (v) {
                        setState(() {
                          _showNameErrors = v.isEmpty;
                        });
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
                validators: [],
                onFocusLost: () {},
                showErrors: _showNameErrors,
                multiline: true,
                maxLength: 200,
                onChanged: (v) {

                },
              ),
              const SizedBox(height: 24),
              KlmTextField(
                controller: _tagController,
                readOnly: data.isLoading,
                hint: 'Channel tag',
                validators: [],
                onFocusLost: () {},
                showErrors: _showNameErrors,
                onChanged: (v) {
                  if (!v.startsWith('https://kepleomax.com/')) {
                      _tagController.text = 'https://kepleomax.com/';
                  }
                },
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose a name for the url TODO',
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
                  });

                  context.read<ChannelEditorBloc>().add(
                    ChannelEditorEventCreate(name: _nameController.text),
                  );
                },
                enabled: channelNameValidator(_nameController.text) == null,
                isLoading: data.isLoading,
                text: 'Create',
              ),
            ],
          ),
        );
      },
    );
  }
}
