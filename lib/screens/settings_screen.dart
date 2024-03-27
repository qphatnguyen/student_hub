import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_option.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/theme/theme_provider.dart';
import 'package:student_hub/utils/spacing_util.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isActivedDarkTheme = false;

  void onPressed() {}

  void onGotLanguage(String? selectedLanguage) {}

  void onChangedDarkTheme(bool value) {
    setState(() {
      isActivedDarkTheme = value;
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onPressed,
        currentContext: context,
        iconButton: null,
        title: 'Settings',
        isBack: true,
      ),
      body: InitialBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // select a language for this app
            const CustomText(
              text: 'Language:',
              isBold: true,
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            CustomOption(
              options: const ['English', 'Vietnamese'],
              onHelper: onGotLanguage,
            ),
            const SizedBox(
              height: SpacingUtil.mediumHeight,
            ),
            // turn on/off the dark theme
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  text: 'Dark theme:',
                  isBold: true,
                ),
                const SizedBox(
                  width: SpacingUtil.smallHeight,
                ),
                Switch(
                  value: isActivedDarkTheme,
                  inactiveThumbColor: Theme.of(context).colorScheme.onPrimary,
                  onChanged: onChangedDarkTheme,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
