import 'package:datn_cntt304_bandogiadung/views/TrangChu/SearchSP.dart';
import 'package:flutter/material.dart';

class SearchBar_SP extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _onSearch(BuildContext context) {
    String query = _controller.text;
    if (query.isNotEmpty) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => SearchResultScreen(query: query, maKH: 'KH1',),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (value) => _onSearch(context),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF4F4F4),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
              color: Colors.transparent), // Viền khi không được chọn
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide:
              const BorderSide(color: Colors.transparent), // Viền khi được chọn
        ),
        prefixIcon: Image.asset('assets/icons/search.png'),
        hintText: 'Tìm kiếm',
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
        ),
      ),
    );
  }
}
