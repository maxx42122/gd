class MuscleGroup {
  final String id;
  final String label;
  final bool isFront;
  const MuscleGroup({
    required this.id,
    required this.label,
    required this.isFront,
  });
}

const List<MuscleGroup> allMuscleGroups = [
  // FRONT
  MuscleGroup(id: 'cranium', label: 'Cranium', isFront: true),
  MuscleGroup(id: 'face', label: 'Face', isFront: true),
  MuscleGroup(id: 'neck', label: 'Neck', isFront: true),
  MuscleGroup(id: 'sternocleidomastoid_l', label: 'SCM (L)', isFront: true),
  MuscleGroup(id: 'sternocleidomastoid_r', label: 'SCM (R)', isFront: true),
  MuscleGroup(id: 'trapezius_l', label: 'Trapezius (L)', isFront: true),
  MuscleGroup(id: 'trapezius_r', label: 'Trapezius (R)', isFront: true),
  MuscleGroup(
    id: 'anterior_deltoid_l',
    label: 'Ant. Deltoid (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'anterior_deltoid_r',
    label: 'Ant. Deltoid (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'medial_deltoid_l', label: 'Med. Deltoid (L)', isFront: true),
  MuscleGroup(id: 'medial_deltoid_r', label: 'Med. Deltoid (R)', isFront: true),
  MuscleGroup(id: 'pectoralis_major_l', label: 'Pec Major (L)', isFront: true),
  MuscleGroup(id: 'pectoralis_major_r', label: 'Pec Major (R)', isFront: true),
  MuscleGroup(id: 'pectoralis_minor_l', label: 'Pec Minor (L)', isFront: true),
  MuscleGroup(id: 'pectoralis_minor_r', label: 'Pec Minor (R)', isFront: true),
  MuscleGroup(
    id: 'serratus_anterior_l',
    label: 'Serratus Ant. (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'serratus_anterior_r',
    label: 'Serratus Ant. (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'rectus_abdominis', label: 'Rectus Abdominis', isFront: true),
  MuscleGroup(
    id: 'external_oblique_l',
    label: 'Ext. Oblique (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'external_oblique_r',
    label: 'Ext. Oblique (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'biceps_brachii_l', label: 'Biceps (L)', isFront: true),
  MuscleGroup(id: 'biceps_brachii_r', label: 'Biceps (R)', isFront: true),
  MuscleGroup(id: 'brachialis_l', label: 'Brachialis (L)', isFront: true),
  MuscleGroup(id: 'brachialis_r', label: 'Brachialis (R)', isFront: true),
  MuscleGroup(
    id: 'flexor_carpi_radialis_l',
    label: 'Flex. Carpi Rad. (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'flexor_carpi_radialis_r',
    label: 'Flex. Carpi Rad. (R)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'brachioradialis_l',
    label: 'Brachioradialis (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'brachioradialis_r',
    label: 'Brachioradialis (R)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'extensor_carpi_ulnaris_l',
    label: 'Ext. Carpi Uln. (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'extensor_carpi_ulnaris_r',
    label: 'Ext. Carpi Uln. (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'wrist_hand_l', label: 'Wrist/Hand (L)', isFront: true),
  MuscleGroup(id: 'wrist_hand_r', label: 'Wrist/Hand (R)', isFront: true),
  MuscleGroup(id: 'iliopsoas_l', label: 'Iliopsoas (L)', isFront: true),
  MuscleGroup(id: 'iliopsoas_r', label: 'Iliopsoas (R)', isFront: true),
  MuscleGroup(id: 'tensor_fasciae_latae_l', label: 'TFL (L)', isFront: true),
  MuscleGroup(id: 'tensor_fasciae_latae_r', label: 'TFL (R)', isFront: true),
  MuscleGroup(
    id: 'rectus_femoris_l',
    label: 'Rectus Femoris (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'rectus_femoris_r',
    label: 'Rectus Femoris (R)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'vastus_lateralis_l',
    label: 'Vastus Lateralis (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'vastus_lateralis_r',
    label: 'Vastus Lateralis (R)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'vastus_medialis_l',
    label: 'Vastus Medialis (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'vastus_medialis_r',
    label: 'Vastus Medialis (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'sartorius_l', label: 'Sartorius (L)', isFront: true),
  MuscleGroup(id: 'sartorius_r', label: 'Sartorius (R)', isFront: true),
  MuscleGroup(
    id: 'adductor_longus_l',
    label: 'Adductor Longus (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'adductor_longus_r',
    label: 'Adductor Longus (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'gracilis_l', label: 'Gracilis (L)', isFront: true),
  MuscleGroup(id: 'gracilis_r', label: 'Gracilis (R)', isFront: true),
  MuscleGroup(id: 'patella_l', label: 'Patella (L)', isFront: true),
  MuscleGroup(id: 'patella_r', label: 'Patella (R)', isFront: true),
  MuscleGroup(
    id: 'tibialis_anterior_l',
    label: 'Tibialis Ant. (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'tibialis_anterior_r',
    label: 'Tibialis Ant. (R)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'peroneus_longus_l',
    label: 'Peroneus Longus (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'peroneus_longus_r',
    label: 'Peroneus Longus (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'gastrocnemius_l', label: 'Gastrocnemius (L)', isFront: true),
  MuscleGroup(id: 'gastrocnemius_r', label: 'Gastrocnemius (R)', isFront: true),
  MuscleGroup(id: 'soleus_l', label: 'Soleus (L)', isFront: true),
  MuscleGroup(id: 'soleus_r', label: 'Soleus (R)', isFront: true),
  MuscleGroup(
    id: 'extensor_digitorum_longus_l',
    label: 'Ext. Dig. Longus (L)',
    isFront: true,
  ),
  MuscleGroup(
    id: 'extensor_digitorum_longus_r',
    label: 'Ext. Dig. Longus (R)',
    isFront: true,
  ),
  MuscleGroup(id: 'ankle_foot_l', label: 'Ankle/Foot (L)', isFront: true),
  MuscleGroup(id: 'ankle_foot_r', label: 'Ankle/Foot (R)', isFront: true),
  // BACK
  MuscleGroup(id: 'cranium_back', label: 'Cranium', isFront: false),
  MuscleGroup(id: 'neck_back', label: 'Neck', isFront: false),
  MuscleGroup(id: 'upper_trapezius', label: 'Upper Trapezius', isFront: false),
  MuscleGroup(id: 'middle_trapezius', label: 'Mid. Trapezius', isFront: false),
  MuscleGroup(id: 'lower_trapezius', label: 'Low. Trapezius', isFront: false),
  MuscleGroup(
    id: 'posterior_deltoid_l',
    label: 'Post. Deltoid (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'posterior_deltoid_r',
    label: 'Post. Deltoid (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'infraspinatus_l',
    label: 'Infraspinatus (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'infraspinatus_r',
    label: 'Infraspinatus (R)',
    isFront: false,
  ),
  MuscleGroup(id: 'teres_minor_l', label: 'Teres Minor (L)', isFront: false),
  MuscleGroup(id: 'teres_minor_r', label: 'Teres Minor (R)', isFront: false),
  MuscleGroup(id: 'teres_major_l', label: 'Teres Major (L)', isFront: false),
  MuscleGroup(id: 'teres_major_r', label: 'Teres Major (R)', isFront: false),
  MuscleGroup(
    id: 'rhomboid_major_l',
    label: 'Rhomboid Major (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'rhomboid_major_r',
    label: 'Rhomboid Major (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'latissimus_dorsi_l',
    label: 'Lat. Dorsi (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'latissimus_dorsi_r',
    label: 'Lat. Dorsi (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'erector_spinae_l',
    label: 'Erector Spinae (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'erector_spinae_r',
    label: 'Erector Spinae (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'external_oblique_back_l',
    label: 'Ext. Oblique (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'external_oblique_back_r',
    label: 'Ext. Oblique (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_long_head_l',
    label: 'Triceps Long (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_long_head_r',
    label: 'Triceps Long (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_lateral_head_l',
    label: 'Triceps Lateral (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_lateral_head_r',
    label: 'Triceps Lateral (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_medial_head_l',
    label: 'Triceps Medial (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'triceps_medial_head_r',
    label: 'Triceps Medial (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'extensor_carpi_radialis_l',
    label: 'Ext. Carpi Rad. (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'extensor_carpi_radialis_r',
    label: 'Ext. Carpi Rad. (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'extensor_carpi_ulnaris_back_l',
    label: 'Ext. Carpi Uln. (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'extensor_carpi_ulnaris_back_r',
    label: 'Ext. Carpi Uln. (R)',
    isFront: false,
  ),
  MuscleGroup(id: 'wrist_hand_back_l', label: 'Wrist/Hand (L)', isFront: false),
  MuscleGroup(id: 'wrist_hand_back_r', label: 'Wrist/Hand (R)', isFront: false),
  MuscleGroup(id: 'gluteus_maximus_l', label: 'Glute Max (L)', isFront: false),
  MuscleGroup(id: 'gluteus_maximus_r', label: 'Glute Max (R)', isFront: false),
  MuscleGroup(id: 'gluteus_medius_l', label: 'Glute Med (L)', isFront: false),
  MuscleGroup(id: 'gluteus_medius_r', label: 'Glute Med (R)', isFront: false),
  MuscleGroup(
    id: 'biceps_femoris_l',
    label: 'Biceps Femoris (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'biceps_femoris_r',
    label: 'Biceps Femoris (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'semitendinosus_l',
    label: 'Semitendinosus (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'semitendinosus_r',
    label: 'Semitendinosus (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'semimembranosus_l',
    label: 'Semimembranosus (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'semimembranosus_r',
    label: 'Semimembranosus (R)',
    isFront: false,
  ),
  MuscleGroup(id: 'iliotibial_band_l', label: 'IT Band (L)', isFront: false),
  MuscleGroup(id: 'iliotibial_band_r', label: 'IT Band (R)', isFront: false),
  MuscleGroup(
    id: 'gastrocnemius_medial_l',
    label: 'Gastroc. Med (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'gastrocnemius_medial_r',
    label: 'Gastroc. Med (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'gastrocnemius_lateral_l',
    label: 'Gastroc. Lat (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'gastrocnemius_lateral_r',
    label: 'Gastroc. Lat (R)',
    isFront: false,
  ),
  MuscleGroup(id: 'soleus_back_l', label: 'Soleus (L)', isFront: false),
  MuscleGroup(id: 'soleus_back_r', label: 'Soleus (R)', isFront: false),
  MuscleGroup(
    id: 'achilles_tendon_l',
    label: 'Achilles Tendon (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'achilles_tendon_r',
    label: 'Achilles Tendon (R)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'peroneus_brevis_l',
    label: 'Peroneus Brevis (L)',
    isFront: false,
  ),
  MuscleGroup(
    id: 'peroneus_brevis_r',
    label: 'Peroneus Brevis (R)',
    isFront: false,
  ),
  MuscleGroup(id: 'ankle_foot_back_l', label: 'Ankle/Foot (L)', isFront: false),
  MuscleGroup(id: 'ankle_foot_back_r', label: 'Ankle/Foot (R)', isFront: false),
];

final Map<String, MuscleGroup> muscleById = {
  for (final m in allMuscleGroups) m.id: m,
};
