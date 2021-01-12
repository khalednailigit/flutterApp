import 'package:flutter/material.dart';
import 'package:flutterapp/ui/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_debounce/easy_debounce.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onFetchScroll);
    Provider.of<HomeProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users List"),
      ),
      body: Builder(
        builder: (context) {
          final userData = context.watch<HomeProvider>().userData;

          switch (userData.state) {
            case UserFetchingState.Success:
              return ListView.builder(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                itemCount: userData.isLastpage
                    ? userData.pageableUsers.data.length
                    : userData.pageableUsers.data.length + 1,
                itemBuilder: (context, index) {
                  return index < userData.pageableUsers.data.length
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28)),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.transparent,
                                child: Image.network(
                                  userData.pageableUsers.data[index].avatar,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(userData
                                    .pageableUsers.data[index].firstName +
                                " " +
                                userData.pageableUsers.data[index].lastName),
                            subtitle:
                                Text(userData.pageableUsers.data[index].email),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              );
            case UserFetchingState.Failed:
              return Center(
                child: Text("error occured while fetching users"),
              );
            default:
              return Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }

  bool get _isFetchBottom {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      return maxScroll == null ? false : currentScroll >= (maxScroll * 0.9);
    }
    return false;
  }

  void _onFetchScroll() {
    if (_isFetchBottom) {
      EasyDebounce.debounce('paginationDebounce', Duration(milliseconds: 500),
          () => {Provider.of<HomeProvider>(context, listen: false).paginate()});
    }
  }
}
