import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/popup_notification.dart';
import 'package:student_hub/models/enums/enum_like_project.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_bulleted_list.dart';
import 'package:intl/intl.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/models/user_model.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/api_util.dart';

class ProjectItem extends StatefulWidget {
  final ProjectModel project;
  ProjectItem({Key? key, required this.project}) : super(key: key);
  @override
  State<ProjectItem> createState() => _ProjectItem();
}

class _ProjectItem extends State<ProjectItem> {
  String month = '1 - 3';
  void saveProject(int projectID, EnumLikeProject likeProject) async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );
    UserModel user = userProvider.user!;
    String? token = userProvider.token;
    final response = await ProjectService.likeProject(
        id: user.userId,
        projectID: projectID,
        likedProject: likeProject,
        token: token!);
    final body = ApiUtil.getBody(response);
    if (response.statusCode == 200) {
      await popupNotification(
        context: context,
        type: NotificationType.success,
        content: 'Saved successfully',
        textSubmit: 'Ok',
        submit: null,
      );
    } else {
      final errorDetails = body['errorDetails'];
      popupNotification(
        context: context,
        type: NotificationType.error,
        content: errorDetails.toString(),
        textSubmit: 'Ok',
        submit: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.project.projectScopeFlag == 1) {
      month = '3-6';
    }
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title: " + widget.project.title,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                  text: "Time created: " +
                      DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(widget.project.timeCreated))),
              const SizedBox(
                height: SpacingUtil.smallHeight,
              ),
              CustomText(
                  text: "Time: " +
                      month +
                      " months, ${widget.project.numberofStudent} students needed"),
              const SizedBox(
                height: SpacingUtil.mediumHeight,
              ),
              const CustomText(text: "Student are looking for"),
              CustomBulletedList(
                  listItems: widget.project.description.split(',')),
              CustomText(
                  text: "Proposals: " + widget.project.proposal.toString()),
            ],
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                saveProject(widget.project.id, EnumLikeProject.like);
              });
            },
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Color.fromARGB(255, 0, 78, 212),
              size: 30,
            ))
      ],
    );
  }
}
