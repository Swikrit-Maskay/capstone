import 'package:flutter/material.dart';

// JobDetailsPage takes a job object as a parameter
class JobDetailsPage extends StatelessWidget {
  final Map<String, dynamic> job;

  // Constructor to accept the job data
  JobDetailsPage({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job['Title'] ?? 'Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['Title'] ?? 'No title available',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Company: ${job['Company'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Location: ${job['City'] ?? 'Unknown'}, ${job['State_Name'] ?? 'Unknown'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Position: ${job['Position'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${job['Status'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Provider: ${job['Provider'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16),
            ),
            // Add more fields as needed based on the dataset
          ],
        ),
      ),
    );
  }
}
