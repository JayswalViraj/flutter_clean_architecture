import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../bloc/user_list_bloc.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return sl<UserListBloc>()
        ..add(UserListRequested());
      },
      child: const UserListView(),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (context, state) {
          // Loading
          if (state is UserListLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Success
          if (state is UserListSuccess) {
            if (state.users.isEmpty) {
              return const Center(
                child: Text('No users found'),
              );
            }

            return ListView.separated(
              itemCount: state.users.length,
              padding: const EdgeInsets.all(16),
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final user = state.users[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(user.name[0]),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                );
              },
            );
          }

          // Failure
          if (state is UserListFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserListBloc>().add(
                            UserListRequested(),
                          );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}