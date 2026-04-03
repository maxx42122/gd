import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// ── Types ─────────────────────────────────────────────────────────────────────

interface UserProfile {
  age?: number;
  medicalHistory?: string[];
}

interface SymptomData {
  symptoms: string[];
  muscleIds?: string[];
  userProfile: UserProfile;
}

// ── Symptom weights ───────────────────────────────────────────────────────────

const WEIGHTS: Record<string, number> = {
  "chest pain": 10,
  "difficulty breathing": 10,
  "shortness of breath": 10,
  "severe bleeding": 10,
  "loss of consciousness": 10,
  "severe headache": 8,
  "high fever": 6,
  "persistent cough": 5,
  "severe pain": 7,
  "vomiting blood": 9,
  seizure: 9,
  fever: 5,
  cough: 3,
  "back pain": 4,
  "joint pain": 4,
  "muscle pain": 3,
  "abdominal pain": 5,
  dizziness: 4,
  nausea: 3,
  vomiting: 4,
  "mild headache": 2,
  fatigue: 3,
  "sore throat": 3,
  "runny nose": 2,
};

function scoreSymptoms(symptoms: string[]): number {
  let total = 0;
  for (const s of symptoms) {
    const lower = s.toLowerCase();
    let best = 2;
    for (const [key, w] of Object.entries(WEIGHTS)) {
      if (lower.includes(key) || key.includes(lower)) {
        if (w > best) best = w;
      }
    }
    total += best;
  }
  return total;
}

function calcRisk(score: number): {
  level: string;
  guidance: string;
  explanation: string;
  confidence: number;
} {
  if (score >= 15) {
    return {
      level: "high",
      guidance:
        "Seek immediate medical attention. Call emergency services (911) or go to the nearest emergency room now.",
      explanation:
        "Your symptoms indicate a potentially serious condition requiring urgent evaluation.",
      confidence: 0.85,
    };
  } else if (score >= 8) {
    return {
      level: "medium",
      guidance:
        "Consult a healthcare provider within 24 hours. Monitor symptoms closely.",
      explanation:
        "Your symptoms suggest a condition that should be evaluated by a medical professional soon.",
      confidence: 0.7,
    };
  }
  return {
    level: "low",
    guidance:
      "Monitor symptoms. Home care may be appropriate. Consult a doctor if symptoms worsen or persist beyond 3 days.",
    explanation:
      "Your symptoms appear mild. Rest and over-the-counter remedies may help.",
    confidence: 0.6,
  };
}

function generateFollowUp(
  symptoms: string[]
): Array<{ question: string; options: string[]; multiSelect?: boolean }> {
  const qs = [];
  const lower = symptoms.map((s) => s.toLowerCase());

  if (lower.some((s) => s.includes("fever"))) {
    qs.push({
      question: "How high is your temperature?",
      options: ["Below 100°F", "100–102°F", "Above 102°F"],
    });
  }
  if (lower.some((s) => s.includes("pain"))) {
    qs.push({
      question: "How severe is the pain (1–10)?",
      options: ["1–3 (Mild)", "4–6 (Moderate)", "7–10 (Severe)"],
    });
  }
  if (lower.some((s) => s.includes("cough"))) {
    qs.push({
      question: "What accompanies the cough?",
      options: ["Mucus", "Blood", "Chest tightness", "Nothing"],
      multiSelect: true,
    });
  }
  return qs;
}

// ── analyzeSymptoms ───────────────────────────────────────────────────────────

export const analyzeSymptoms = functions.https.onCall(
  async (request: functions.https.CallableRequest<SymptomData>) => {
    const { symptoms, muscleIds = [], userProfile } = request.data;
    const uid = request.auth?.uid;
    if (!uid) throw new functions.https.HttpsError("unauthenticated", "Login required");

    let score = scoreSymptoms(symptoms);

    // Muscle area modifier
    score += muscleIds.length * 1.5;

    // Age modifier
    if ((userProfile.age ?? 0) > 65) score *= 1.2;
    if ((userProfile.age ?? 0) < 5) score *= 1.15;
    if ((userProfile.medicalHistory?.length ?? 0) > 0) score *= 1.1;

    const risk = calcRisk(score);
    const followUp = generateFollowUp(symptoms);

    // Persist to Firestore
    const docRef = db
      .collection("users")
      .doc(uid)
      .collection("assessments")
      .doc();

    await docRef.set({
      symptoms,
      muscleIds,
      riskLevel: risk.level,
      confidence: risk.confidence,
      guidance: risk.guidance,
      explanation: risk.explanation,
      followUpQuestions: followUp,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      resolved: false,
    });

    return {
      id: docRef.id,
      ...risk,
      followUpQuestions: followUp,
    };
  }
);

// ── analyzeHealthTrends ───────────────────────────────────────────────────────

export const analyzeHealthTrends = functions.https.onCall(
  async (request: functions.https.CallableRequest<{ period?: number }>) => {
    const uid = request.auth?.uid;
    if (!uid) throw new functions.https.HttpsError("unauthenticated", "Login required");

    const period = request.data.period ?? 30;
    const since = new Date();
    since.setDate(since.getDate() - period);

    const snap = await db
      .collection("users")
      .doc(uid)
      .collection("assessments")
      .where("timestamp", ">=", since)
      .orderBy("timestamp", "desc")
      .get();

    const dist: Record<string, number> = { low: 0, medium: 0, high: 0 };
    const symptoms: Record<string, number> = {};
    const timeline: Array<{ date: string; riskLevel: string }> = [];

    snap.forEach((doc) => {
      const d = doc.data();
      dist[d.riskLevel as string] = (dist[d.riskLevel as string] ?? 0) + 1;
      (d.symptoms as string[]).forEach((s: string) => {
        symptoms[s] = (symptoms[s] ?? 0) + 1;
      });
      timeline.push({
        date: (d.timestamp as admin.firestore.Timestamp).toDate().toISOString(),
        riskLevel: d.riskLevel as string,
      });
    });

    return {
      totalAssessments: snap.size,
      monthlyCount: snap.size,
      riskDistribution: dist,
      commonSymptoms: symptoms,
      timeline,
    };
  }
);
