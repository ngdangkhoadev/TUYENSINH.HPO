import 'package:flutter_bloc/flutter_bloc.dart';
import 'selection_event.dart';
import 'selection_state.dart';

class SelectionBloc extends Bloc<SelectionEvent, SelectionState> {
  SelectionBloc() : super(const SelectionState()) {
    on<SelectCourseType>(_onSelectCourseType);
    on<SelectDivision>(_onSelectDivision);
    on<SelectTrainingFacility>(_onSelectTrainingFacility);
    on<SelectCourseFee>(_onSelectCourseFee);
    on<SelectDiscount>(_onSelectDiscount);
    on<SetAffiliatedProfile>(_onSetAffiliatedProfile);
    on<SetOutsideProfile>(_onSetOutsideProfile);
    on<ConfirmProfileType>(_onConfirmProfileType);
    on<SelectReferralSource>(_onSelectReferralSource);
    on<ResetSelection>(_onResetSelection);
    on<GoBack>(_onGoBack);
    on<ResetCourseType>(_onResetCourseType);
    on<ResetDivision>(_onResetDivision);
    on<ResetTrainingFacility>(_onResetTrainingFacility);
    on<ResetCourseFee>(_onResetCourseFee);
    on<ResetDiscount>(_onResetDiscount);
    on<ResetReferralSource>(_onResetReferralSource);
    on<ResetProfileType>(_onResetProfileType);
  }

  void _onSelectCourseType(SelectCourseType event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedCourseType: event.courseType));
  }

  void _onSelectDivision(SelectDivision event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedDivision: event.division));
  }

  void _onSelectTrainingFacility(
      SelectTrainingFacility event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedTrainingFacility: event.facility));
  }

  void _onSelectCourseFee(SelectCourseFee event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedCourseFee: event.courseFee));
  }

  void _onSelectDiscount(SelectDiscount event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedDiscount: event.discount));
  }

  void _onSetAffiliatedProfile(
      SetAffiliatedProfile event, Emitter<SelectionState> emit) {
    emit(state.copyWith(isAffiliatedProfile: event.value));
  }

  void _onSetOutsideProfile(
      SetOutsideProfile event, Emitter<SelectionState> emit) {
    emit(state.copyWith(isOutsideProfile: event.value));
  }

  void _onConfirmProfileType(
      ConfirmProfileType event, Emitter<SelectionState> emit) {
    emit(state.copyWith(profileTypeConfirmed: true));
  }

  void _onSelectReferralSource(
      SelectReferralSource event, Emitter<SelectionState> emit) {
    emit(state.copyWith(selectedReferralSource: event.source));
  }

  void _onResetSelection(ResetSelection event, Emitter<SelectionState> emit) {
    emit(const SelectionState());
  }

  void _onGoBack(GoBack event, Emitter<SelectionState> emit) {
    // Logic đi ngược lại flow
    if (state.selectedReferralSource != null) {
      emit(state.copyWith(clearReferralSource: true));
      return;
    }

    if (state.profileTypeConfirmed) {
      emit(state.copyWith(
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.isAffiliatedProfile || state.isOutsideProfile) {
      emit(state.copyWith(
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.selectedDiscount != null) {
      emit(state.copyWith(
        clearDiscount: true,
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.selectedCourseFee != null) {
      emit(state.copyWith(
        clearCourseFee: true,
        clearDiscount: true,
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.selectedTrainingFacility != null) {
      emit(state.copyWith(
        clearTrainingFacility: true,
        clearCourseFee: true,
        clearDiscount: true,
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.selectedDivision != null) {
      emit(state.copyWith(
        clearDivision: true,
        clearTrainingFacility: true,
        clearCourseFee: true,
        clearDiscount: true,
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
      return;
    }

    if (state.selectedCourseType != null) {
      emit(state.copyWith(
        clearCourseType: true,
        clearDivision: true,
        clearTrainingFacility: true,
        clearCourseFee: true,
        clearDiscount: true,
        isAffiliatedProfile: false,
        isOutsideProfile: false,
        profileTypeConfirmed: false,
        clearReferralSource: true,
      ));
    }
  }

  void _onResetCourseType(ResetCourseType event, Emitter<SelectionState> emit) {
    // Chỉ reset CourseType, không ảnh hưởng các bước khác
    emit(state.copyWith(clearCourseType: true));
  }

  void _onResetDivision(ResetDivision event, Emitter<SelectionState> emit) {
    // Chỉ reset Division, không ảnh hưởng các bước khác
    emit(state.copyWith(clearDivision: true));
  }

  void _onResetTrainingFacility(
      ResetTrainingFacility event, Emitter<SelectionState> emit) {
    // Chỉ reset TrainingFacility, không ảnh hưởng các bước khác
    emit(state.copyWith(clearTrainingFacility: true));
  }

  void _onResetCourseFee(ResetCourseFee event, Emitter<SelectionState> emit) {
    // Chỉ reset CourseFee, không ảnh hưởng các bước khác
    emit(state.copyWith(clearCourseFee: true));
  }

  void _onResetDiscount(ResetDiscount event, Emitter<SelectionState> emit) {
    // Chỉ reset Discount, không ảnh hưởng các bước khác
    emit(state.copyWith(clearDiscount: true));
  }

  void _onResetProfileType(ResetProfileType event, Emitter<SelectionState> emit) {
    // Chỉ reset ProfileType (isAffiliatedProfile, isOutsideProfile, profileTypeConfirmed)
    emit(state.copyWith(
      isAffiliatedProfile: false,
      isOutsideProfile: false,
      profileTypeConfirmed: false,
    ));
  }

  void _onResetReferralSource(
      ResetReferralSource event, Emitter<SelectionState> emit) {
    emit(state.copyWith(clearReferralSource: true));
  }
}

