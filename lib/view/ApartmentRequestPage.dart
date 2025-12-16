 import 'package:admin/services/apartment_service.dart';
import 'package:flutter/material.dart';

import '../models/apartment_model.dart';

class ApartmentRequestsPage extends StatefulWidget {
  const ApartmentRequestsPage({super.key});

  @override
  State<ApartmentRequestsPage> createState() => _ApartmentRequestsPageState();
}

class _ApartmentRequestsPageState extends State<ApartmentRequestsPage> {
  List<Apartment> apartments = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPendingApartments();
    });
  }

  Future<void> _fetchPendingApartments() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
    }

    try {
      final fetchedApartments = await ApartmentService.getPendingApartments();

      if (mounted) {
        setState(() {
          apartments = fetchedApartments;
          isLoading = false;
        });
      }

      print('تم جلب ${apartments.length} شقة معلقة');
    } catch (e) {
      print('حدث خطأ في جلب الشقق: $e');

      if (mounted) {
        setState(() {
          errorMessage = 'خطأ في الاتصال بالخادم: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _acceptApartment(int apartmentId) async {
    try {
      final success = await ApartmentService.acceptApartment(apartmentId);

      if (success && mounted) {
        // إزالة الشقة المقبولة من القائمة
        setState(() {
          apartments.removeWhere((apartment) => apartment.id == apartmentId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم قبول الشقة بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('faild accept apartment'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('خطأ في قبول الشقة: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectApartment(int apartmentId) async {
    try {
      final success = await ApartmentService.rejectApartment(apartmentId);

      if (success && mounted) {
        // إزالة الشقة المرفوضة من القائمة
        setState(() {
          apartments.removeWhere((apartment) => apartment.id == apartmentId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم رفض الشقة بنجاح'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في رفض الشقة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('خطأ في رفض الشقة: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('requests add apartment  ', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchPendingApartments,
            tooltip: 'refrech ',
          ),
          // إضافة عداد الطلبات المعلقة
          if (apartments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.orange,
                child: Text(
                  apartments.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
            ),
            SizedBox(height: 20),
            Text(
              'Loading requests..',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchPendingApartments,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text(
                  ' Try again',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (apartments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.apartment,
              color: Colors.grey,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'No rquests',
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'all requests have been processed',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _fetchPendingApartments,
              icon: const Icon(Icons.refresh),
              label: const Text(' refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
            ),
          ],
        ),
      );
    }

     return Column(
    children: [
    _buildStatsBar(),

    Expanded(
    child: RefreshIndicator(
    onRefresh: _fetchPendingApartments,
    color: Colors.black,
    child: ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: apartments.length,
    itemBuilder: (context, index) {
    final apartment = apartments[index];
    return _buildApartmentCard(apartment);
    },
    ),
    ),
    ),
    ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.grey[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('requests', apartments.length.toString(), Colors.blue),
          _buildStatItem('قيد المراجعة', apartments.length.toString(), Colors.orange),
          _buildStatItem('Done', '0', Colors.green),
          _buildStatItem('Exit', '0', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildApartmentCard(Apartment apartment) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showApartmentDetails(apartment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'ID: ${apartment.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(4),),
                              child: Text(
                                'قيد المراجعة',
                                style: TextStyle(
                                  color: Colors.orange[800],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          apartment.city.isNotEmpty && apartment.country.isNotEmpty
                              ? '${apartment.city}, ${apartment.country}'
                              : 'not defined',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 22,
                    child: Icon(Icons.apartment, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(Icons.aspect_ratio, 'space', '${apartment.space} م²'),
                  _buildDetailItem(Icons.attach_money, 'price', '${apartment.price}\$'),
                ],
              ),

              const SizedBox(height: 12),

              if (apartment.images.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 1, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'photos:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: apartment.images.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(apartment.images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 12),
              const Divider(height: 1, color: Colors.grey),
              const SizedBox(height: 12),

 // الوصفif (apartment.description != null && apartment.description!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'description:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    apartment.description!,
                    style: const TextStyle(color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Date of add : ${_formatDate(apartment.createdAt)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Spacer(),
                  if (apartment.ownerid != null)
                    Row(
                      children: [
                        const Icon(Icons.person, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '#${apartment.ownerid}',
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => _showApartmentDetails(apartment),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('show details '),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                    ),
                  ),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                            context,
                            ' reject appartment',
                            'Are you sure do you want reject?',
                                () => _rejectApartment(apartment.id),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.close, size: 16),
                            SizedBox(width: 4),
                            Text('reject'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),ElevatedButton(
                        onPressed: () {
                          _showConfirmationDialog(
                              context,
                              'accept apaertment',
                              'هل أنت متأكد من قبول هذه الشقة؟',
                                  () => _acceptApartment(apartment.id),

                           );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 36),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 16),
                            SizedBox(width: 4),
                            Text('accept'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.black, size: 20),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return date.toString();
    }
  }

  void _showConfirmationDialog(
      BuildContext context,
      String title,
      String content,
      VoidCallback onConfirm,
      ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(
              title.contains('accept') ? Icons.check_circle : Icons.cancel,
              color: title.contains('accept') ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          content,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: const Text('exit'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: title.contains('قبول') ? Colors.green : Colors.red,
            ),
            child: Text(title.contains('قبول') ? 'قبول' : 'رفض'),
          ),
        ],
      ),
    );
  }void _showApartmentDetails(Apartment apartment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                Center(

                 child: Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'تفاصيل الشقة #${apartment.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'قيد المراجعة',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildDetailRow('city', apartment.city),
            _buildDetailRow('country', apartment.country),
            _buildDetailRow('space', '${apartment.space} م²'),
            _buildDetailRow('price', '${apartment.price} \$'),
            _buildDetailRow('  number of owner', '#${apartment.ownerid}'),
            _buildDetailRow(' date of add', _formatDate(apartment.createdAt)),

            const SizedBox(height: 20),

            if (apartment.description != null && apartment.description!.isNotEmpty)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'description:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              apartment.description!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),

         if (apartment.images.isNotEmpty)
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const Text(
        'الصور:',
        style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
        ),
        itemCount: apartment.images.length,
        itemBuilder: (context, index) {
        return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
        apartment.images[index],
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
        color: Colors.grey[200],
        child: const Center(
        child: CircularProgressIndicator(),
        ),
        );
        },
        errorBuilder: (context, error, stackTrace) {
        return Container(
        color: Colors.grey[200],
        child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey),
        ),
        );
        },
        ),
        );
        },
        ),
        const SizedBox(height: 20),
        ],
        ),

         Row(
        children: [
        Expanded(
        child: ElevatedButton.icon(
        onPressed: () {
        Navigator.pop(context);
        _showConfirmationDialog(
        context,
        'رفض الشقة',
        'هل أنت متأكد من رفض هذه الشقة؟',
        () => _rejectApartment(apartment.id),
        );
        },
        icon: const Icon(Icons.close),
        label: const Text('رفض'),
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        ),
        ),
        ),
        ),
        const SizedBox(width: 16),
        Expanded(
        child: ElevatedButton.icon(
        onPressed: () {
        Navigator.pop(context);
        _showConfirmationDialog(context,
        'قبول الشقة',
        'هل أنت متأكد من قبول هذه الشقة؟',
        () => _acceptApartment(apartment.id),
        );
        },
        icon: const Icon(Icons.check),
        label: const Text('قبول'),
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        ),
        ),
        ),
        ),
        ],
        ),
        ],
        ),
        ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}