import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/course_type.dart';
import '../models/division.dart';
import '../models/course_fee.dart';
import '../models/qr_history.dart';
import '../models/discount.dart';
import '../bloc/course_type/course_type_bloc.dart';
import '../bloc/course_type/course_type_event.dart';
import '../bloc/course_type/course_type_state.dart';
import '../bloc/division/division_bloc.dart';
import '../bloc/division/division_event.dart';
import '../bloc/division/division_state.dart';
import '../bloc/course_fee/course_fee_bloc.dart';
import '../bloc/discount/discount_bloc.dart';
import '../bloc/discount/discount_event.dart';
import '../bloc/selection/selection_bloc.dart';
import '../bloc/selection/selection_event.dart';
import '../bloc/selection/selection_state.dart';
import '../widgets/profiles_list_widget.dart';
import '../widgets/course_types_list_widget.dart';
import '../widgets/divisions_list_widget.dart';
import '../widgets/training_facilities_list_widget.dart';
import '../widgets/course_fees_list_widget.dart';
import '../widgets/discounts_list_widget.dart';
import '../widgets/profile_type_selection_widget.dart';
import '../widgets/referral_source_selection_widget.dart';
import '../widgets/review_screen_widget.dart';
import '../widgets/selected_info_dialog_widget.dart';
import '../widgets/error_state_widget.dart';
import '../utils/course_type_selection_helpers.dart';

class CourseTypeSelectionScreen extends StatefulWidget {
  final String? qrContent;
  final List<QRHistory>? selectedProfiles;

  const CourseTypeSelectionScreen({
    super.key,
    this.qrContent,
    this.selectedProfiles,
  });

  @override
  State<CourseTypeSelectionScreen> createState() => _CourseTypeSelectionScreenState();
}

