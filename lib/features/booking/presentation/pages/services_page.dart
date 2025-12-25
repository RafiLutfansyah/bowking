import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/booking.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../../../core/domain/payment/payment_method.dart';
import '../../../../core/presentation/payment/payment_bloc.dart';
import '../../../../core/presentation/payment/payment_event.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDateTime;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDateTime = DateTime.now().add(const Duration(hours: 2));
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<BookingBloc>().add(LoadServices());
    context.read<BookingBloc>().add(const LoadUserBookings(AppConstants.mockUserId));
    context.read<PaymentBloc>().add(const LoadBalance(AppConstants.mockUserId));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Services'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listenWhen: (previous, current) =>
            current.createdBooking != null && previous.createdBooking != current.createdBooking,
        listener: (context, state) {
          if (state.createdBooking != null) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking created: ${state.createdBooking!.id}'),
                backgroundColor: Colors.green,
              ),
            );
            // Refresh both tabs
            context.read<BookingBloc>().add(LoadServices());
            context.read<BookingBloc>().add(const LoadUserBookings(AppConstants.mockUserId));
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search services or bookings...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildServicesTab(),
                  _buildBookingsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    return BlocBuilder<BookingBloc, BookingState>(
      buildWhen: (previous, current) =>
          previous.isServicesLoading != current.isServicesLoading ||
          previous.services != current.services ||
          previous.servicesError != current.servicesError,
      builder: (context, state) {
        if (state.isServicesLoading && state.services == null) {
          return _buildShimmerLoading();
        } else if (state.servicesError != null && state.services == null) {
          return Center(child: Text(_cleanErrorMessage(state.servicesError!)));
        } else if (state.services != null) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BookingBloc>().add(LoadServices());
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildServicesList(state.services!),
          );
        }
        return const Center(child: Text('No services available'));
      },
    );
  }

  Widget _buildBookingsTab() {
    return BlocBuilder<BookingBloc, BookingState>(
      buildWhen: (previous, current) =>
          previous.isBookingsLoading != current.isBookingsLoading ||
          previous.bookings != current.bookings ||
          previous.bookingsError != current.bookingsError,
      builder: (context, state) {
        if (state.isBookingsLoading && state.bookings == null) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.bookingsError != null && state.bookings == null) {
          return Center(child: Text(_cleanErrorMessage(state.bookingsError!)));
        } else if (state.bookings != null) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BookingBloc>().add(const LoadUserBookings(AppConstants.mockUserId));
              await Future.delayed(const Duration(milliseconds: 500));
            },
            child: _buildBookingsList(state.bookings!),
          );
        }
        return const Center(child: Text('No bookings yet'));
      },
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    // Sort bookings: upcoming first, then by date descending
    final sortedBookings = List<Booking>.from(bookings)
      ..sort((a, b) {
        final now = DateTime.now();
        final aIsUpcoming = a.dateTime.isAfter(now);
        final bIsUpcoming = b.dateTime.isAfter(now);
        if (aIsUpcoming && !bIsUpcoming) return -1;
        if (!aIsUpcoming && bIsUpcoming) return 1;
        return b.dateTime.compareTo(a.dateTime);
      });

    // Filter by search query
    final filteredBookings = sortedBookings.where((booking) {
      return booking.service.name.toLowerCase().contains(_searchQuery) ||
          booking.id.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredBookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.calendar_today,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _searchQuery.isNotEmpty ? 'No bookings found' : 'No bookings yet',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredBookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        final isUpcoming = booking.dateTime.isAfter(DateTime.now());

        return CustomCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      booking.service.name,
                      style: AppTypography.textTheme.titleLarge,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.tertiaryBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      isUpcoming ? 'Upcoming' : 'Completed',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: isUpcoming ? AppColors.success : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(Icons.access_time, size: AppSpacing.iconSmall, color: AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    DateFormat('MMM dd, yyyy \'at\' HH:mm').format(booking.dateTime),
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  if (booking.amountPaidRM > 0)
                    Text(
                      '${AppConstants.currency} ${booking.amountPaidRM.toStringAsFixed(2)}',
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        color: AppColors.roseGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (booking.amountPaidTokens > 0)
                    Text(
                      '${booking.amountPaidTokens.toInt()} ${AppConstants.tokenName}',
                      style: AppTypography.textTheme.titleMedium?.copyWith(
                        color: AppColors.roseGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const Divider(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${booking.id.length > 8 ? booking.id.substring(0, 8) : booking.id}',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    'Created: ${DateFormat('MMM dd').format(booking.createdAt)}',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.tertiaryBackground,
          highlightColor: AppColors.secondaryBackground,
          child: CustomCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Container(
              height: 120,
              color: AppColors.primaryBackground,
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesList(List<Service> services) {
    final filteredServices = services.where((service) {
      return service.name.toLowerCase().contains(_searchQuery) ||
          service.description.toLowerCase().contains(_searchQuery);
    }).toList();

    if (filteredServices.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No services found',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: filteredServices.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final service = filteredServices[index];
        return CustomCard(
          isClickable: service.isAvailable,
          onTap: service.isAvailable ? () => _showBookingDialog(service) : null,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      service.name,
                      style: AppTypography.textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: service.isAvailable
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.tertiaryBackground,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      service.isAvailable ? 'Available' : 'Unavailable',
                      style: AppTypography.textTheme.labelSmall?.copyWith(
                        color: service.isAvailable
                            ? AppColors.success
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                service.description,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppConstants.currency} ${service.priceRM.toStringAsFixed(2)}',
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          color: AppColors.roseGold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'or ${service.priceTokens.toInt()} ${AppConstants.tokenName}',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (service.isAvailable)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.roseGold,
                      size: AppSpacing.iconSmall,
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingDialog(Service service) {
    final paymentState = context.read<PaymentBloc>().state;
    if (paymentState.balance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for balance to load'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    final balance = paymentState.balance!;
    final canAffordRM = balance.canAffordWithCurrency(service.priceRM);
    final canAffordTokens = balance.canAffordWithTokens(service.priceTokens);
    final canAfford = canAffordRM || canAffordTokens;
    
    // Reset selected date/time to default (2 hours from now)
    _selectedDateTime = DateTime.now().add(const Duration(hours: 2));
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => BlocBuilder<BookingBloc, BookingState>(
          buildWhen: (previous, current) =>
              previous.isCreatingBooking != current.isCreatingBooking,
          builder: (context, bookingState) {
            final isCreating = bookingState.isCreatingBooking;
            
            return AlertDialog(
              backgroundColor: AppColors.primaryBackground,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: Text(
                'Book ${service.name}',
                style: AppTypography.textTheme.displayMedium,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.description,
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Service Price:',
                      style: AppTypography.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${AppConstants.currency}: ${service.priceRM.toStringAsFixed(2)}',
                      style: AppTypography.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${AppConstants.tokenName}: ${service.priceTokens.toInt()}',
                      style: AppTypography.textTheme.bodyMedium,
                    ),
                    if (!canAfford)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg),
                        child: Text(
                          'Insufficient balance',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Booking Date & Time:',
                      style: AppTypography.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _formatDateTime(_selectedDateTime),
                              style: AppTypography.textTheme.bodyMedium,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          ElevatedButton(
                            onPressed: isCreating ? null : () => _showDateTimePicker(setDialogState),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isCreating ? null : () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.slate,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: (canAfford && !isCreating)
                      ? () {
                          _createBooking(service, _selectedDateTime);
                        }
                      : null,
                  child: isCreating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Confirm'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _createBooking(Service service, DateTime dateTime) {
    final paymentState = context.read<PaymentBloc>().state;
    if (paymentState.balance == null) return;

    final balance = paymentState.balance!;
    double payRM = 0;
    double payTokens = 0;

    if (balance.canAffordWithTokens(service.priceTokens)) {
      payTokens = service.priceTokens;
    } else {
      payRM = service.priceRM;
    }

    context.read<PaymentBloc>().add(ProcessPayment(
          userId: AppConstants.mockUserId,
          paymentMethod: PaymentMethod(
            amountRM: payRM,
            amountTokens: payTokens,
          ),
          description: 'Booking: ${service.name}',
        ));

    context.read<BookingBloc>().add(CreateBookingEvent(
          userId: AppConstants.mockUserId,
          service: service,
          dateTime: dateTime,
          amountPaidRM: payRM,
          amountPaidTokens: payTokens,
        ));
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    return '$month $day, $year at $hour:$minute';
  }

  Future<void> _showDateTimePicker(StateSetter setDialogState) async {
    final now = DateTime.now();
    
    // Show date picker
    // ignore: use_build_context_synchronously
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    // Show time picker
    // ignore: use_build_context_synchronously
    final selectedTime = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (selectedTime == null) return;

    // Combine date and time
    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Validate that the selected date/time is in the future
    if (newDateTime.isBefore(now)) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a future date and time'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Update the selected date/time and refresh dialog
    setDialogState(() {
      _selectedDateTime = newDateTime;
    });
  }

  String _cleanErrorMessage(String message) {
    return message
        .replaceFirst(RegExp(r'^Error:\s*', caseSensitive: false), '')
        .replaceFirst(RegExp(r'^Exception:\s*', caseSensitive: false), '');
  }
}
