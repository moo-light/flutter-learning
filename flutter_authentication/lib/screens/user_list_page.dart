import 'package:flutter/material.dart';
import 'package:flutter_authentication/models/userDto.dart';
import 'package:flutter_authentication/repositories/user_repository.dart';

class UserListPage extends StatefulWidget {
  static const String routeName = '/userList';

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('UserList'),
        ),
        body: FutureBuilder(
          future: UserRepository.getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => _buildCard(snapshot, index));
            }
            if (snapshot.hasError) {
              return Text(snapshot.error.toString() );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Container _buildCard(AsyncSnapshot snapshot, int index) {
    var user = snapshot.data![index] as User;

    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(width: 2),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Container(
          decoration: MagnifierDecoration(
            shape: CircleBorder(

            )
          ),child: Text(user.id.toString(),style: Theme.of(context).textTheme.headlineSmall,)),
        title: Text("name: ${user.name}",style: Theme.of(context).textTheme.labelLarge),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("email: ${user.email}"),
            Text("role: ${user.role}"),
          ],
        ),
      ),
    );
  }
}
