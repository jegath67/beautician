import '../../domain/models/beautician_model.dart';

abstract class BeauticianRepository {
  Future<List<BeauticianModel>> getBeauticians({bool? onlyActive});
  Future<BeauticianModel?> getBeauticianById(String id);
  Future<void> createBeautician(BeauticianModel beautician);
  Future<void> updateBeautician(BeauticianModel beautician);
  Future<void> deleteBeautician(String id);
}

class MockBeauticianRepository implements BeauticianRepository {
  final List<BeauticianModel> _beauticians = [
    const BeauticianModel(
      id: 'bt_1',
      name: 'Ananya Deshmukh',
      role: 'Creative Art Director & Bridal Specialist',
      bio: 'Celebrity bridal artist with over 11 years of high-glam experience across Milan, Mumbai, and Chennai fashion weeks.',
      specialties: ['Royal Bridal Artistry', 'Airbrush Makeup', 'Couture Styling'],
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      workingDays: [1, 2, 3, 4, 5, 6], // Mon - Sat
      workingHoursStart: '09:00',
      workingHoursEnd: '19:00',
      breakStart: '13:00',
      breakEnd: '14:00',
      rating: 4.95,
      reviewCount: 340,
      isActive: true,
    ),
    const BeauticianModel(
      id: 'bt_2',
      name: 'Pooja Krishnan',
      role: 'Master Aesthetician & Skin Therapist',
      bio: 'CIDESCO certified clinical skin specialist focused on advanced botanical infusions and holistic dermal transformation.',
      specialties: ['HydraFacial Therapy', 'Bio-Peel Rejuvenation', 'Detox Rituals'],
      avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      workingDays: [1, 2, 3, 4, 5, 6],
      workingHoursStart: '10:00',
      workingHoursEnd: '18:00',
      breakStart: '13:30',
      breakEnd: '14:30',
      rating: 4.92,
      reviewCount: 215,
      isActive: true,
    ),
    const BeauticianModel(
      id: 'bt_3',
      name: 'Meera Sengupta',
      role: 'Senior Hair Colorist & Balayage Artist',
      bio: 'Trained at Vidal Sassoon Academy London, passionate about custom tone blending and low-maintenance dimensional color.',
      specialties: ['Couture Balayage', 'Keratin Silk Infusions', 'Precision Cuts'],
      avatarUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=400&q=80',
      workingDays: [2, 3, 4, 5, 6, 7], // Tue - Sun
      workingHoursStart: '10:00',
      workingHoursEnd: '20:00',
      breakStart: '14:00',
      breakEnd: '15:00',
      rating: 4.88,
      reviewCount: 180,
      isActive: true,
    ),
  ];

  @override
  Future<List<BeauticianModel>> getBeauticians({bool? onlyActive}) async {
    return _beauticians.where((b) {
      if (onlyActive == true && !b.isActive) return false;
      return true;
    }).toList();
  }

  @override
  Future<BeauticianModel?> getBeauticianById(String id) async {
    final index = _beauticians.indexWhere((b) => b.id == id);
    return index != -1 ? _beauticians[index] : null;
  }

  @override
  Future<void> createBeautician(BeauticianModel beautician) async {
    _beauticians.add(beautician);
  }

  @override
  Future<void> updateBeautician(BeauticianModel beautician) async {
    final index = _beauticians.indexWhere((b) => b.id == beautician.id);
    if (index != -1) {
      _beauticians[index] = beautician;
    }
  }

  @override
  Future<void> deleteBeautician(String id) async {
    _beauticians.removeWhere((b) => b.id == id);
  }
}
