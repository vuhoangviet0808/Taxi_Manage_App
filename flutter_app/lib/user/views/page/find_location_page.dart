import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../models/search_infor.dart';
import '../../services/find_location_services.dart';

class FindLocationPage extends StatefulWidget {
  const FindLocationPage({super.key});

  @override
  State<FindLocationPage> createState() => _FindLocationPageState();
}

class _FindLocationPageState extends State<FindLocationPage> {
  List<Feature> items = [];
  final FindLocationService _findLocationService = FindLocationService();

  void placeAutoComplete(String val) async {
    await _findLocationService.addressSuggestion(val).then((value) {
      setState(() {
        items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm địa điểm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            TextField(
              onChanged: (val) {
                if (val != '') {
                  placeAutoComplete(val);
                } else {
                  items.clear();
                  setState(() {});
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                prefixIcon: Icon(Icons.place, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Colors.orange,
                    width: 2.0,
                  ),
                ),
                hintText: 'Nhập điểm đến',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ...items
                .map((e) => ListTile(
                      leading: const Icon(Icons.place),
                      title: Text(e.properties?.name ?? 'Không tìm thấy địa điểm phù hợp'),
                    ))
                .toList()
          ],
        ),
      ),
    );
  }
}
