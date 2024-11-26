import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:datn_cntt304_bandogiadung/models/NhanVien.dart';
import 'package:datn_cntt304_bandogiadung/controllers/NhanVienController.dart';

import 'ThemNhanVien.dart';

class EmployeeManagementScreen extends StatefulWidget {
  @override
  _EmployeeManagementScreenState createState() => _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final NhanVienController _controller = NhanVienController();
  List<NhanVien> _employees = [];
  List<NhanVien> _filteredEmployees = [];
  String _searchQuery = '';
  String _selectedPosition = 'All';
  bool _isLoading = true;
  String _errorMessage = '';

  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    primary: Colors.blue,
    secondary: Colors.orange,
    surface: Colors.white,
    background: Colors.grey[100]!,
    error: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final employeesData = await _controller.getAllEmployees();
      setState(() {
        _employees = employeesData.map((data) => NhanVien.fromJson(data)).toList();
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load employees: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredEmployees = _employees.where((employee) {
        bool matchesSearch = employee.sdt.contains(_searchQuery) ||
            employee.tenNV.toLowerCase().contains(utf8.decode(_searchQuery.toLowerCase().runes.toList()) );
        bool matchesPosition = _selectedPosition == 'All' ||utf8.decode(employee.chucVu.runes.toList())  == _selectedPosition;
        return matchesSearch && matchesPosition;
      }).toList();
    });
  }

  Future<void> _toggleEmployeeStatus(NhanVien employee) async {
    try {
      final NhanVien updatedEmployee = NhanVien(maNV: employee.maNV, tenNV: employee.tenNV, sdt: employee.sdt, email: employee.email, chucVu: employee.chucVu, tenTK: employee.tenTK, matKhau: employee.matKhau, hoatDong: !employee.hoatDong);
      final response = await _controller.updateEmployee(employee.maNV, updatedEmployee);
      if (response.statusCode == 200) {
        setState(() {
          employee.hoatDong = !employee.hoatDong;
        });
      } else {
        throw Exception('Failed to update employee status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating employee status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý nhân viên'),
        backgroundColor: colorScheme.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Tìm theo số điện thoại hoặc tên',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                  _applyFilters();
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedPosition,
              isExpanded: true,
              items: ['All', 'QUAN_LY', 'BAN_HANG','THU_KHO'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                  _applyFilters();
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: TextStyle(color: colorScheme.error)))
                : ListView.builder(
              itemCount: _filteredEmployees.length,
              itemBuilder: (context, index) {
                final employee = _filteredEmployees[index];
                return Card(
                  color: colorScheme.surface,
                  child: ListTile(
                    title: Text(employee.maNV+' - '+utf8.decode(employee.tenNV.runes.toList()) ),
                    subtitle: Text('${employee.chucVu} - ${employee.sdt}'),
                    trailing: Switch(
                      value: employee.hoatDong,
                      onChanged: (bool value) {
                        _toggleEmployeeStatus(employee);
                      },
                      activeColor: colorScheme.secondary,
                    ),
                  ),
                );
              },
            ),
          ),

        ],
      ),
      backgroundColor: colorScheme.background,

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
          if (result == true) {
            _loadEmployees();
          }
        },
        child: Icon(Icons.add),
        backgroundColor: colorScheme.secondary,
      ),
    );
  }
}

