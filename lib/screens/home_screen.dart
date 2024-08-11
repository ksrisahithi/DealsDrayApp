import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var request = http.Request('GET', Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      setState(() {
        _data = json.decode(responseBody)['data'];
      });
    } else {
      print('Failed to load data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _data == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (_data!['banner_one'] != null) _buildBanners(_data!['banner_one']),
                  if (_data!['category'] != null) _buildCategories(_data!['category']),
                  if (_data!['banner_two'] != null) _buildBanners(_data!['banner_two']),
                ],
              ),
            ),
    );
  }

  Widget _buildBanners(List<dynamic> banners) {
    return Column(
      children: banners.map((bannerData) {
        final String bannerUrl = bannerData['banner'] ?? ''; 
        return bannerUrl.isNotEmpty ? Image.network(bannerUrl) : Container(); 
      }).toList(),
    );
  }

  Widget _buildCategories(List<dynamic> categories) {
    return Column(
      children: categories.map((categoryData) {
        final String label = categoryData['label'] ?? 'Unknown';
        final String iconUrl = categoryData['icon'] ?? '';
        return ListTile(
          leading: iconUrl.isNotEmpty ? Image.network(iconUrl) : null,
          title: Text(label),
        );
      }).toList(),
    );
  }
}
