import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kepleomax/core/di/dependencies.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/presentation/klm_app_bar.dart';
import 'package:kepleomax/core/settings/app_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  String? _version;

  @override
  void initState() {
    _settings = Dependencies.of(context).appSettings;
    PackageInfo.fromPlatform().then((info) {
      if (mounted) {
        setState(() {
          _version = info.version;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KlmAppBar(context, 'Settings', leading: const KlmBackButton()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Switcher(
              title: 'Highlight cache messages',
              value: _settings.highlightCacheMessages,
              onChanged: (value) async {
                await _settings.setHighlightCacheMessages(value);
                if (context.mounted) {
                  setState(() {});
                }
              },
            ),
            const Divider(),
            TextButton(
              onPressed: () async {
                await _settings.resetDatabase();
                Fluttertoast.showToast(msg: 'The database is reset');
              },
              style: TextButton.styleFrom(shape: const LinearBorder()),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reset local database',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
            const Divider(),
            const Spacer(),
            if (_version != null)
              Center(
                child: Text(
                  'v$_version${flavor.versionName.isEmpty ? '' : '-${flavor.versionName}'}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Switcher extends StatelessWidget {
  const _Switcher({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Switch(value: value, onChanged: onChanged),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
