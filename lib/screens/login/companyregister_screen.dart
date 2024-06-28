import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/custom_textfield.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:student_hub/services/profile_service.dart';
import 'package:student_hub/utils/api_util.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/models/enums/enum_numberpeople.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CompanyRegisterScreen extends StatefulWidget {
  const CompanyRegisterScreen({super.key});

  @override
  State<CompanyRegisterScreen> createState() => _CompanyRegisterScreenState();
}

class _CompanyRegisterScreenState extends State<CompanyRegisterScreen> {
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final descriptionController = TextEditingController();
  EnumNumberPeople? _numberPeople = EnumNumberPeople.one;

  @override
  void dispose() {
    companyNameController.dispose();
    websiteController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  // change size of company
  void onChangedNumberPeople(EnumNumberPeople? value) {
    setState(() {
      _numberPeople = value;
    });
  }

  // create profile
  void onCreatedProfile() async {
    // get token which is an app state
    final token = Provider.of<UserProvider>(context, listen: false).token;

    // get response of API POST create-company-profile
    final response = await ProfileService.createCompanyProfile(
      companyName: companyNameController.text,
      size: _numberPeople!.value,
      website: websiteController.text,
      description: descriptionController.text,
      token: token!,
    );

    // handle the response
    if (response.statusCode == StatusCode.created.code) {
      // created company profile successfully
      // save the company-profile to app state
      final result = ApiUtil.getResult(response);

      Provider.of<UserProvider>(context, listen: false)
          .saveCompanyAfterCreatedCompanyProfile(
        id: result['id'],
        companyName: result['companyName'],
        website: result['website'],
        description: result['description'],
        size: EnumNumberPeople.toNumberPeople(result['size']),
      );

      // then switch to the welcome screen
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: AppLocalizations.of(context)!.createYourCompanyProfileSuccessfully,
        textSubmit: 'Ok',
        submit: null,
      );

      // auto switch to the welcome screen
      NavigationUtil.toWelcomeScreen(context);
      return;
    } else if (response.statusCode == StatusCode.unauthorized.code) {
      // expire token
      ApiUtil.handleExpiredToken(context: context);
      return;
    } else {
      // others
      ApiUtil.handleOtherStatusCode(context: context);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: () {}, currentContext: context),
      body: InitialBody(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child:
                      CustomText(text: AppLocalizations.of(context)!.welcomeToStudentHub, isBold: true)),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                  text:
                      AppLocalizations.of(context)!.howManyPeopleAreInYourCompany),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(text: AppLocalizations.of(context)!.companySize,
                  isBold: true),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                chooseNumber(EnumNumberPeople.one, EnumNumberPeople.one.name),
                chooseNumber(EnumNumberPeople.two_to_nine,
                    EnumNumberPeople.two_to_nine.name),
                chooseNumber(EnumNumberPeople.ten_to_nightynine,
                    EnumNumberPeople.ten_to_nightynine.name),
                chooseNumber(EnumNumberPeople.hundred_to_thousand,
                    EnumNumberPeople.hundred_to_thousand.name),
                chooseNumber(EnumNumberPeople.more_than_thousand,
                    EnumNumberPeople.more_than_thousand.name),
              ]),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.companyName,
                isBold: true,
              ),
              CustomTextfield(
                controller: companyNameController,
                hintText: "",
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.website,
                isBold: true,
              ),
              CustomTextfield(
                controller: websiteController,
                hintText: "",
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                text: AppLocalizations.of(context)!.description,
                isBold: true,
              ),
              CustomTextfield(
                controller: descriptionController,
                hintText: "",
                maxLines: 2,
              ),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              Container(
                alignment: Alignment.topRight,
                child: CustomButton(
                  onPressed: onCreatedProfile,
                  text:AppLocalizations.of(context)!.continu,
                ),
              ),
              const SizedBox(height: SpacingUtil.mediumHeight)
            ],
          ),
        ),
      ),
    );
  }

  Widget chooseNumber(EnumNumberPeople numberpeople, String text) {
    return Row(
      children: [
        Radio<EnumNumberPeople>(
          activeColor: Theme.of(context).colorScheme.onPrimary,
          value: numberpeople,
          groupValue: _numberPeople,
          onChanged: onChangedNumberPeople,
        ),
        CustomText(text: text)
      ],
    );
  }
}