class _CourseTypeSelectionScreenState extends State<CourseTypeSelectionScreen> {


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CourseTypeBloc()..add(const LoadCourseTypes()),
        ),
        BlocProvider(
          create: (context) => DivisionBloc()..add(const LoadDivisions()),
        ),
        BlocProvider(
          create: (context) => CourseFeeBloc(),
        ),
        BlocProvider(
          create: (context) => DiscountBloc()..add(const LoadDiscounts()),
        ),
        BlocProvider(
          create: (context) => SelectionBloc(),
        ),
      ],
      child: BlocBuilder<SelectionBloc, SelectionState>(
        builder: (context, selectionState) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                getAppBarTitle(
                  selectedReferralSource: selectionState.selectedReferralSource,
                  isAffiliatedProfile: selectionState.isAffiliatedProfile,
                  isOutsideProfile: selectionState.isOutsideProfile,
                  selectedDiscount: selectionState.selectedDiscount,
                  selectedCourseFee: selectionState.selectedCourseFee,
                  selectedDivision: selectionState.selectedDivision,
                  selectedTrainingFacility: selectionState.selectedTrainingFacility,
                  selectedCourseType: selectionState.selectedCourseType,
                  selectedProfilesCount: widget.selectedProfiles?.length,
                ),
              ),
              centerTitle: false,
              leading: shouldShowBackButton(
                selectedCourseType: selectionState.selectedCourseType,
                selectedDivision: selectionState.selectedDivision,
                selectedTrainingFacility: selectionState.selectedTrainingFacility,
                selectedCourseFee: selectionState.selectedCourseFee,
                selectedDiscount: selectionState.selectedDiscount,
                isAffiliatedProfile: selectionState.isAffiliatedProfile,
                isOutsideProfile: selectionState.isOutsideProfile,
                profileTypeConfirmed: selectionState.profileTypeConfirmed,
                selectedReferralSource: selectionState.selectedReferralSource,
              )
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => _handleBackButton(context),
                    )
                  : null,
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () => _showSelectedInfo(context, selectionState),
                  tooltip: 'Xem thông tin đã chọn',
                ),
              ],
            ),
            body: BlocBuilder<CourseTypeBloc, CourseTypeState>(
              builder: (context, state) {
                if (state is CourseTypeLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CourseTypeError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<CourseTypeBloc>().add(const LoadCourseTypes());
                    },
                  );
                }

                if (state is CourseTypeLoaded) {
                  if (state.courseTypes.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Không có hạng đào tạo nào',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Kiểm tra hướng màn hình
                  final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                  
                  // Widget hiển thị danh sách hồ sơ
                  Widget profilesList = _buildProfilesList(selectionState);
                  
                  // Widget hiển thị danh sách (hạng đào tạo, đơn vị, cơ sở đào tạo, gói học phí, gói giảm giá, loại hồ sơ, nguồn thông tin hoặc xem lại)
                  Widget rightList = _buildRightList(context, state, selectionState);

                  // Layout responsive: Row cho ngang, Column cho dọc
                  if (isLandscape) {
                    return Row(
                      children: [
                        // Bên trái: Danh sách hồ sơ
                        Expanded(
                          flex: widget.selectedProfiles != null && widget.selectedProfiles!.isNotEmpty ? 1 : 0,
                          child: widget.selectedProfiles != null && widget.selectedProfiles!.isNotEmpty
                              ? profilesList
                              : const SizedBox.shrink(),
                        ),
                        // Divider nếu có cả hai danh sách
                        if (widget.selectedProfiles != null && widget.selectedProfiles!.isNotEmpty)
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Colors.grey.shade300,
                          ),
                        // Bên phải: Danh sách hạng đào tạo hoặc đơn vị
                        Expanded(
                          flex: 1,
                          child: rightList,
                        ),
                      ],
                    );
                  }
                  
                  return Column(
                    children: [
                      // Bên trên: Danh sách hồ sơ
                      if (widget.selectedProfiles != null && widget.selectedProfiles!.isNotEmpty) ...[
                        Expanded(
                          flex: widget.selectedProfiles != null && widget.selectedProfiles!.isNotEmpty ? 1 : 0,
                          child: profilesList,
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade300,
                        ),
                      ],
                      // Bên dưới: Danh sách hạng đào tạo hoặc đơn vị
                      Expanded(
                        flex: 1,
                        child: rightList,
                      ),
                    ],
                  );
                }

                // Initial state
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilesList(SelectionState selectionState) {
    if (widget.selectedProfiles == null || widget.selectedProfiles!.isEmpty) {
      return const SizedBox.shrink();
    }

    return ProfilesListWidget(
      profiles: widget.selectedProfiles!,
      showWarning: selectionState.selectedCourseType == null,
    );
  }

  Widget _buildRightList(BuildContext context, CourseTypeLoaded state, SelectionState selectionState) {
    // Flow: CourseType -> Division -> TrainingFacility -> CourseFee -> Discount -> ProfileType -> ReferralSource -> Review
    // Logic: Ưu tiên kiểm tra các bước chưa hoàn thành trước, chỉ hiển thị Review khi tất cả đã hoàn thành
    
    // Kiểm tra từng bước theo thứ tự, hiển thị bước đầu tiên chưa hoàn thành
    if (selectionState.selectedCourseType == null) {
      return _buildCourseTypesList(context, state);
    }
    
    if (selectionState.selectedDivision == null) {
      return _buildDivisionsList(context, selectionState);
    }
    
    if (selectionState.selectedTrainingFacility == null) {
      return _buildTrainingFacilitiesList(context, selectionState);
    }
    
    if (selectionState.selectedCourseFee == null) {
      return _buildCourseFeesList(context, selectionState);
    }
    
    if (selectionState.selectedDiscount == null) {
      return _buildDiscountsList(context, selectionState);
    }
    
    if (!selectionState.profileTypeConfirmed) {
      return _buildProfileTypeSelection(context, selectionState);
    }
    
    if (selectionState.selectedReferralSource == null) {
      return _buildReferralSourceSelection(context, selectionState);
    }
    
    // Chỉ hiển thị Review khi tất cả các bước đã hoàn thành
    return _buildReviewScreen(selectionState);
  }

  void _handleBackButton(BuildContext context) {
    context.read<SelectionBloc>().add(const GoBack());
  }

  Widget _buildCourseTypesList(BuildContext context, CourseTypeLoaded state) {
    return CourseTypesListWidget(
      courseTypes: state.courseTypes,
      onCourseTypeSelected: (courseType) => _onCourseTypeSelected(context, courseType),
    );
  }

  void _onCourseTypeSelected(BuildContext context, CourseType courseType) {
    context.read<SelectionBloc>().add(SelectCourseType(courseType));
  }

  Widget _buildDivisionsList(BuildContext context, SelectionState selectionState) {
    return BlocBuilder<DivisionBloc, DivisionState>(
      builder: (context, state) {
        if (state is DivisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DivisionError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              context.read<DivisionBloc>().add(const LoadDivisions());
            },
          );
        }

        if (state is DivisionLoaded) {
          return DivisionsListWidget(
            divisions: state.divisions,
            selectedCourseType: selectionState.selectedCourseType,
            onDivisionSelected: (division) => _onDivisionSelected(context, division),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onDivisionSelected(BuildContext context, Division division) {
    final selectionState = context.read<SelectionBloc>().state;
    if (!validateCourseTypeSelection(
      selectedCourseType: selectionState.selectedCourseType,
      context: context,
    )) {
      return;
    }
    context.read<SelectionBloc>().add(SelectDivision(division));
  }

  Widget _buildTrainingFacilitiesList(BuildContext context, SelectionState selectionState) {
    return BlocBuilder<DivisionBloc, DivisionState>(
      builder: (context, state) {
        if (state is DivisionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DivisionError) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              context.read<DivisionBloc>().add(const LoadDivisions());
            },
          );
        }

        if (state is DivisionLoaded) {
          return TrainingFacilitiesListWidget(
            divisions: state.divisions,
            selectedCourseType: selectionState.selectedCourseType,
            selectedDivision: selectionState.selectedDivision,
            onTrainingFacilitySelected: (facility) => _onTrainingFacilitySelected(context, facility),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onTrainingFacilitySelected(BuildContext context, Division facility) {
    final selectionState = context.read<SelectionBloc>().state;
    if (!validateCourseTypeSelection(
      selectedCourseType: selectionState.selectedCourseType,
      context: context,
    )) {
      return;
    }
    context.read<SelectionBloc>().add(SelectTrainingFacility(facility));
  }

  Widget _buildCourseFeesList(BuildContext context, SelectionState selectionState) {
    if (selectionState.selectedCourseType == null || selectionState.selectedTrainingFacility == null) {
      return const Center(
        child: Text('Vui lòng chọn hạng đào tạo và cơ sở đào tạo'),
      );
    }

    return CourseFeesListWidget(
      selectedCourseType: selectionState.selectedCourseType!,
      selectedTrainingFacility: selectionState.selectedTrainingFacility!,
      onCourseFeeSelected: (courseFee) => _onCourseFeeSelected(context, courseFee),
    );
  }

  void _onCourseFeeSelected(BuildContext context, CourseFee courseFee) {
    final selectionState = context.read<SelectionBloc>().state;
    if (!validateCourseTypeSelection(
      selectedCourseType: selectionState.selectedCourseType,
      context: context,
    )) {
      return;
    }
    context.read<SelectionBloc>().add(SelectCourseFee(courseFee));
  }

  Widget _buildDiscountsList(BuildContext context, SelectionState selectionState) {
    return DiscountsListWidget(
      selectedCourseFee: selectionState.selectedCourseFee,
      onDiscountSelected: (discount) => _onDiscountSelected(context, discount),
    );
  }

  void _onDiscountSelected(BuildContext context, Discount discount) {
    final selectionState = context.read<SelectionBloc>().state;
    if (!validateCourseTypeSelection(
      selectedCourseType: selectionState.selectedCourseType,
      context: context,
    )) {
      return;
    }
    context.read<SelectionBloc>().add(SelectDiscount(discount));
  }

  Widget _buildProfileTypeSelection(BuildContext context, SelectionState selectionState) {
    return ProfileTypeSelectionWidget(
      isAffiliatedProfile: selectionState.isAffiliatedProfile,
      isOutsideProfile: selectionState.isOutsideProfile,
      selectedDiscount: selectionState.selectedDiscount,
      onAffiliatedProfileChanged: (value) {
        context.read<SelectionBloc>().add(SetAffiliatedProfile(value));
      },
      onOutsideProfileChanged: (value) {
        context.read<SelectionBloc>().add(SetOutsideProfile(value));
      },
      onConfirm: () => _onProfileTypeSelected(context),
    );
  }

  void _onProfileTypeSelected(BuildContext context) {
    context.read<SelectionBloc>().add(const ConfirmProfileType());
  }

  Widget _buildReferralSourceSelection(BuildContext context, SelectionState selectionState) {
    return ReferralSourceSelectionWidget(
      selectedReferralSource: selectionState.selectedReferralSource,
      isAffiliatedProfile: selectionState.isAffiliatedProfile,
      isOutsideProfile: selectionState.isOutsideProfile,
      onReferralSourceSelected: (source) {
        context.read<SelectionBloc>().add(SelectReferralSource(source));
      },
    );
  }

  Widget _buildReviewScreen(SelectionState selectionState) {
    return ReviewScreenWidget(
      selectedProfiles: widget.selectedProfiles,
      selectedCourseType: selectionState.selectedCourseType,
      selectedDivision: selectionState.selectedDivision,
      selectedTrainingFacility: selectionState.selectedTrainingFacility,
      selectedCourseFee: selectionState.selectedCourseFee,
      selectedDiscount: selectionState.selectedDiscount,
      isAffiliatedProfile: selectionState.isAffiliatedProfile,
      isOutsideProfile: selectionState.isOutsideProfile,
      selectedReferralSource: selectionState.selectedReferralSource,
      onConfirm: () => _onConfirmSelection(context),
    );
  }

  void _onConfirmSelection(BuildContext context) {
    final selectionState = context.read<SelectionBloc>().state;
    // Trả về kết quả cho màn hình trước
    Navigator.of(context).pop({
      'courseType': selectionState.selectedCourseType,
      'division': selectionState.selectedDivision,
      'trainingFacility': selectionState.selectedTrainingFacility,
      'courseFee': selectionState.selectedCourseFee,
      'discount': selectionState.selectedDiscount,
      'isAffiliatedProfile': selectionState.isAffiliatedProfile,
      'isOutsideProfile': selectionState.isOutsideProfile,
      'referralSource': selectionState.selectedReferralSource,
    });
  }

  void _showSelectedInfo(BuildContext context, SelectionState selectionState) {
    showDialog(
      context: context,
      builder: (dialogContext) => SelectedInfoDialogWidget(
        selectedProfiles: widget.selectedProfiles,
        selectedCourseType: selectionState.selectedCourseType,
        selectedDivision: selectionState.selectedDivision,
        selectedTrainingFacility: selectionState.selectedTrainingFacility,
        selectedCourseFee: selectionState.selectedCourseFee,
        selectedDiscount: selectionState.selectedDiscount,
        isAffiliatedProfile: selectionState.isAffiliatedProfile,
        isOutsideProfile: selectionState.isOutsideProfile,
        selectedReferralSource: selectionState.selectedReferralSource,
        onResetCourseType: () {
          context.read<SelectionBloc>().add(const ResetCourseType());
        },
        onResetDivision: () {
          context.read<SelectionBloc>().add(const ResetDivision());
        },
        onResetTrainingFacility: () {
          context.read<SelectionBloc>().add(const ResetTrainingFacility());
        },
        onResetCourseFee: () {
          context.read<SelectionBloc>().add(const ResetCourseFee());
        },
        onResetDiscount: () {
          context.read<SelectionBloc>().add(const ResetDiscount());
        },
        onResetReferralSource: () {
          context.read<SelectionBloc>().add(const ResetReferralSource());
        },
        onResetProfileType: () {
          context.read<SelectionBloc>().add(const ResetProfileType());
        },
      ),
    );
  }
}

