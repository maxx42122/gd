// ─────────────────────────────────────────────────────────────────────────────
// Muscle Diagnosis Database
// Each muscle group maps to possible conditions, cures, and impact level
// ─────────────────────────────────────────────────────────────────────────────

enum ImpactLevel { low, moderate, high }

class Condition {
  final String name;
  final String description;
  final List<String> symptoms;
  final List<String> cures;
  final List<String> exercises;
  final ImpactLevel impact;

  const Condition({
    required this.name,
    required this.description,
    required this.symptoms,
    required this.cures,
    required this.exercises,
    required this.impact,
  });
}

class MuscleReport {
  final String muscleId;
  final String muscleLabel;
  final List<Condition> conditions;

  const MuscleReport({
    required this.muscleId,
    required this.muscleLabel,
    required this.conditions,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Condition library — reusable building blocks
// ─────────────────────────────────────────────────────────────────────────────

const _muscleStrain = Condition(
  name: 'Muscle Strain',
  description:
      'Overstretching or tearing of muscle fibers due to overuse, sudden movement, or heavy lifting.',
  symptoms: [
    'Sharp pain during movement',
    'Swelling and bruising',
    'Muscle weakness',
    'Limited range of motion',
  ],
  cures: [
    'RICE protocol (Rest, Ice, Compression, Elevation)',
    'NSAIDs (Ibuprofen, Naproxen)',
    'Physical therapy',
    'Gradual return to activity',
  ],
  exercises: [
    'Gentle stretching after 48h',
    'Isometric strengthening',
    'Progressive resistance training',
  ],
  impact: ImpactLevel.moderate,
);

const _muscleTendinitis = Condition(
  name: 'Tendinitis',
  description:
      'Inflammation of the tendon connecting muscle to bone, typically from repetitive stress.',
  symptoms: [
    'Dull aching pain',
    'Tenderness at tendon insertion',
    'Stiffness after rest',
    'Mild swelling',
  ],
  cures: [
    'Rest and activity modification',
    'Ice therapy 15–20 min',
    'Eccentric strengthening exercises',
    'Corticosteroid injection (severe cases)',
  ],
  exercises: [
    'Eccentric loading protocol',
    'Tendon gliding exercises',
    'Low-impact cross-training',
  ],
  impact: ImpactLevel.moderate,
);

const _myofascialPain = Condition(
  name: 'Myofascial Pain Syndrome',
  description:
      'Chronic pain caused by trigger points — sensitive knots in muscle tissue that refer pain to other areas.',
  symptoms: [
    'Deep aching pain',
    'Trigger point tenderness',
    'Referred pain patterns',
    'Muscle stiffness',
  ],
  cures: [
    'Trigger point massage',
    'Dry needling / acupuncture',
    'Stretching and foam rolling',
    'Heat therapy',
  ],
  exercises: [
    'Foam rolling 60–90 sec per point',
    'Active release technique',
    'Yoga and mobility work',
  ],
  impact: ImpactLevel.low,
);

const _compartmentSyndrome = Condition(
  name: 'Compartment Syndrome',
  description:
      'Dangerous pressure buildup within a muscle compartment that reduces blood flow.',
  symptoms: [
    'Severe pressure-like pain',
    'Tightness and swelling',
    'Numbness or tingling',
    'Pale or shiny skin',
  ],
  cures: [
    'Immediate medical attention',
    'Fasciotomy surgery (acute)',
    'Rest and elevation (chronic)',
    'Activity modification',
  ],
  exercises: ['Post-surgical rehabilitation only', 'Supervised physiotherapy'],
  impact: ImpactLevel.high,
);

const _rotatorCuffTear = Condition(
  name: 'Rotator Cuff Tear',
  description:
      'Partial or complete tear of the rotator cuff tendons, often from acute injury or degeneration.',
  symptoms: [
    'Shoulder pain at rest and with activity',
    'Weakness lifting arm',
    'Crackling sensation',
    'Pain at night',
  ],
  cures: [
    'Physical therapy (partial tears)',
    'Arthroscopic surgery (complete tears)',
    'Corticosteroid injections',
    'PRP therapy',
  ],
  exercises: [
    'Pendulum exercises',
    'External rotation with band',
    'Scapular stabilization',
    'Wall slides',
  ],
  impact: ImpactLevel.high,
);

const _shoulderImpingement = Condition(
  name: 'Shoulder Impingement',
  description:
      'Compression of rotator cuff tendons under the acromion during arm elevation.',
  symptoms: [
    'Pain with overhead activities',
    'Painful arc 60–120°',
    'Night pain',
    'Shoulder weakness',
  ],
  cures: [
    'NSAIDs and rest',
    'Corticosteroid injection',
    'Physical therapy',
    'Subacromial decompression surgery',
  ],
  exercises: [
    'Scapular retraction',
    'Sleeper stretch',
    'Posterior capsule stretch',
    'Rotator cuff strengthening',
  ],
  impact: ImpactLevel.moderate,
);

const _pectoralStrain = Condition(
  name: 'Pectoral Muscle Strain',
  description:
      'Tear of the pectoralis major, commonly from bench pressing or sudden forceful movement.',
  symptoms: [
    'Sudden sharp chest pain',
    'Bruising across chest',
    'Visible deformity (complete tear)',
    'Weakness in pushing',
  ],
  cures: [
    'Rest and ice (grade 1–2)',
    'Surgical repair (grade 3)',
    'Physical therapy',
    'Gradual return to lifting',
  ],
  exercises: [
    'Doorway stretch',
    'Cable crossover (light)',
    'Push-up progression',
    'Dumbbell flyes (recovery)',
  ],
  impact: ImpactLevel.high,
);

const _bicepsTendinopathy = Condition(
  name: 'Biceps Tendinopathy',
  description:
      'Degeneration or inflammation of the biceps tendon at the shoulder or elbow.',
  symptoms: [
    'Anterior shoulder or elbow pain',
    'Pain with supination',
    'Tenderness along tendon',
    'Weakness in curling',
  ],
  cures: [
    'Activity modification',
    'Eccentric exercises',
    'Ultrasound-guided injection',
    'Surgical tenodesis (severe)',
  ],
  exercises: [
    'Eccentric bicep curls',
    'Supination strengthening',
    'Shoulder flexion exercises',
  ],
  impact: ImpactLevel.moderate,
);

const _lateralEpicondylitis = Condition(
  name: 'Lateral Epicondylitis (Tennis Elbow)',
  description:
      'Overuse injury of the extensor tendons at the lateral epicondyle of the humerus.',
  symptoms: [
    'Outer elbow pain',
    'Weak grip strength',
    'Pain with wrist extension',
    'Tenderness at epicondyle',
  ],
  cures: [
    'Rest and ice',
    'Counterforce brace',
    'Eccentric wrist extension exercises',
    'PRP injection',
  ],
  exercises: [
    'Eccentric wrist extension',
    'Finger extension with rubber band',
    'Forearm pronation/supination',
  ],
  impact: ImpactLevel.moderate,
);

const _medialEpicondylitis = Condition(
  name: 'Medial Epicondylitis (Golfer\'s Elbow)',
  description:
      'Inflammation of the flexor-pronator tendons at the medial epicondyle.',
  symptoms: [
    'Inner elbow pain',
    'Pain with wrist flexion',
    'Weak grip',
    'Numbness in ring/little finger',
  ],
  cures: [
    'Rest and NSAIDs',
    'Eccentric flexor exercises',
    'Corticosteroid injection',
    'Surgery (rare)',
  ],
  exercises: [
    'Wrist flexor stretching',
    'Eccentric wrist curls',
    'Grip strengthening',
  ],
  impact: ImpactLevel.moderate,
);

const _abdominalHernia = Condition(
  name: 'Abdominal Hernia / Diastasis Recti',
  description:
      'Separation of the rectus abdominis muscles along the linea alba, or protrusion through abdominal wall.',
  symptoms: [
    'Visible bulge in abdomen',
    'Core weakness',
    'Lower back pain',
    'Discomfort with lifting',
  ],
  cures: [
    'Core rehabilitation program',
    'Surgical repair (hernia)',
    'Abdominal binder',
    'Avoid heavy lifting',
  ],
  exercises: [
    'Dead bug exercise',
    'Heel slides',
    'Diaphragmatic breathing',
    'Transverse abdominis activation',
  ],
  impact: ImpactLevel.moderate,
);

const _obliquePull = Condition(
  name: 'Oblique Muscle Pull',
  description:
      'Strain of the internal or external oblique muscles from twisting or rotational forces.',
  symptoms: [
    'Side pain with rotation',
    'Tenderness along ribcage',
    'Pain with deep breathing',
    'Stiffness',
  ],
  cures: [
    'Rest and ice',
    'Anti-inflammatory medication',
    'Gradual return to rotation',
    'Core stabilization',
  ],
  exercises: [
    'Side plank (modified)',
    'Pallof press',
    'Rotational cable exercises',
  ],
  impact: ImpactLevel.low,
);

const _hipFlexorStrain = Condition(
  name: 'Hip Flexor Strain',
  description:
      'Tear or strain of the iliopsoas or rectus femoris from sprinting, kicking, or sudden hip flexion.',
  symptoms: [
    'Sharp groin/hip pain',
    'Pain with knee lift',
    'Swelling in hip crease',
    'Limping',
  ],
  cures: [
    'RICE protocol',
    'Hip flexor stretching',
    'Strengthening program',
    'Gradual return to sport',
  ],
  exercises: [
    'Kneeling hip flexor stretch',
    'Straight leg raise',
    'Hip flexion with resistance band',
  ],
  impact: ImpactLevel.moderate,
);

const _itBandSyndrome = Condition(
  name: 'IT Band Syndrome',
  description:
      'Friction of the iliotibial band over the lateral femoral condyle, common in runners.',
  symptoms: [
    'Lateral knee pain',
    'Pain worsens with running',
    'Snapping sensation',
    'Tightness in outer thigh',
  ],
  cures: [
    'Rest and ice',
    'Foam rolling IT band',
    'Hip abductor strengthening',
    'Gait analysis and correction',
  ],
  exercises: [
    'Foam roll IT band',
    'Clamshells',
    'Hip abduction',
    'Single-leg squat',
  ],
  impact: ImpactLevel.moderate,
);

const _quadStrain = Condition(
  name: 'Quadriceps Strain',
  description:
      'Tear of one or more quadriceps muscles, often from sprinting or jumping.',
  symptoms: [
    'Anterior thigh pain',
    'Swelling and bruising',
    'Difficulty extending knee',
    'Muscle spasm',
  ],
  cures: [
    'RICE protocol',
    'Compression bandage',
    'Physiotherapy',
    'Gradual strengthening',
  ],
  exercises: [
    'Quad sets',
    'Straight leg raise',
    'Terminal knee extension',
    'Leg press (light)',
  ],
  impact: ImpactLevel.moderate,
);

const _hamstringStrain = Condition(
  name: 'Hamstring Strain',
  description:
      'One of the most common sports injuries — tearing of hamstring fibers during sprinting or sudden deceleration.',
  symptoms: [
    'Sudden posterior thigh pain',
    'Bruising behind thigh',
    'Difficulty walking',
    'Muscle tightness',
  ],
  cures: [
    'RICE protocol',
    'NSAIDs',
    'Nordic hamstring exercises',
    'Gradual return to running',
  ],
  exercises: [
    'Nordic hamstring curl',
    'Romanian deadlift (light)',
    'Prone hip extension',
    'Hamstring bridge',
  ],
  impact: ImpactLevel.high,
);

const _calfStrain = Condition(
  name: 'Calf Strain (Gastrocnemius/Soleus)',
  description:
      'Tear of the gastrocnemius or soleus muscle, often called "tennis leg".',
  symptoms: [
    'Sudden calf pain',
    'Feeling of being kicked',
    'Swelling and bruising',
    'Difficulty walking on toes',
  ],
  cures: [
    'RICE protocol',
    'Heel raise in shoe',
    'Eccentric calf exercises',
    'Gradual return to activity',
  ],
  exercises: [
    'Eccentric heel drops',
    'Seated calf raise',
    'Ankle alphabet',
    'Balance training',
  ],
  impact: ImpactLevel.moderate,
);

const _achillesTendinopathy = Condition(
  name: 'Achilles Tendinopathy',
  description:
      'Degeneration of the Achilles tendon from repetitive loading, common in runners.',
  symptoms: [
    'Morning stiffness',
    'Pain 2–6 cm above heel',
    'Swelling along tendon',
    'Pain with running',
  ],
  cures: [
    'Eccentric heel drops (Alfredson protocol)',
    'Load management',
    'Shockwave therapy',
    'PRP injection',
  ],
  exercises: [
    'Eccentric heel drops on step',
    'Isometric calf holds',
    'Calf raises (bilateral → unilateral)',
  ],
  impact: ImpactLevel.high,
);

const _gluteStrain = Condition(
  name: 'Gluteal Strain / Piriformis Syndrome',
  description:
      'Strain of gluteal muscles or compression of the sciatic nerve by the piriformis.',
  symptoms: [
    'Deep buttock pain',
    'Pain radiating down leg',
    'Pain with sitting',
    'Difficulty climbing stairs',
  ],
  cures: [
    'Stretching and massage',
    'NSAIDs',
    'Corticosteroid injection',
    'Physiotherapy',
  ],
  exercises: [
    'Pigeon pose stretch',
    'Clamshells',
    'Hip thrust',
    'Glute bridge',
  ],
  impact: ImpactLevel.moderate,
);

const _lowerBackPain = Condition(
  name: 'Lower Back Strain / Lumbar Sprain',
  description:
      'Injury to muscles or ligaments of the lumbar spine from lifting, twisting, or poor posture.',
  symptoms: [
    'Dull or sharp lower back pain',
    'Muscle spasm',
    'Pain with bending',
    'Stiffness in morning',
  ],
  cures: [
    'Active rest (avoid bed rest)',
    'NSAIDs',
    'Heat therapy',
    'Core strengthening program',
  ],
  exercises: ['Cat-cow stretch', 'Bird-dog', 'Dead bug', 'McGill Big 3'],
  impact: ImpactLevel.high,
);

const _neckStrain = Condition(
  name: 'Neck Strain / Cervical Sprain',
  description:
      'Injury to neck muscles or ligaments, often from whiplash, poor posture, or sleeping position.',
  symptoms: [
    'Neck pain and stiffness',
    'Headache',
    'Reduced range of motion',
    'Shoulder pain',
  ],
  cures: [
    'Gentle mobilization',
    'Heat/ice therapy',
    'NSAIDs',
    'Cervical physiotherapy',
  ],
  exercises: [
    'Chin tucks',
    'Cervical rotation',
    'Levator scapulae stretch',
    'Neck isometrics',
  ],
  impact: ImpactLevel.moderate,
);

const _sciatica = Condition(
  name: 'Sciatica',
  description:
      'Compression or irritation of the sciatic nerve, causing radiating pain from lower back to leg.',
  symptoms: [
    'Shooting pain down leg',
    'Numbness or tingling',
    'Weakness in leg',
    'Pain worse with sitting',
  ],
  cures: [
    'Physical therapy',
    'NSAIDs',
    'Epidural steroid injection',
    'Surgery (disc herniation)',
  ],
  exercises: [
    'Sciatic nerve flossing',
    'Piriformis stretch',
    'McKenzie extension',
    'Core stabilization',
  ],
  impact: ImpactLevel.high,
);

const _shinSplints = Condition(
  name: 'Shin Splints (Medial Tibial Stress Syndrome)',
  description:
      'Pain along the inner edge of the tibia from overuse, common in runners and dancers.',
  symptoms: [
    'Shin pain during exercise',
    'Tenderness along tibia',
    'Mild swelling',
    'Pain eases with rest',
  ],
  cures: [
    'Rest and ice',
    'Gradual return to running',
    'Orthotics if needed',
    'Calf and tibialis strengthening',
  ],
  exercises: [
    'Toe raises',
    'Calf stretching',
    'Single-leg balance',
    'Tibialis anterior strengthening',
  ],
  impact: ImpactLevel.moderate,
);

const _kneeOsteoarthritis = Condition(
  name: 'Knee Osteoarthritis / Patellofemoral Pain',
  description:
      'Degeneration of knee cartilage or pain under the kneecap from overuse or malalignment.',
  symptoms: [
    'Knee pain with stairs/squatting',
    'Morning stiffness',
    'Crepitus (grinding)',
    'Swelling',
  ],
  cures: [
    'Weight management',
    'Quadriceps strengthening',
    'Knee brace',
    'Hyaluronic acid injection',
  ],
  exercises: [
    'Terminal knee extension',
    'Step-ups',
    'Straight leg raise',
    'Cycling (low impact)',
  ],
  impact: ImpactLevel.high,
);

const _tricepsTendinopathy = Condition(
  name: 'Triceps Tendinopathy',
  description:
      'Overuse injury of the triceps tendon at the olecranon, common in throwing athletes.',
  symptoms: [
    'Posterior elbow pain',
    'Pain with elbow extension',
    'Tenderness at olecranon',
    'Swelling',
  ],
  cures: [
    'Rest and ice',
    'Eccentric triceps exercises',
    'Ultrasound therapy',
    'Corticosteroid injection',
  ],
  exercises: [
    'Eccentric triceps extension',
    'Triceps stretch',
    'Band pushdown (light)',
  ],
  impact: ImpactLevel.moderate,
);

const _wristTendinitis = Condition(
  name: 'Wrist Tendinitis / Carpal Tunnel',
  description:
      'Inflammation of wrist tendons or compression of the median nerve in the carpal tunnel.',
  symptoms: [
    'Wrist pain and stiffness',
    'Numbness in fingers',
    'Weak grip',
    'Pain at night',
  ],
  cures: [
    'Wrist splint',
    'NSAIDs',
    'Corticosteroid injection',
    'Carpal tunnel release surgery',
  ],
  exercises: [
    'Wrist flexor/extensor stretches',
    'Nerve gliding exercises',
    'Grip strengthening',
  ],
  impact: ImpactLevel.moderate,
);

// ─────────────────────────────────────────────────────────────────────────────
// Muscle → Conditions mapping
// ─────────────────────────────────────────────────────────────────────────────

final Map<String, List<Condition>> muscleConditions = {
  // HEAD / NECK
  'cranium': [_neckStrain],
  'cranium_back': [_neckStrain],
  'face': [_neckStrain],
  'neck': [_neckStrain, _myofascialPain],
  'neck_back': [_neckStrain, _myofascialPain],
  'sternocleidomastoid_l': [_neckStrain, _myofascialPain],
  'sternocleidomastoid_r': [_neckStrain, _myofascialPain],

  // TRAPEZIUS
  'trapezius_l': [_neckStrain, _myofascialPain, _muscleStrain],
  'trapezius_r': [_neckStrain, _myofascialPain, _muscleStrain],
  'upper_trapezius': [_neckStrain, _myofascialPain, _muscleStrain],
  'middle_trapezius': [_muscleStrain, _myofascialPain],
  'lower_trapezius': [_muscleStrain, _myofascialPain],

  // SHOULDERS
  'anterior_deltoid_l': [_shoulderImpingement, _rotatorCuffTear, _muscleStrain],
  'anterior_deltoid_r': [_shoulderImpingement, _rotatorCuffTear, _muscleStrain],
  'medial_deltoid_l': [_shoulderImpingement, _muscleStrain],
  'medial_deltoid_r': [_shoulderImpingement, _muscleStrain],
  'posterior_deltoid_l': [_shoulderImpingement, _rotatorCuffTear],
  'posterior_deltoid_r': [_shoulderImpingement, _rotatorCuffTear],
  'infraspinatus_l': [_rotatorCuffTear, _shoulderImpingement],
  'infraspinatus_r': [_rotatorCuffTear, _shoulderImpingement],
  'teres_minor_l': [_rotatorCuffTear, _myofascialPain],
  'teres_minor_r': [_rotatorCuffTear, _myofascialPain],
  'teres_major_l': [_muscleStrain, _myofascialPain],
  'teres_major_r': [_muscleStrain, _myofascialPain],
  'supraspinatus_l': [_rotatorCuffTear, _shoulderImpingement],
  'supraspinatus_r': [_rotatorCuffTear, _shoulderImpingement],

  // CHEST
  'pectoralis_major_l': [_pectoralStrain, _muscleStrain],
  'pectoralis_major_r': [_pectoralStrain, _muscleStrain],
  'pectoralis_minor_l': [_shoulderImpingement, _myofascialPain],
  'pectoralis_minor_r': [_shoulderImpingement, _myofascialPain],
  'serratus_anterior_l': [_muscleStrain, _myofascialPain],
  'serratus_anterior_r': [_muscleStrain, _myofascialPain],

  // BACK
  'rhomboid_major_l': [_muscleStrain, _myofascialPain],
  'rhomboid_major_r': [_muscleStrain, _myofascialPain],
  'rhomboid_minor_l': [_muscleStrain, _myofascialPain],
  'rhomboid_minor_r': [_muscleStrain, _myofascialPain],
  'latissimus_dorsi_l': [_muscleStrain, _myofascialPain, _lowerBackPain],
  'latissimus_dorsi_r': [_muscleStrain, _myofascialPain, _lowerBackPain],
  'erector_spinae_l': [_lowerBackPain, _muscleStrain, _sciatica],
  'erector_spinae_r': [_lowerBackPain, _muscleStrain, _sciatica],
  'multifidus': [_lowerBackPain, _sciatica],
  'quadratus_lumborum_l': [_lowerBackPain, _myofascialPain],
  'quadratus_lumborum_r': [_lowerBackPain, _myofascialPain],

  // CORE
  'rectus_abdominis': [_abdominalHernia, _muscleStrain, _myofascialPain],
  'external_oblique_l': [_obliquePull, _muscleStrain],
  'external_oblique_r': [_obliquePull, _muscleStrain],
  'external_oblique_back_l': [_obliquePull, _muscleStrain],
  'external_oblique_back_r': [_obliquePull, _muscleStrain],
  'internal_oblique_l': [_obliquePull, _muscleStrain],
  'internal_oblique_r': [_obliquePull, _muscleStrain],
  'transverse_abdominis': [_abdominalHernia, _lowerBackPain],

  // UPPER ARM
  'biceps_brachii_l': [_bicepsTendinopathy, _muscleStrain],
  'biceps_brachii_r': [_bicepsTendinopathy, _muscleStrain],
  'brachialis_l': [_muscleStrain, _muscleTendinitis],
  'brachialis_r': [_muscleStrain, _muscleTendinitis],
  'coracobrachialis_l': [_muscleStrain, _shoulderImpingement],
  'coracobrachialis_r': [_muscleStrain, _shoulderImpingement],
  'triceps_long_head_l': [_tricepsTendinopathy, _muscleStrain],
  'triceps_long_head_r': [_tricepsTendinopathy, _muscleStrain],
  'triceps_lateral_head_l': [_tricepsTendinopathy, _muscleStrain],
  'triceps_lateral_head_r': [_tricepsTendinopathy, _muscleStrain],
  'triceps_medial_head_l': [_tricepsTendinopathy, _muscleStrain],
  'triceps_medial_head_r': [_tricepsTendinopathy, _muscleStrain],

  // FOREARM
  'brachioradialis_l': [_lateralEpicondylitis, _muscleStrain],
  'brachioradialis_r': [_lateralEpicondylitis, _muscleStrain],
  'flexor_carpi_radialis_l': [_medialEpicondylitis, _wristTendinitis],
  'flexor_carpi_radialis_r': [_medialEpicondylitis, _wristTendinitis],
  'flexor_digitorum_l': [_wristTendinitis, _medialEpicondylitis],
  'flexor_digitorum_r': [_wristTendinitis, _medialEpicondylitis],
  'pronator_teres_l': [_medialEpicondylitis, _muscleStrain],
  'pronator_teres_r': [_medialEpicondylitis, _muscleStrain],
  'extensor_carpi_ulnaris_l': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_carpi_ulnaris_r': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_carpi_radialis_l': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_carpi_radialis_r': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_carpi_ulnaris_back_l': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_carpi_ulnaris_back_r': [_lateralEpicondylitis, _wristTendinitis],
  'extensor_digitorum_back_l': [_lateralEpicondylitis, _muscleTendinitis],
  'extensor_digitorum_back_r': [_lateralEpicondylitis, _muscleTendinitis],
  'anconeus_l': [_lateralEpicondylitis, _muscleStrain],
  'anconeus_r': [_lateralEpicondylitis, _muscleStrain],
  'wrist_hand_l': [_wristTendinitis, _lateralEpicondylitis],
  'wrist_hand_r': [_wristTendinitis, _lateralEpicondylitis],
  'wrist_hand_back_l': [_wristTendinitis, _lateralEpicondylitis],
  'wrist_hand_back_r': [_wristTendinitis, _lateralEpicondylitis],

  // HIP
  'iliopsoas_l': [_hipFlexorStrain, _muscleStrain],
  'iliopsoas_r': [_hipFlexorStrain, _muscleStrain],
  'tensor_fasciae_latae_l': [_itBandSyndrome, _hipFlexorStrain],
  'tensor_fasciae_latae_r': [_itBandSyndrome, _hipFlexorStrain],
  'gluteus_maximus_l': [_gluteStrain, _sciatica],
  'gluteus_maximus_r': [_gluteStrain, _sciatica],
  'gluteus_medius_l': [_gluteStrain, _myofascialPain],
  'gluteus_medius_r': [_gluteStrain, _myofascialPain],
  'gluteus_minimus_l': [_gluteStrain, _sciatica],
  'gluteus_minimus_r': [_gluteStrain, _sciatica],
  'piriformis_l': [_gluteStrain, _sciatica],
  'piriformis_r': [_gluteStrain, _sciatica],

  // THIGH FRONT
  'rectus_femoris_l': [_quadStrain, _muscleTendinitis],
  'rectus_femoris_r': [_quadStrain, _muscleTendinitis],
  'vastus_lateralis_l': [_quadStrain, _itBandSyndrome, _kneeOsteoarthritis],
  'vastus_lateralis_r': [_quadStrain, _itBandSyndrome, _kneeOsteoarthritis],
  'vastus_medialis_l': [_quadStrain, _kneeOsteoarthritis],
  'vastus_medialis_r': [_quadStrain, _kneeOsteoarthritis],
  'vastus_intermedius_l': [_quadStrain, _compartmentSyndrome],
  'vastus_intermedius_r': [_quadStrain, _compartmentSyndrome],
  'sartorius_l': [_muscleStrain, _myofascialPain],
  'sartorius_r': [_muscleStrain, _myofascialPain],
  'adductor_longus_l': [_muscleStrain, _myofascialPain],
  'adductor_longus_r': [_muscleStrain, _myofascialPain],
  'adductor_magnus_l': [_muscleStrain, _myofascialPain],
  'adductor_magnus_r': [_muscleStrain, _myofascialPain],
  'gracilis_l': [_muscleStrain, _myofascialPain],
  'gracilis_r': [_muscleStrain, _myofascialPain],
  'pectineus_l': [_muscleStrain, _hipFlexorStrain],
  'pectineus_r': [_muscleStrain, _hipFlexorStrain],
  'patella_l': [_kneeOsteoarthritis, _muscleTendinitis],
  'patella_r': [_kneeOsteoarthritis, _muscleTendinitis],

  // THIGH BACK
  'biceps_femoris_l': [_hamstringStrain, _muscleStrain],
  'biceps_femoris_r': [_hamstringStrain, _muscleStrain],
  'biceps_femoris_long_l': [_hamstringStrain, _muscleStrain],
  'biceps_femoris_long_r': [_hamstringStrain, _muscleStrain],
  'biceps_femoris_short_l': [_hamstringStrain, _muscleStrain],
  'biceps_femoris_short_r': [_hamstringStrain, _muscleStrain],
  'semitendinosus_l': [_hamstringStrain, _myofascialPain],
  'semitendinosus_r': [_hamstringStrain, _myofascialPain],
  'semimembranosus_l': [_hamstringStrain, _myofascialPain],
  'semimembranosus_r': [_hamstringStrain, _myofascialPain],
  'iliotibial_band_l': [_itBandSyndrome, _myofascialPain],
  'iliotibial_band_r': [_itBandSyndrome, _myofascialPain],

  // LOWER LEG
  'tibialis_anterior_l': [_shinSplints, _muscleStrain],
  'tibialis_anterior_r': [_shinSplints, _muscleStrain],
  'extensor_digitorum_longus_l': [_shinSplints, _muscleTendinitis],
  'extensor_digitorum_longus_r': [_shinSplints, _muscleTendinitis],
  'extensor_hallucis_longus_l': [_shinSplints, _muscleTendinitis],
  'extensor_hallucis_longus_r': [_shinSplints, _muscleTendinitis],
  'peroneus_longus_l': [_muscleStrain, _muscleTendinitis],
  'peroneus_longus_r': [_muscleStrain, _muscleTendinitis],
  'peroneus_brevis_l': [_muscleStrain, _muscleTendinitis],
  'peroneus_brevis_r': [_muscleStrain, _muscleTendinitis],
  'gastrocnemius_l': [_calfStrain, _muscleStrain],
  'gastrocnemius_r': [_calfStrain, _muscleStrain],
  'gastrocnemius_medial_l': [_calfStrain, _muscleStrain],
  'gastrocnemius_medial_r': [_calfStrain, _muscleStrain],
  'gastrocnemius_lateral_l': [_calfStrain, _compartmentSyndrome],
  'gastrocnemius_lateral_r': [_calfStrain, _compartmentSyndrome],
  'soleus_l': [_calfStrain, _achillesTendinopathy],
  'soleus_r': [_calfStrain, _achillesTendinopathy],
  'soleus_back_l': [_calfStrain, _achillesTendinopathy],
  'soleus_back_r': [_calfStrain, _achillesTendinopathy],
  'achilles_tendon_l': [_achillesTendinopathy, _calfStrain],
  'achilles_tendon_r': [_achillesTendinopathy, _calfStrain],
  'flexor_digitorum_longus_l': [_muscleTendinitis, _wristTendinitis],
  'flexor_digitorum_longus_r': [_muscleTendinitis, _wristTendinitis],
  'ankle_foot_l': [_achillesTendinopathy, _muscleTendinitis],
  'ankle_foot_r': [_achillesTendinopathy, _muscleTendinitis],
  'ankle_foot_back_l': [_achillesTendinopathy, _muscleTendinitis],
  'ankle_foot_back_r': [_achillesTendinopathy, _muscleTendinitis],
};

/// Returns deduplicated conditions for a set of selected muscle IDs
List<Condition> getConditionsForMuscles(Set<String> muscleIds) {
  final seen = <String>{};
  final result = <Condition>[];
  for (final id in muscleIds) {
    final conditions = muscleConditions[id] ?? [];
    for (final c in conditions) {
      if (seen.add(c.name)) result.add(c);
    }
  }
  // Sort: high → moderate → low
  result.sort((a, b) => b.impact.index.compareTo(a.impact.index));
  return result;
}

/// Overall impact score across all selected muscles
ImpactLevel overallImpact(List<Condition> conditions) {
  if (conditions.any((c) => c.impact == ImpactLevel.high)) {
    return ImpactLevel.high;
  }
  if (conditions.any((c) => c.impact == ImpactLevel.moderate)) {
    return ImpactLevel.moderate;
  }
  return ImpactLevel.low;
}
