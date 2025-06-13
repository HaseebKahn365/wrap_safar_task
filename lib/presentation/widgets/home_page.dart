import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:wrap_safar_task/core/theme_provider.dart';
import 'package:wrap_safar_task/domain/entities/anayltics_entity.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_event.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_state.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_bloc.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_event.dart';
import 'package:wrap_safar_task/presentation/blocs/user_bloc/user_state.dart';
import 'package:wrap_safar_task/services/rewarded_ad_manager.dart';

import 'buttons.dart'; // Import the new buttons

/*
Purpose of the wrap_safar_task app:
store username, number of ads viewed and score in the user entity
store the type of event, success/fail status, additional infromation in the AnalyticsEntity

User interface view:
first display the username in a text field that saves the user name on submit
then number of ads viewed
then score for the number of ads viewed

then a giant divider
number of events logged, successful, failed

then giant divider
show rewarded ad button

 */

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Dispatch initial events to load data
    context.read<UserBloc>().add(const UserInfoRequestedEvent());
    context.read<AnalyticsBloc>().add(const LoadAnalyticsLogsEvent());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: theme.themeData,
      child: MultiBlocListener(
        listeners: [
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User Error: ${state.message}')),
                );
              } else if (state is UserLoaded) {
                _usernameController.text = state.user.userName;
                // After user info is loaded, or saved, refresh analytics
                context.read<AnalyticsBloc>().add(
                  const LoadAnalyticsLogsEvent(),
                );
              }
            },
          ),
          BlocListener<AnalyticsBloc, AnalyticsState>(
            listener: (context, state) {
              if (state is AnalyticsError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Analytics Error: ${state.message}')),
                );
              } else if (state is AnalyticsLogSaved) {
                // Optionally, refresh logs after saving, or show a confirmation
                context.read<AnalyticsBloc>().add(
                  const LoadAnalyticsLogsEvent(),
                );
              } else if (state is AnalyticsLogsDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All analytics logs deleted.')),
                );
                context.read<AnalyticsBloc>().add(
                  const LoadAnalyticsLogsEvent(),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 15,
                  right: 20,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    const Text(
                      'Wrap Safar Task',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        theme.toggleTheme();
                        context.read<AnalyticsBloc>().add(
                          SaveAnalyticsLogEvent(
                            AnalyticsEntity(
                              analyticsType: EventType.themeChange,
                              params: {
                                'theme_mode':
                                    theme.isDarkMode ? 'light' : 'dark',
                                'timestamp': DateTime.now().toIso8601String(),
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    color: theme.pureWhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Adjusted for better layout
                      children: [
                        const SizedBox(height: 16.0),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            String currentUsername = '';
                            if (state is UserLoaded) {
                              currentUsername = state.user.userName;
                              // Ensure controller is updated if state changes elsewhere
                              if (_usernameController.text != currentUsername) {
                                _usernameController.text = currentUsername;
                              }
                            }
                            return TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (value) {
                                final currentState =
                                    context.read<UserBloc>().state;
                                int adsViewed = 0;
                                int score = 0;
                                if (currentState is UserLoaded) {
                                  adsViewed = currentState.user.adsViewed;
                                  score = currentState.user.score;
                                }
                                context.read<UserBloc>().add(
                                  UserInfoSaveEvent(
                                    userName: value,
                                    adsViewed:
                                        adsViewed, // Preserve existing values
                                    score: score, // Preserve existing values
                                  ),
                                );
                                context.read<AnalyticsBloc>().add(
                                  SaveAnalyticsLogEvent(
                                    AnalyticsEntity(
                                      analyticsType: EventType.buttonClick,
                                      params: {
                                        'button_name': 'save_username',
                                        'username': value,
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16.0),
                        BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            int adsViewed = 0;
                            int score = 0;
                            if (state is UserLoaded) {
                              adsViewed = state.user.adsViewed;
                              score = state.user.score;
                            } else if (state is UserLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ads Viewed: $adsViewed',
                                  style: TextStyle(
                                    color: theme.onPureWhite,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Score: $score',
                                  style: TextStyle(
                                    color: theme.onPureWhite,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const Divider(
                          height: 30,
                          thickness: 1,
                        ), // Adjusted divider
                        BlocBuilder<AnalyticsBloc, AnalyticsState>(
                          builder: (context, state) {
                            int eventsLogged = 0;
                            int successfulEvents =
                                0; // Assuming you might add this logic
                            int failedEvents =
                                0; // Assuming you might add this logic

                            if (state is AnalyticsLoaded) {
                              eventsLogged = state.logs.length;
                              // You might want to iterate through logs to count successful/failed
                              // For now, just showing total logs.
                            } else if (state is AnalyticsLoading &&
                                state is! AnalyticsInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Events Logged: $eventsLogged',
                                  style: TextStyle(
                                    color: theme.onPureWhite,
                                    fontSize: 16,
                                  ),
                                ),
                                // Placeholder for successful/failed events
                                Text(
                                  'Successful Events: $successfulEvents',
                                  style: TextStyle(
                                    color: theme.onPureWhite,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Failed Events: $failedEvents',
                                  style: TextStyle(
                                    color: theme.onPureWhite,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const Divider(
                          height: 30,
                          thickness: 1,
                        ), // Adjusted divider
                        Center(
                          child: TapDebouncer(
                            cooldown: const Duration(seconds: 2),
                            onTap: () async {
                              final userState = context.read<UserBloc>().state;
                              if (userState is UserLoaded) {
                                await rewardedAdManager.showRewardedAd(() {
                                  log('Rewarded ad completed!');
                                  final newScore = userState.user.score + 10;
                                  final newAdsViewed =
                                      userState.user.adsViewed + 1;
                                  context.read<UserBloc>().add(
                                    UserInfoSaveEvent(
                                      userName: userState.user.userName,
                                      adsViewed: newAdsViewed,
                                      score: newScore,
                                    ),
                                  );
                                  context.read<AnalyticsBloc>().add(
                                    SaveAnalyticsLogEvent(
                                      AnalyticsEntity(
                                        analyticsType: EventType.adEvent,
                                        params: {
                                          'ad_event_type': 'rewarded_completed',
                                          'score_awarded': 10,
                                        },
                                      ),
                                    ),
                                  );
                                });
                                // Log ad shown attempt
                                context.read<AnalyticsBloc>().add(
                                  SaveAnalyticsLogEvent(
                                    AnalyticsEntity(
                                      analyticsType: EventType.adEvent,
                                      params: {
                                        'ad_event_type':
                                            'rewarded_shown_attempt',
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'User data not loaded yet. Please try again.',
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (
                              BuildContext context,
                              TapDebouncerFunc? onTap,
                            ) {
                              return CustomElevatedButton(
                                onPressed: onTap,
                                text:
                                    onTap == null
                                        ? 'Loading Ad...'
                                        : 'Show rewarded ad',
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: CustomElevatedButton(
                            onPressed: () {
                              context.read<AnalyticsBloc>().add(
                                const DeleteAllAnalyticsLogsEvent(),
                              );
                              context.read<AnalyticsBloc>().add(
                                SaveAnalyticsLogEvent(
                                  AnalyticsEntity(
                                    analyticsType: EventType.buttonClick,
                                    params: {
                                      'button_name': 'delete_analytics_logs',
                                    },
                                  ),
                                ),
                              );
                            },
                            text: 'Delete All Analytics Logs',
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
