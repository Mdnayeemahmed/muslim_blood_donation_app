import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muslim_blood_donor_bd/view/update_user/userdetail.dart';
import '../../model/user_model.dart';

class UserListScreen extends StatefulWidget {
  final String uid;

  const UserListScreen({super.key, required this.uid});

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late TextEditingController _searchController;
  late Stream<List<UserModel>> _userStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _userStream = FirebaseFirestore.instance
        .collection('user_data_collection')
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs
            .map((doc) => UserModel.fromJson(doc.data()))
            .where(
          (user) {
            print(widget.uid);
            return user.userId != widget.uid;
          },
        ).toList();
      },
    );
  }

  void filterUsers(String query) {
    setState(() {
      _userStream = FirebaseFirestore.instance
          .collection('user_data_collection')
          .snapshots()
          .map(
        (querySnapshot) {
          return querySnapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .where(
            (user) {
              final name = user.userName?.toLowerCase() ?? '';
              final phone = user.userPhone?.toLowerCase() ?? '';
              return name.contains(query.toLowerCase()) ||
                  phone.contains(query.toLowerCase());
            },
          ).toList();
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search (Name or Phone)',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterUsers,
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AspectRatio(
                    aspectRatio: 1.0, // Set the aspect ratio to 1.0 for a perfect circle
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('No data available');
                } else {
                  final userList = snapshot.data!;
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return ListTile(
                        title: Text(user.userName ?? 'No Name'),
                        subtitle: Text(user.userPhone ?? 'No Phone'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserDetailScreen(user: user),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
