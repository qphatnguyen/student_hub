
import 'package:flutter/material.dart';
import 'package:student_hub/components/custom_appbar.dart';
import 'package:student_hub/components/custom_button.dart';
import 'package:student_hub/components/custom_text.dart';
import 'package:student_hub/components/initial_body.dart';
import 'package:student_hub/utils/spacing_util.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  
  @override
  State<MainScreen> createState() => _MainScreen();
}
void onPressed(){}

class _MainScreen extends State<MainScreen>{

  final name = 'Hai';
  int _selectedIndex = 0;
  static const TextStyle optionStyle = 
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Project(),
    Dashboard(),
    Message(),
    Notification(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(onPressed: onPressed, currentContext: context),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(
        
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Arlets',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 52, 145, 231),
        onTap: _onItemTapped,
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      
    );

  }
}

class Dashboard extends StatefulWidget{
  const Dashboard({
    super.key
  });

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{
  @override
  Widget build(BuildContext context){
    return InitialBody(
      child: Column(
        mainAxisAlignment:MainAxisAlignment.start,
        children: [
          Center(
            child: Row(
              children: [
                Text('Yours job',),
                const SizedBox(width: 180,),
                CustomButton(onPressed: onPressed, text: 'Post a job')
              ],
            ),
          ),
          SizedBox( height: SpacingUtil.largeHeight,),
          Center(
            child: CustomText(text: 'Welcome, Hai!'),
          ),
          SizedBox( height: SpacingUtil.smallHeight,),
          Center(
            child: CustomText(text: 'You have no jobs!'),
          )
        ],
      ),
    );
  }
}


class Project extends StatefulWidget{
  const Project({
    super.key
  });

  @override
  State<Project> createState() => _Project();
}
class _Project extends State<Project>{
  @override
  Widget build(BuildContext context){
    return Center(
      
    );
  }
}

class Message extends StatefulWidget{
  const Message({
    super.key
  });

  @override
  State<Message> createState() => _Message();
}
class _Message extends State<Message>{
  @override
  Widget build(BuildContext context){
    return Center(
    );
  }
}

class Notification extends StatefulWidget{
  const Notification({
    super.key
  });

  @override
  State<Notification> createState() => _Notification();
}
class _Notification extends State<Notification>{
  @override
  Widget build(BuildContext context){
    return Center(
    );
  }
}


