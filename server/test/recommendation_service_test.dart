import 'package:test/test.dart';
import 'package:gym_ubb_server/src/services/recommendation_service.dart';

void main() {
  group('parseRepsRange', () {
    test('rango "8-12" retorna (8, 12)', () {
      expect(parseRepsRange('8-12'), (8, 12));
    });
    test('valor único "10" retorna (10, 10)', () {
      expect(parseRepsRange('10'), (10, 10));
    });
    test('valor inválido usa 8 por defecto', () {
      expect(parseRepsRange('abc'), (8, 8));
    });
  });

  group('epley1RM / weightForReps', () {
    test('epley1RM calcula 1RM estimado', () {
      expect(epley1RM(100, 5), closeTo(116.67, 0.1));
    });
    test('weightForReps es la inversa de epley1RM', () {
      final oneRm = epley1RM(100, 5);
      expect(weightForReps(oneRm, 5), closeTo(100, 0.01));
    });
  });

  group('roundToIncrement', () {
    test('redondea hacia el incremento más cercano', () {
      expect(roundToIncrement(41.3, 2.5), 42.5);
      expect(roundToIncrement(40.0, 2.5), 40.0);
      expect(roundToIncrement(0, 2.5), 0);
    });
  });

  group('computeSuggestion — cascada', () {
    test('usa el peso de la rutina si está definido (source: rutina)', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        routineTargetWeightKg: 60,
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'rutina');
      expect(s.weightKg, 60);
      expect(s.reps, 8);
    });

    test('progresión doble: sube de peso si todas las series llegaron al tope', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        lastSessionSets: const [
          CompletedSet(completed: true, weightKg: 40, reps: 12),
          CompletedSet(completed: true, weightKg: 40, reps: 12),
          CompletedSet(completed: true, weightKg: 40, reps: 13),
        ],
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'historial');
      expect(s.weightKg, 42.5); // 40 + incremento 2.5 (barra)
      expect(s.reps, 8);
    });

    test('progresión doble: mantiene el peso si no llegó al tope', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        lastSessionSets: const [
          CompletedSet(completed: true, weightKg: 40, reps: 10),
          CompletedSet(completed: true, weightKg: 40, reps: 8),
        ],
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'historial');
      expect(s.weightKg, 40);
    });

    test('mancuernas incrementan de a 2 kg en vez de 2.5', () {
      final s = computeSuggestion(
        exerciseName: 'Press con Mancuernas',
        muscleGroup: 'pecho',
        equipment: 'Mancuernas + Banco',
        repsRange: '8-12',
        lastSessionSets: const [
          CompletedSet(completed: true, weightKg: 20, reps: 12),
        ],
        fitnessLevel: 'intermedio',
      );
      expect(s.weightKg, 22);
    });

    test('usa el PR (Epley) si no hay historial ni peso de rutina', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        prWeightKg: 100,
        prReps: 5,
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'pr');
      // 1RM ~116.67, peso de trabajo a 8 reps = 116.67 / (1 + 8/30) ~ 92.1 -> redondeado a 92.5
      expect(s.weightKg, 92.5);
    });

    test('sin historial ni PR: usa ratio de compuesto conocido por nivel y peso corporal', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        userWeightKg: 80,
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'estimado');
      expect(s.weightKg, 65.0); // 80 * 0.80 = 64 -> redondeado a 65 (incremento 2.5)
    });

    test('sin historial/PR/peso corporal: usa peso base del implemento', () {
      final s = computeSuggestion(
        exerciseName: 'Press de Banca',
        muscleGroup: 'pecho',
        equipment: 'Barra + Banco',
        repsRange: '8-12',
        fitnessLevel: 'principiante',
      );
      expect(s.source, 'estimado');
      expect(s.weightKg, 20.0); // peso de una barra olímpica vacía
    });

    test('ejercicio accesorio sin nombre de compuesto usa el ratio del grupo muscular', () {
      final s = computeSuggestion(
        exerciseName: 'Aperturas con Mancuernas',
        muscleGroup: 'pecho',
        equipment: 'Mancuernas + Banco',
        repsRange: '10-15',
        userWeightKg: 80,
        fitnessLevel: 'intermedio',
      );
      expect(s.source, 'estimado');
      expect(s.weightKg, greaterThan(0));
    });
  });
}
