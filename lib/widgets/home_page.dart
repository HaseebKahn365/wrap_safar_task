import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:wrap_safar_task/core/theme_provider.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: theme.themeData,
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
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      theme.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      theme.toggleTheme();
                    },
                  ),
                ],
              ),
            ),

            // Main content with proper margins and padding
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16.0),
                      // Username TextField
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          // TODO: Save username
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Stats Display
                      Text(
                        'Ads Viewed: 0', // TODO: Replace with actual count
                        style: TextStyle(
                          color: theme.onPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Score: 0', // TODO: Replace with actual score
                        style: TextStyle(
                          color: theme.onPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      const Divider(height: 40, thickness: 2),
                      // Analytics Display
                      Text(
                        'Events Logged: 0', // TODO: Replace with actual count
                        style: TextStyle(
                          color: theme.onPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Successful Events: 0', // TODO: Replace with actual count
                        style: TextStyle(
                          color: theme.onPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Failed Events: 0', // TODO: Replace with actual count
                        style: TextStyle(
                          color: theme.onPureWhite,
                          fontSize: 16,
                        ),
                      ),
                      const Divider(height: 40, thickness: 2),
                      // Rewarded Ad Button
                      Center(
                        child: TapDebouncer(
                          cooldown: const Duration(seconds: 2),
                          onTap: () async {
                            await rewardedAdManager.showRewardedAd(() {
                              log('Rewarded ad completed!');
                            });
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
