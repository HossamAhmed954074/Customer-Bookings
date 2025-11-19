import 'package:customer_booking/core/presentation/cubits/user_profile_cubit.dart';
import 'package:customer_booking/core/presentation/cubits/user_profile_state.dart';
import 'package:customer_booking/features/credits/presentation/cubits/credits_cubit.dart';
import 'package:customer_booking/features/credits/presentation/cubits/credits_state.dart';
import 'package:customer_booking/features/credits/presentation/widgets/credit_package_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseCreditsScreen extends StatefulWidget {
  const PurchaseCreditsScreen({super.key});

  @override
  State<PurchaseCreditsScreen> createState() => _PurchaseCreditsScreenState();
}

class _PurchaseCreditsScreenState extends State<PurchaseCreditsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CreditsCubit>().loadPackages();
      context.read<UserProfileCubit>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Purchase Credits'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Current balance
          BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[700]!, Colors.blue[500]!],
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Your Current Balance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          '${state.credits}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'credits',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Packages list
          Expanded(
            child: BlocConsumer<CreditsCubit, CreditsState>(
              listener: (context, state) {
                if (state.status == CreditsStatus.success) {
                  // Reload user credits from API
                  if (state.purchaseResult != null) {
                    final creditsAdded = state.purchaseResult!['creditsAdded'] as int?;
                    
                    // Refresh user profile to get updated credits from server
                    context.read<UserProfileCubit>().loadProfile();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Successfully purchased ${creditsAdded ?? 0} credits!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Reset state
                    context.read<CreditsCubit>().reset();
                    context.read<CreditsCubit>().loadPackages();
                  }
                } else if (state.status == CreditsStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.errorMessage ?? 'Failed to purchase credits',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.status == CreditsStatus.loading &&
                    state.packages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.packages.isEmpty) {
                  return const Center(
                    child: Text('No credit packages available'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.packages.length,
                  itemBuilder: (context, index) {
                    final package = state.packages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CreditPackageCard(
                        package: package,
                        isLoading: state.status == CreditsStatus.purchasing,
                        onPurchase: () {
                          _showPurchaseConfirmation(context, package.id, package.name, package.credits);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseConfirmation(
    BuildContext context,
    String packageId,
    String packageName,
    int credits,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Confirm Purchase'),
        content: Text(
          'Do you want to purchase $packageName ($credits credits)?\n\nThis is a mock purchase for demonstration.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<CreditsCubit>().purchaseCredits(packageId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
