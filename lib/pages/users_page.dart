import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/models/user_model.dart';


class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    UserModel(uid: '1', nombre: 'Alexa', email: 'test1@test.com', online: true),
    UserModel(uid: '2', nombre: 'Fernando', email: 'test2@test.com', online: false),
    UserModel(uid: '3', nombre: 'Pedro', email: 'test3@test.com', online: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Nombre', style: TextStyle(
          color: Colors.black54
        )),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54), 
          onPressed: (){}
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            // child: Icon(Icons.check_circle, color: Colors.blue[400],),
            child: Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _loadUsers,
        // enablePullDown: true,
        // header: WaterDropHeader(
        //   complete: Icon(Icons.check, color: Colors.blue[400]),
        //   waterDropColor: Colors.blue[400],
        // ),
        child: _listViewUsers(),
      )
   );
  }

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _userListTile(users[i]), 
      separatorBuilder: (_, i) => Divider(), 
      itemCount: users.length
    );
  }

  ListTile _userListTile(UserModel user) {
    return ListTile(
      title: Text(user.nombre),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.nombre.substring(0,2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green[300] : Colors.red,
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }

  _loadUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}