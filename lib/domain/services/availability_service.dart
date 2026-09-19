import 'package:intl/intl.dart';
import '../models/beautician_model.dart';
import '../models/booking_model.dart';

/// Business logic domain service calculating real-time appointment availability.
class AvailabilityService {
  AvailabilityService._();

  /// Calculates available time slot strings for a given beautician, date, and service duration.
  static List<String> getAvailableSlots({
    required BeauticianModel beautician,
    required DateTime date,
    required int serviceDurationMinutes,
    required List<BookingModel> existingBookings,
    DateTime? now, // injectable for testing
  }) {
    final currentTime = now ?? DateTime.now();

    // 1. Check if the date is in the past (ignoring time)
    final dateOnly = DateTime(date.year, date.month, date.day);
    final todayOnly = DateTime(currentTime.year, currentTime.month, currentTime.day);
    if (dateOnly.isBefore(todayOnly)) {
      return [];
    }

    // 2. Check if the beautician works on this day of the week
    if (!beautician.workingDays.contains(date.weekday)) {
      return [];
    }

    // 3. Parse working hours and break times
    final workStartMinutes = _parseTimeToMinutes(beautician.workingHoursStart);
    final workEndMinutes = _parseTimeToMinutes(beautician.workingHoursEnd);
    final breakStartMinutes = _parseTimeToMinutes(beautician.breakStart);
    final breakEndMinutes = _parseTimeToMinutes(beautician.breakEnd);

    // Filter relevant active bookings for this beautician on this exact date
    final dayBookings = existingBookings.where((b) {
      final isSameBeautician = b.beauticianId == beautician.id;
      final isSameDate = b.bookingDate.year == date.year &&
          b.bookingDate.month == date.month &&
          b.bookingDate.day == date.day;
      final isActive = b.status != BookingStatus.cancelled;
      return isSameBeautician && isSameDate && isActive;
    }).toList();

    // Convert existing bookings to [startMinutes, endMinutes] ranges
    final bookedRanges = dayBookings.map((b) {
      final start = _parseFormattedSlotToMinutes(b.timeSlot);
      return (start: start, end: start + b.durationMinutes);
    }).toList();

    final List<String> availableSlots = [];
    const int slotStepMinutes = 30; // 30-minute interval grid

    // Candidate slots from start until (end - service duration)
    for (int start = workStartMinutes;
        start + serviceDurationMinutes <= workEndMinutes;
        start += slotStepMinutes) {
      final end = start + serviceDurationMinutes;

      // Rule A: Break time overlap check
      final overlapsBreak = (start < breakEndMinutes && end > breakStartMinutes);
      if (overlapsBreak) continue;

      // Rule B: Existing booking collision check
      bool hasCollision = false;
      for (final range in bookedRanges) {
        if (start < range.end && end > range.start) {
          hasCollision = true;
          break;
        }
      }
      if (hasCollision) continue;

      // Rule C: If date is today, prevent booking slots in the immediate past (allow 30m lead time)
      if (dateOnly.isAtSameMomentAs(todayOnly)) {
        final currentMinutes = currentTime.hour * 60 + currentTime.minute;
        if (start <= currentMinutes + 30) {
          continue;
        }
      }

      availableSlots.add(_minutesToFormattedString(start));
    }

    return availableSlots;
  }

  static int _parseTimeToMinutes(String timeStr) {
    final parts = timeStr.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  static int _parseFormattedSlotToMinutes(String slot) {
    try {
      final format = DateFormat('hh:mm a');
      final dt = format.parse(slot.trim().toUpperCase());
      return dt.hour * 60 + dt.minute;
    } catch (_) {
      // Fallback parser if format is "09:00"
      if (slot.contains(':')) {
        return _parseTimeToMinutes(slot);
      }
      return 0;
    }
  }

  static String _minutesToFormattedString(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final dt = DateTime(2026, 1, 1, hours, minutes);
    return DateFormat('hh:mm a').format(dt);
  }
}
