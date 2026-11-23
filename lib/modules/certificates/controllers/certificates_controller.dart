import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificatesController extends GetxController {
  final RxString selectedFilter = 'All'.obs;

  final List<String> filters = ['All', 'Completed'];

  final RxList<Map<String, dynamic>> certificates = <Map<String, dynamic>>[
    {
      'id': 'CERT-2026-001',
      'title': 'Flutter Development',
      'subtitle': 'Mobile App Development',
      'instructor': 'Ahmed Khan',
      'issueDate': '15 Nov 2026',
      'duration': '8 Weeks',
      'grade': 'A+',
      'status': 'Completed',
      'color': 0xFF2F6BFF,
      'icon': Icons.phone_android_rounded,
    },
    {
      'id': 'CERT-2026-002',
      'title': 'UI/UX Design Fundamentals',
      'subtitle': 'User Interface & Experience Design',
      'instructor': 'Sara Ahmed',
      'issueDate': '02 Nov 2026',
      'duration': '6 Weeks',
      'grade': 'A',
      'status': 'Completed',
      'color': 0xFF8B5CF6,
      'icon': Icons.design_services_rounded,
    },
    {
      'id': 'CERT-2026-003',
      'title': 'Laravel API Development',
      'subtitle': 'Backend Web Development',
      'instructor': 'Usman Ali',
      'issueDate': '20 Oct 2026',
      'duration': '10 Weeks',
      'grade': 'A+',
      'status': 'Completed',
      'color': 0xFF20B486,
      'icon': Icons.code_rounded,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredCertificates {
    if (selectedFilter.value == 'All') {
      return certificates.toList();
    }

    return certificates
        .where((certificate) => certificate['status'] == selectedFilter.value)
        .toList();
  }

  int get totalCertificates => certificates.length;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  void showCertificateDetails(Map<String, dynamic> certificate) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium_rounded,
                color: Color(certificate['color'] as int),
                size: 55,
              ),
              const SizedBox(height: 14),
              const Text(
                'Certificate Details',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 18),
              _detailRow('Course', certificate['title']),
              _detailRow('Certificate ID', certificate['id']),
              _detailRow('Instructor', certificate['instructor']),
              _detailRow('Issue Date', certificate['issueDate']),
              _detailRow('Duration', certificate['duration']),
              _detailRow('Grade', certificate['grade']),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    downloadCertificate(certificate);
                  },
                  child: const Text('Download Certificate'),
                ),
              ),
              TextButton(onPressed: Get.back, child: const Text('Close')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF7B8496), fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void downloadCertificate(Map<String, dynamic> certificate) {
    Get.snackbar(
      'Download Pending',
      'PDF download will be available after API integration.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(15),
    );
  }
}
