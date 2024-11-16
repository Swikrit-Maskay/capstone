import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:classico/views/ui/authent/details.dart'; // Import the JobDetailsPage

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  List<dynamic> _searchResults = [];

  Future<void> _searchJobs() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:3000/api/search?title=${_titleController.text}&company=${_companyController.text}&city=${_cityController.text}&state=${_stateController.text}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = json.decode(response.body);
      });
    } else {
      print('Error fetching data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Job Title'),
            ),
            TextField(
              controller: _companyController,
              decoration: InputDecoration(labelText: 'Company'),
            ),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _stateController,
              decoration: InputDecoration(labelText: 'State'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchJobs,
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final job = _searchResults[index];
                  return ListTile(
                    title: Text(job['Title'] ?? 'No title'),
                    subtitle: Text('${job['Company'] ?? 'No company'} - ${job['City'] ?? 'No city'}'),
                    onTap: () {
                      // Navigate to JobDetailsPage when a job is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsPage(job: job),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
