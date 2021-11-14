import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _navigationBarV2Builder(context);
  }


  Widget _navigationBarV2Builder(BuildContext context) => BottomAppBar(
    // shape: shape,
    color: Colors.white,
    child: IconTheme(
      data: IconThemeData(color: Colors.black87/*Theme.of(context).colorScheme.onPrimary*/),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.only(left: 20),
            iconSize: 36,
            icon: const Icon(Icons.home_outlined, color: Colors.black87,),
            onPressed: () {
              Navigator.pushNamed(context, '/feed');
            },
          ),
          // if (centerLocations.contains(fabLocation)) const Spacer(),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/new-post-choose-photo');
            }, child: Icon(Icons.add),
          ),
          IconButton(
            padding: EdgeInsets.only(right: 20),
            icon: const Icon(Icons.person_outline, color: Colors.black87,),
            iconSize: 36,
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
    ),
  );

  Widget _navigationBarV1Builder() => BottomNavigationBar(
    showSelectedLabels: false,
    showUnselectedLabels: false,
    // type: BottomNavigationBarType.shifting,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home"
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.green,
        // backgroundColor: Colors.green,
        icon: Icon(Icons.add),
        label: 'Business',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: 'School',
      ),
    ],
    // currentIndex: _selectedIndex,
    selectedItemColor: Colors.black87,
    // onTap: _onItemTapped,
  );
}
