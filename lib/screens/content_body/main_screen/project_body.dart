import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quickalert/quickalert.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/components/listview_project_items.dart';
import 'package:student_hub/models/project_model.dart';
import 'package:student_hub/services/project_service.dart';
import 'package:student_hub/utils/navigation_util.dart';
import 'package:student_hub/utils/spacing_util.dart';
import 'package:student_hub/components/custom_divider.dart';
import 'package:student_hub/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:student_hub/components/custom_future_builder.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/screens/content_body/main_screen/project/project_search.dart';
import 'package:student_hub/screens/content_body/main_screen/project/project_save.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
enum ProjectBodyType {
  main(nameRoute: ''),
  search(nameRoute: 'search'),
  saved(nameRoute: 'saved');

  final String nameRoute;

  const ProjectBodyType({required this.nameRoute});
}

class ProjectBody extends StatefulWidget {
  const ProjectBody({super.key});

  @override
  State<ProjectBody> createState() => _ProjectBody();
}

class _ProjectBody extends State<ProjectBody> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // when switch to main screen with chosen project, show the dialog welcome
      showDialogWelcome();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        // if search part, switch to it
        if (settings.name == ProjectBodyType.search.nameRoute) {
          final searchArgs = settings.arguments as List<dynamic>;
          return MaterialPageRoute(
            builder: (_) => ProjectBodySearchPart(
              parentContext: context,
              search: searchArgs[0] as String,
            ),
          );
        }
        // have no one, switch to main part
        return MaterialPageRoute(
          builder: (_) => ProjectBodyMainPart(
            parentContext: context,
          ),
        );
      },
    );
  }

  Future<void> showDialogWelcome() {
    return QuickAlert.show(
      context: context, 
      type: QuickAlertType.info,
      title: 'Welcome',
      confirmBtnText: "Next",
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      text: AppLocalizations.of(context)!.welcomeToStudentHubAMartketplace,
    );
  }
  }

class ProjectBodyMainPart extends StatefulWidget {
  final BuildContext parentContext;
  const ProjectBodyMainPart({super.key, required this.parentContext});

  @override
  State<ProjectBodyMainPart> createState() => _ProjectBodyMainPartState();
}

class _ProjectBodyMainPartState extends State<ProjectBodyMainPart> {
  String searchItem = "Search for project";
  int page = 1;
  // switch to switch account screen
  void onSwitchedToSwitchAccountScreen() {
    NavigationUtil.toSwitchAccountScreen(widget.parentContext);
  }

  final List<ProjectModel> _projects = [];
  bool isFound = true;
  Future<List<ProjectModel>> initializeProject() async {
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    String? token = userProvider.token;
    final response = await ProjectService.viewProject(token: token!,page: page);
    if (response.statusCode == 404){
      isFound = false;
      return [];
    }else{
      isFound = true;
      return ProjectModel.fromResponse(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        onPressed: onSwitchedToSwitchAccountScreen,
        currentContext: context,
      ),
      body: InitialBody(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    label: CustomText(
                      text: searchItem,
                    ),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        alignment: Alignment.centerLeft),
                  ),
                ),
                const SizedBox(
                  width: 32,
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(0.2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF2DAAD4), // Màu nền của nút
                    ),
                    child: IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectBodySavedPart(
                                parentContext: context,
                              ),
                            ),
                          );
                          // after join in area saved project,
                          // reset this context by using setState
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: SpacingUtil.smallHeight,
            ),
            const CustomDivider(),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                backwardPage(context),
                const SizedBox(width: 6,),
                CustomText(text: "${AppLocalizations.of(context)!.page}: $page",size: 17,),
                const SizedBox(width: 6,),
                forwardPage(context),
            ],),
            CustomFutureBuilder<List<ProjectModel>>(
              future: initializeProject(),
              widgetWithData: (snapshot) =>
                  ListViewProjectItems(projects: snapshot.data!),
              widgetWithError: (snapshot) {
                return CustomText(
                  text: snapshot.error.toString(),
                  textColor: Colors.red,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

   IconButton forwardPage(BuildContext context) {
    return IconButton(
      iconSize: 22,
      onPressed:!isFound ? null:  (){
        setState(() {
          page++;
       });
      }, 
      icon: Icon(
        Icons.double_arrow_outlined,size:17,
        color: !isFound ? Colors.grey : Theme.of(context).colorScheme.onPrimary,
      )
    );
  }

  IconButton backwardPage(BuildContext context) {
    return IconButton(   
      iconSize: 22,
      onPressed: page == 1 ? null : (){
        setState(() {
          page--;
        });
      }, 
      icon: Icon(
        Icons.arrow_back_ios_new_rounded,
          size: 17,
          color:page == 1 ?Colors.grey : Theme.of(context).colorScheme.onPrimary,
      )
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Đặt chiều cao ban đầu tại đây
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 10.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  TextField(
                    decoration:  InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: AppLocalizations.of(context)!.searchForProject,
                    ),
                    onSubmitted: (s) async {
                      // switch to content search
                      await Navigator.pushNamed(
                        context,
                        ProjectBodyType.search.nameRoute,
                        arguments: [s, _projects],
                      );

                      // pop this context
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    height: SpacingUtil.smallHeight,
                  ),
                  ListTile(
                    title: const CustomText(text: 'proj1'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        ProjectBodyType.search.nameRoute,
                        arguments: ["proj1", _projects],
                      );
                    },
                  ),
                  ListTile(
                    title: const CustomText(text: 'project test 1'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        ProjectBodyType.search.nameRoute,
                        arguments: ["project test 1", _projects],
                      );
                    },
                  ),
                  ListTile(
                    title: const CustomText(
                      text: "Data Dev",
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        ProjectBodyType.search.nameRoute,
                        arguments: ["Data Dev", _projects],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
