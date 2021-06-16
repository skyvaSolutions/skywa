import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:skywa/Global&Constants/globalsAndConstants.dart';
import 'package:skywa/Providers/searchProvider.dart';
import 'package:skywa/components/businessWidget.dart';

class SearchPage extends StatefulWidget {
  static const String id = 'searchScreen';

  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final search = Provider.of<searchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 20,
        title: TextField(
          onChanged: search.searching,
          style: GoogleFonts.poppins(
            fontSize: 19,
          ),
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: IconButton(
                onPressed: () {
                  search.backPressed();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            suffixIcon: Icon(Icons.clear, color: Colors.white),
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: search.isSearching == true
              ? search.searchdata.length
              : nearbyQs.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BusinessWidget(
                name: search.isSearching == true
                    ? search.searchdata[index].companyName
                    : nearbyQs[index].companyName,
                address: search.isSearching == true
                    ? search.searchdata[index].address
                    : nearbyQs[index].address,
              ),
            );
          }),
    );
  }
}
