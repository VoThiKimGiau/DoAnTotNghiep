import 'dart:convert';
import 'package:datn_cntt304_bandogiadung/config/IpConfig.dart';
import 'package:http/http.dart' as http;
import 'package:datn_cntt304_bandogiadung/models/VatChungDoiTra.dart'; // Import your model

class VatChungDoiTraController {
  final String baseUrl = '${IpConfig.ipConfig}api/vatchungdoitra';

  Future<List<VatChungDoiTra>> getAllVatChungDoiTra({String? maDoiTra}) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<VatChungDoiTra> vatChungList = data.map((item) => VatChungDoiTra.fromJson(item)).toList();
      if (maDoiTra != null) {
        vatChungList = vatChungList.where((item) => item.maDoiTra == maDoiTra).toList();
      }
      return vatChungList;
    } else {
      throw Exception('Failed to load VatChungDoiTra');
    }
  }

  // Get a VatChungDoiTra by ID
  Future<VatChungDoiTra?> getVatChungDoiTraById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return VatChungDoiTra.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  // Create a new VatChungDoiTra
  Future<VatChungDoiTra> createVatChungDoiTra(VatChungDoiTra vatChungDoiTra) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(vatChungDoiTra.toJson()),
    );

    if (response.statusCode == 201) {
      return VatChungDoiTra.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create VatChungDoiTra');
    }
  }

  // Update a VatChungDoiTra by ID
  Future<VatChungDoiTra?> updateVatChungDoiTra(String id, VatChungDoiTra vatChungDoiTra) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(vatChungDoiTra.toJson()),
    );

    if (response.statusCode == 200) {
      return VatChungDoiTra.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  // Delete a VatChungDoiTra by ID
  Future<bool> deleteVatChungDoiTra(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
