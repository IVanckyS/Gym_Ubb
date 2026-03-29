-- =============================================================
-- GymUBB — Seed de ejercicios para DESARROLLO
-- Solo ejecutar en entorno dev/staging
-- No incluye usuarios (los crea el módulo auth con bcrypt)
-- =============================================================

-- Insertar solo si no hay ejercicios aún
DO $$ BEGIN
  IF (SELECT COUNT(*) FROM exercises) > 0 THEN
    RAISE NOTICE 'Ejercicios ya sembrados, omitiendo seed.';
    RETURN;
  END IF;

  -- ── Pecho ───────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Press de Banca', 'pecho', 'intermedio',
    'Ejercicio fundamental para el desarrollo de la musculatura pectoral. Se realiza tumbado en un banco plano empujando una barra desde el pecho hacia arriba.',
    ARRAY['Pectoral mayor', 'Tríceps', 'Deltoides anterior'],
    ARRAY['Túmbate en el banco con los pies apoyados en el suelo.', 'Agarra la barra con un agarre ligeramente más ancho que los hombros.', 'Baja la barra controladamente hasta el pecho.', 'Empuja la barra hacia arriba hasta extender los brazos completamente.'],
    'Siempre usa un spotter o barras de seguridad. No arquees excesivamente la espalda. Mantén los pies en el suelo.',
    ARRAY['Press inclinado', 'Press declinado', 'Press con mancuernas', 'Press con cables'],
    'https://www.youtube.com/embed/rT7DgCr-3pg',
    'Barra + Banco', 3, '8-12', 90
  ),
  (
    'Fondos en Paralelas', 'pecho', 'intermedio',
    'Excelente ejercicio de peso corporal para pecho y tríceps. La inclinación del torso determina qué músculo se trabaja más.',
    ARRAY['Pectoral', 'Tríceps', 'Deltoides anterior'],
    ARRAY['Sujétate en las barras paralelas con los brazos extendidos.', 'Inclina el torso ligeramente hacia adelante para trabajar más el pecho.', 'Baja el cuerpo flexionando los codos hasta 90°.', 'Empuja hacia arriba hasta extender los brazos.'],
    'No bajes demasiado si tienes problemas de hombros. Comienza con el peso corporal antes de añadir peso.',
    ARRAY['Fondos con peso', 'Fondos en banco', 'Fondos asistidos'],
    NULL,
    'Barras paralelas', 3, '8-12', 90
  ),
  (
    'Aperturas con Mancuernas', 'pecho', 'principiante',
    'Ejercicio de aislamiento para el pecho. Trabaja el pectoral en su rango de movimiento completo.',
    ARRAY['Pectoral mayor', 'Deltoides anterior'],
    ARRAY['Tumbado en banco plano, sujeta mancuernas sobre el pecho.', 'Abre los brazos en arco amplio hacia los lados.', 'Cierra los brazos de vuelta a la posición inicial.'],
    'Mantén ligera flexión en los codos. No bajes demasiado si tienes problemas de hombros.',
    ARRAY['Aperturas inclinadas', 'Aperturas en cables', 'Aperturas en máquina pec-deck'],
    NULL,
    'Mancuernas + Banco', 3, '12-15', 60
  );

  -- ── Espalda ─────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Peso Muerto', 'espalda', 'avanzado',
    'Ejercicio compuesto que trabaja toda la cadena posterior del cuerpo. Desarrolla fuerza total y masa muscular.',
    ARRAY['Isquiotibiales', 'Glúteos', 'Espalda baja', 'Trapecios', 'Core'],
    ARRAY['Párate frente a la barra con los pies a la anchura de caderas.', 'Agáchate y agarra la barra con ambas manos justo fuera de las piernas.', 'Mantén la espalda recta y el pecho elevado.', 'Levanta la barra empujando el suelo con los pies.', 'Extiende completamente caderas y rodillas al llegar arriba.'],
    'CRÍTICO: nunca redondees la espalda lumbar. Comienza con peso moderado hasta dominar la técnica.',
    ARRAY['Peso muerto rumano', 'Peso muerto sumo', 'Peso muerto con mancuernas', 'Peso muerto con trampa'],
    'https://www.youtube.com/embed/op9kVnSso6Q',
    'Barra', 3, '3-6', 180
  ),
  (
    'Dominadas', 'espalda', 'intermedio',
    'Ejercicio de peso corporal que desarrolla la espalda ancha (dorsal) y los bíceps. Indicador de relación fuerza/peso.',
    ARRAY['Dorsal ancho', 'Bíceps', 'Romboides', 'Core'],
    ARRAY['Cuelga de la barra con agarre prono, algo más ancho que los hombros.', 'Activa el core y retrae las escápulas.', 'Tira hacia arriba hasta que la barbilla supere la barra.', 'Baja controladamente hasta casi extender los brazos.'],
    'No balancees el cuerpo. Si no puedes hacer ninguna, usa banda elástica de asistencia.',
    ARRAY['Chin-ups (agarre supino)', 'Dominadas con peso', 'Dominadas neutras', 'Remo en barra'],
    'https://www.youtube.com/embed/eGo4IYlbE5g',
    'Barra de dominadas', 3, '6-10', 90
  ),
  (
    'Remo con Barra', 'espalda', 'intermedio',
    'Ejercicio compuesto para el desarrollo de la espalda media. Trabaja dorsal, romboides y trapecios.',
    ARRAY['Dorsal ancho', 'Romboides', 'Trapecio medio', 'Bíceps'],
    ARRAY['Inclínate hacia adelante manteniendo la espalda recta (45°).', 'Agarra la barra con agarre prono.', 'Tira de la barra hacia el abdomen bajo.', 'Baja controladamente.'],
    'Nunca redondees la espalda. Mantén la cabeza en posición neutra.',
    ARRAY['Remo Pendlay', 'Remo con mancuernas', 'Remo en máquina', 'Remo en polea baja'],
    NULL,
    'Barra', 4, '8-12', 90
  );

  -- ── Piernas ─────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Sentadilla', 'piernas', 'intermedio',
    'El rey de los ejercicios. Trabaja principalmente cuádriceps, isquiotibiales y glúteos. Movimiento funcional básico.',
    ARRAY['Cuádriceps', 'Isquiotibiales', 'Glúteos', 'Core'],
    ARRAY['Coloca la barra sobre la parte alta de la espalda (trapecio).', 'Pies al ancho de los hombros, ligeramente abiertos.', 'Baja manteniendo el pecho erguido y las rodillas en línea con los pies.', 'Sube empujando desde los talones hasta posición inicial.'],
    'Nunca redondees la espalda. Mantén las rodillas sin colapsar hacia adentro. Usa cinturón para cargas pesadas.',
    ARRAY['Sentadilla goblet', 'Sentadilla frontal', 'Sentadilla búlgara', 'Prensa de piernas'],
    'https://www.youtube.com/embed/ultWZbUMPL8',
    'Barra + Rack', 4, '5-8', 120
  ),
  (
    'Peso Muerto Rumano', 'piernas', 'intermedio',
    'Variante del peso muerto que aísla los isquiotibiales y glúteos. Excelente para la cadena posterior.',
    ARRAY['Isquiotibiales', 'Glúteos', 'Espalda baja'],
    ARRAY['De pie con barra en agarre prono.', 'Inclina el torso hacia adelante manteniendo piernas casi rectas.', 'Baja la barra siguiendo las piernas hasta sentir estiramiento.', 'Vuelve a posición inicial contrayendo glúteos.'],
    'Mantén la espalda recta en todo momento. No bajes más allá de lo que tu flexibilidad permita.',
    ARRAY['PDM con mancuernas', 'PDM unilateral', 'PDM con banda'],
    NULL,
    'Barra o Mancuernas', 3, '10-12', 90
  ),
  (
    'Zancadas', 'piernas', 'principiante',
    'Ejercicio unilateral que desarrolla cuádriceps y glúteos mejorando además el equilibrio y la coordinación.',
    ARRAY['Cuádriceps', 'Glúteos', 'Isquiotibiales'],
    ARRAY['De pie con los pies juntos.', 'Da un paso hacia adelante con una pierna.', 'Baja la rodilla trasera hacia el suelo.', 'Empuja con el pie delantero para volver a la posición inicial.'],
    'La rodilla delantera no debe superar la punta del pie. Mantén el torso erguido.',
    ARRAY['Zancadas en reversa', 'Zancadas laterales', 'Zancadas caminando', 'Zancadas con barra'],
    NULL,
    'Peso corporal o Mancuernas', 3, '10-12 por pierna', 60
  ),
  (
    'Leg Press', 'piernas', 'principiante',
    'Ejercicio en máquina para cuádriceps. Permite usar cargas altas con menor riesgo que la sentadilla libre.',
    ARRAY['Cuádriceps', 'Glúteos', 'Isquiotibiales'],
    ARRAY['Siéntate en la máquina y coloca los pies en la plataforma.', 'Libera los seguros y baja el peso flexionando las rodillas.', 'Empuja hasta casi extender las piernas (sin bloquear rodillas).'],
    'No bloquees las rodillas al extender. Mantén la espalda pegada al respaldo.',
    ARRAY['Leg press unilateral', 'Leg press con pies altos', 'Leg press con pies bajos'],
    NULL,
    'Máquina Leg Press', 4, '10-15', 90
  );

  -- ── Hombros ─────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Press Militar', 'hombros', 'intermedio',
    'Ejercicio de empuje vertical que trabaja principalmente los deltoides. Fundamental para el desarrollo de hombros fuertes.',
    ARRAY['Deltoides', 'Tríceps', 'Trapecio superior'],
    ARRAY['De pie o sentado, sujeta la barra a la altura de los hombros.', 'Empuja la barra hacia arriba hasta extender los brazos.', 'Baja la barra controladamente de vuelta a los hombros.'],
    'Evita arquear excesivamente la zona lumbar. No uses los pies para dar impulso en la versión estricta.',
    ARRAY['Press Arnold', 'Press con mancuernas', 'Elevaciones laterales', 'Press en máquina'],
    'https://www.youtube.com/embed/2yjwXTZQDDI',
    'Barra o Mancuernas', 3, '8-12', 90
  ),
  (
    'Elevaciones Laterales', 'hombros', 'principiante',
    'Ejercicio de aislamiento para el deltoides lateral. Fundamental para dar anchura a los hombros.',
    ARRAY['Deltoides lateral', 'Deltoides anterior'],
    ARRAY['De pie, sujeta mancuernas a los costados.', 'Eleva los brazos hacia los lados hasta la altura de los hombros.', 'Baja controladamente.'],
    'Usa pesos moderados. No balancees el torso. Mantén ligera flexión en los codos.',
    ARRAY['Elevaciones con cables', 'Elevaciones frontales', 'Elevaciones en máquina'],
    NULL,
    'Mancuernas', 3, '12-15', 60
  );

  -- ── Brazos ──────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Curl de Bíceps', 'brazos', 'principiante',
    'Ejercicio de aislamiento para bíceps. Movimiento básico para el desarrollo del brazo anterior.',
    ARRAY['Bíceps braquial', 'Braquial', 'Braquiorradial'],
    ARRAY['De pie, sujeta las mancuernas con agarre supino.', 'Mantén los codos pegados al cuerpo.', 'Sube las mancuernas contrayendo el bíceps.', 'Baja controladamente.'],
    'No balancees el torso para dar impulso. Mantén los codos estáticos.',
    ARRAY['Curl con barra', 'Curl martillo', 'Curl en predicador', 'Curl concentrado'],
    NULL,
    'Mancuernas o Barra', 3, '10-15', 60
  ),
  (
    'Extensiones de Tríceps', 'brazos', 'principiante',
    'Ejercicio de aislamiento para tríceps. Trabaja las tres cabezas del tríceps braquial.',
    ARRAY['Tríceps braquial'],
    ARRAY['De pie con los pies separados, sujeta una mancuerna con ambas manos sobre la cabeza.', 'Baja la mancuerna detrás de la cabeza flexionando los codos.', 'Extiende los brazos llevando la mancuerna hacia arriba.'],
    'Mantén los codos apuntando hacia arriba y evita abrirlos.',
    ARRAY['Press francés', 'Extensiones en polea', 'Kickbacks'],
    NULL,
    'Mancuerna', 3, '12-15', 60
  );

  -- ── Core ────────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Plancha', 'core', 'principiante',
    'Ejercicio isométrico fundamental para fortalecer el core. Activa transverso, recto abdominal y oblicuos.',
    ARRAY['Transverso abdominal', 'Recto abdominal', 'Oblicuos', 'Glúteos'],
    ARRAY['Apoya los antebrazos y pies en el suelo.', 'El cuerpo forma una línea recta de cabeza a talones.', 'Contrae el abdomen y glúteos.', 'Mantén la posición el tiempo indicado.'],
    'No dejes caer las caderas ni las subas demasiado. Respira normalmente.',
    ARRAY['Plancha lateral', 'Plancha con elevación de pierna', 'Plancha dinámica', 'Rueda abdominal'],
    NULL,
    'Solo peso corporal', 3, '30-60 seg', 45
  ),
  (
    'Crunch Abdominal', 'core', 'principiante',
    'Ejercicio básico para el recto abdominal. Ideal para principiantes como inicio del trabajo de core.',
    ARRAY['Recto abdominal', 'Oblicuos'],
    ARRAY['Tumbado boca arriba con rodillas flexionadas.', 'Manos detrás de la cabeza o cruzadas en el pecho.', 'Eleva los hombros del suelo contrayendo el abdomen.', 'Vuelve abajo sin llegar a apoyar completamente.'],
    'No tires del cuello. El movimiento viene del abdomen.',
    ARRAY['Crunch con giro', 'Crunch inverso', 'Crunch en cable', 'Sit-up'],
    NULL,
    'Solo peso corporal', 3, '15-20', 45
  );

  -- ── Glúteos ─────────────────────────────────────────────────────────────

  INSERT INTO exercises (name, muscle_group, difficulty, description, muscles, instructions, safety_notes, variations, video_url, equipment, default_sets, default_reps, default_rest_seconds) VALUES
  (
    'Hip Thrust', 'gluteos', 'principiante',
    'El mejor ejercicio para el desarrollo de glúteos. Alta activación muscular y seguro para la espalda.',
    ARRAY['Glúteo mayor', 'Glúteo medio', 'Isquiotibiales'],
    ARRAY['Apoya la parte superior de la espalda en un banco.', 'Coloca la barra sobre la cadera con protección.', 'Empuja las caderas hacia arriba hasta alinear el cuerpo.', 'Aprieta los glúteos en la posición alta.', 'Baja controladamente.'],
    'Usa una almohadilla para proteger la cadera de la barra.',
    ARRAY['Puente de glúteos', 'Hip thrust con banda', 'Hip thrust unilateral'],
    NULL,
    'Barra + Banco', 3, '10-15', 90
  );

  RAISE NOTICE 'Seed completado: % ejercicios insertados.', (SELECT COUNT(*) FROM exercises);
END $$;
