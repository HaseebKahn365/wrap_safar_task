import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';
import 'widgets/buttons.dart'; // Import the new buttons

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<WrapSafarTheme>(context);
    final RewardedAdManager rewardedAdManager = RewardedAdManager();

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
              padding: const EdgeInsets.only(top: 100.0),
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
                      Text(
                        'Explore the world with Wrap Safar',
                        style: TextStyle(
                          color: theme.onPureWhite, // Using theme textColor
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Discover new places, cultures, and experiences.',
                        style: TextStyle(
                          color: theme.onPureWhite.withOpacity(
                            0.7,
                          ), // Using theme textColor
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomOutlinedButton(
                            borderColor: theme.darkBlue,
                            onPressed: () {},
                            text: 'Explore',
                            textColor: theme.outlineLabel,
                          ),
                          CustomFilledButton(
                            backgroundColor: theme.vividOrange,
                            onPressed: () {},
                            text: 'Book Now',
                            textColor: Colors.white,
                          ),
                          CustomElevatedButton(
                            backgroundColor: theme.skyBlue,
                            onPressed: () {},
                            text: 'Details',
                            textColor: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomOutlinedButton(
                            borderColor: theme.mintGreen,
                            onPressed: () {},
                            text: 'Nature',
                            textColor: theme.onMintGreen,
                          ),
                          CustomFilledButton(
                            backgroundColor: theme.darkBlue,
                            onPressed: () {},
                            text: 'Adventure',
                            textColor: theme.onDarkBlue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            rewardedAdManager.loadRewardedAd(() {
                              log('Rewarded ad viewed! Executing function...');
                              // Add your custom function logic here
                            });
                            rewardedAdManager.showRewardedAd(() {
                              log('Rewarded ad completed!');
                            });
                          },
                          child: const Text('Show Rewarded Ad'),
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
