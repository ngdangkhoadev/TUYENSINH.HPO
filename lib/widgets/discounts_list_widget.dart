import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/discount.dart';
import '../models/course_fee.dart';
import '../bloc/discount/discount_bloc.dart';
import '../bloc/discount/discount_event.dart';
import '../bloc/discount/discount_state.dart';

class DiscountsListWidget extends StatelessWidget {
  final CourseFee? selectedCourseFee;
  final Function(Discount) onDiscountSelected;

  const DiscountsListWidget({
    super.key,
    this.selectedCourseFee,
    required this.onDiscountSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountBloc, DiscountState>(
      builder: (context, state) {
        if (state is DiscountLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DiscountError) {
          return _buildErrorState(context, state.message);
        }

        if (state is DiscountLoaded) {
          if (state.discounts.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DiscountBloc>().add(const RefreshDiscounts());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.discounts.length,
                    itemBuilder: (context, index) {
                      final discount = state.discounts[index];
                      return _buildDiscountCard(context, discount);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.local_offer,
            color: Colors.red.shade700,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Danh sách gói giảm giá',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
          ),
          if (selectedCourseFee != null)
            Chip(
              label: Text(
                selectedCourseFee!.name,
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.purple.shade50,
            ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard(BuildContext context, Discount discount) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: discount.isDefault
            ? BorderSide(color: Colors.red.shade300, width: 2)
            : BorderSide.none,
      ),
      elevation: discount.isDefault ? 3 : 2,
      child: InkWell(
        onTap: () => onDiscountSelected(discount),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.local_offer,
                  color: Colors.red.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            discount.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: discount.isDefault
                                  ? Colors.red.shade700
                                  : Colors.grey.shade900,
                            ),
                          ),
                        ),
                        if (discount.isDefault)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Mặc định',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      discount.formattedFee,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<DiscountBloc>().add(const LoadDiscounts());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không có gói giảm giá nào',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

