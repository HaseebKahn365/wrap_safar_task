import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wrap_safar_task/core/theme_provider.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_bloc.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_event.dart';
import 'package:wrap_safar_task/presentation/blocs/analytics_bloc/analytics_state.dart';

class LogsScreen extends StatelessWidget {
  const LogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Logs')),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AnalyticsLoaded) {
            final logs = state.logs;
            //sort on the basis of timestamp:
            logs.sort((a, b) {
              final aTimestamp = DateTime.parse(
                (a.params['timestamp'] ?? '1970-01-01T00:00:00.000Z') as String,
              );
              final bTimestamp = DateTime.parse(
                (b.params['timestamp'] ?? '1970-01-01T00:00:00.000Z') as String,
              );
              return bTimestamp.compareTo(
                aTimestamp,
              ); // Sort in descending order
            });

            if (logs.isEmpty) {
              return const Center(child: Text('No logs available.'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Provider.of<WrapSafarTheme>(context).pureWhite,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ListTile(
                          title: Text('Type: ${log.analyticsType.name}'),
                          subtitle: Text(
                            'Params: ${log.params.map((key, value) {
                              if (key == 'timestamp') {
                                final timestamp = DateTime.parse(value as String);
                                return MapEntry(key, timeago.format(timestamp));
                              }
                              return MapEntry(key, value);
                            })}',
                          ),
                          trailing:
                              log.isSuccess == true
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                  : const Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<AnalyticsBloc>().add(
                        const DeleteAllAnalyticsLogsEvent(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text(
                      'Delete All Logs',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AnalyticsError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No logs to read.'));
        },
      ),
    );
  }
}
