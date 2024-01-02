import 'package:flutter/material.dart';
import 'package:flutter_authentication/main.dart';
import 'package:flutter_authentication/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    void _showList() {
      Navigator.pushNamed(context, '/home/list');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                  child: Text("Logout"), onTap: () => _logout(context)),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showList,
        child: Icon(Icons.list),
      ),
      body: FutureBuilder(
        future: AuthRepository.getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("No User"));
          }
          if (snapshot.hasData) {
            return Center(
                child: ListView.builder(
              itemCount: snapshot.data!.keys.length,
              itemBuilder: (context, index) {
                if (snapshot.data is Map<String, dynamic>) {
                  var entry = snapshot.data!.entries.elementAt(index);

                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                        color: index % 2 == 0
                            ? Colors.cyan
                            : Colors.cyan.withBlue(190)),
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(entry.key,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        entry.value,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }
              },
            ));
          }
          return const Placeholder();
        },
      ),
    );
  }

  // Function to handle logout
  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        )); // Navigate back to the previous screen
  }
}
