import 'package:get/get.dart';

import '../../../datos/servicios/ml_servicio.dart';
import '../../../dominio/casos_uso/diagnostico_caso_uso.dart';
import '../../../dominio/casos_uso/gemini_caso_uso.dart';
import '../../../dominio/entidades/diagnostico.dart';
import '../../../dominio/entidades/informacion_condicion.dart';
import '../../../dominio/entidades/producto.dart';
import '../../../dominio/enumeraciones/condicion_piel.dart';
import '../../../dominio/utilidades/resultado.dart';
import 'dart:convert';
import '../../historial/controladores/historial_controlador.dart';
import '../../perfil/controladores/perfil_controlador.dart';

class DiagnosticoControlador extends GetxController {
  final DiagnosticoCasoUso _casoUso;
  final GeminiCasoUso _geminiCasoUso;

  DiagnosticoControlador({
    required DiagnosticoCasoUso casoUso,
    required GeminiCasoUso geminiCasoUso,
  })  : _casoUso = casoUso,
        _geminiCasoUso = geminiCasoUso;

  final condicion = CondicionPiel.normal.obs;
  final confianza = 0.0.obs;
  final descripcion = ''.obs;
  final imagenPath = ''.obs;
  final severidad = ''.obs;
  final productosRecomendados = <Producto>[].obs;
  final guardando = false.obs;
  final deteccionesResumen = <String, int>{}.obs;

  final informacionCondicion = Rxn<InformacionCondicion>();
  final cargandoInfoIA = false.obs;

  void cargarDesdeResultadoML(ResultadoAnalisis r) {
    condicion.value = _mapearCondicion(r.tipoPiel);
    confianza.value = r.confianzaTipoPiel;
    severidad.value = r.severidadGeneral;
    imagenPath.value = r.imagenPath;
    deteccionesResumen.value = r.conteoPorCondicion;

    final partes = <String>[];
    if (r.severidadGeneral.isNotEmpty) {
      partes.add('Severidad: ${r.severidadGeneral}');
    }
    if (r.recomendacionesDia.isNotEmpty) {
      partes.add('\n   Rutina Día    \n${r.recomendacionesDia.join('\n')}');
    }
    if (r.recomendacionesNoche.isNotEmpty) {
      partes.add(
        '\n    Rutina Noche    \n${r.recomendacionesNoche.join('\n')}',
      );
    }
    if (r.aclaraciones.isNotEmpty) {
      partes.add('\n${r.aclaraciones.join('\n')}');
    }
    descripcion.value = partes.join('\n');
  }

  Future<void> cargarInformacionIA() async {
    if (condicion.value == CondicionPiel.normal) return;
    cargandoInfoIA.value = true;
    informacionCondicion.value = null;
    final info = await _geminiCasoUso.obtenerInformacionCondicion(
      condicion.value,
      confianza: confianza.value,
    );
    informacionCondicion.value = info ?? _fallbackCondicion(condicion.value);
    cargandoInfoIA.value = false;
  }

  InformacionCondicion _fallbackCondicion(CondicionPiel condicion) {
    switch (condicion) {
      case CondicionPiel.acne:
        return InformacionCondicion(
          descripcion:
              'El acné es una afección cutánea que ocurre cuando los folículos pilosos se obstruyen con sebo y células muertas, formando comedones, pápulas, pústulas o quistes. Es más común en la adolescencia pero puede persistir en la edad adulta.',
          causas: [
            'El acné se produce principalmente por la obstrucción de los poros con exceso de sebo (grasa natural) y células muertas. Las glándulas sebáceas, estimuladas por hormonas andrógenas, producen más sebo del necesario, creando un ambiente ideal para la bacteria Cutibacterium acnes, que desencadena inflamación.',
            'Los cambios hormonales son un factor clave: durante la pubertad, el ciclo menstrual, el embarazo o el estrés, los niveles hormonales fluctúan y aumentan la producción de sebo, empeorando el acné.',
            'Factores externos como el uso de cosméticos comedogénicos, la fricción constante (gorras, cascos), la humedad y ciertos medicamentos (corticoides, litio) pueden obstruir los poros y desencadenar brotes.',
          ],
          recomendacionDermatologo:
              'Si el acné es persistente, causa cicatrices o afecta tu autoestima, acude a un dermatólogo. Señales de alerta: quistes profundos y dolorosos, acné que no mejora con cuidados básicos o que deja marcas oscuras.',
          consejosCuidado: [
            'Lava tu rostro dos veces al día con un limpiador suave no comedogénico.',
            'Evita tocar, exprimir o reventar los granitos para prevenir cicatrices e infecciones.',
            'Usa productos oil-free y no comedogénicos. Aplica protector solar oil-free diariamente.',
          ],
        );
      case CondicionPiel.eczema:
        return InformacionCondicion(
          descripcion:
              'El eczema (dermatitis atópica) es una inflamación crónica de la piel que causa enrojecimiento, picazón intensa, sequedad y descamación. Suele aparecer en parches y puede afectar cualquier parte del cuerpo.',
          causas: [
            'El eczema se origina por una alteración en la barrera cutánea: la piel no retiene suficiente agua y permite la entrada de irritantes y alérgenos. Esto se debe a una deficiencia de filagrina, una proteína clave para la hidratación y protección de la piel.',
            'El sistema inmunológico hiperreactivo juega un papel fundamental: las células inmunitarias reaccionan de forma exagerada ante estímulos que normalmente serían inofensivos, liberando sustancias inflamatorias que causan picazón y enrojecimiento.',
            'Factores ambientales desencadenantes incluyen: clima seco o frío, alérgenos (ácaros, polen, pelo de animales), tejidos sintéticos o irritantes (lana, jabones agresivos), estrés emocional y sudoración excesiva.',
          ],
          recomendacionDermatologo:
              'Consulta a un dermatólogo si la picazón interrumpe tu sueño, si hay signos de infección (costras amarillas, pus, fiebre) o si el eczema afecta gran parte del cuerpo. El tratamiento temprano previene complicaciones.',
          consejosCuidado: [
            'Hidrata tu piel al menos dos veces al día con cremas emolientes sin fragancia.',
            'Usa jabones suaves y agua tibia. Evita baños muy calientes y largos.',
            'Identifica y evita tus desencadenantes personales. Usa ropa de algodón y evita la lana.',
          ],
        );
      case CondicionPiel.rosacea:
        return InformacionCondicion(
          descripcion:
              'La rosácea es una afección crónica que causa enrojecimiento facial, vasos sanguíneos visibles y, en algunos casos, pápulas y pústulas similares al acné. Afecta principalmente la parte central del rostro: mejillas, nariz, frente y barbilla.',
          causas: [
            'La rosácea se produce por una combinación de factores vasculares e inflamatorios. Los vasos sanguíneos faciales se dilatan de forma anormal y persistente, lo que causa el enrojecimiento característico. Se cree que hay una predisposición genética en personas de piel clara y ascendencia celta o del norte de Europa.',
            'El ácaro Demodex folliculorum, que vive naturalmente en los folículos pilosos, se encuentra en mayor cantidad en personas con rosácea. La reacción del sistema inmunológico a estos ácaros y a la bacteria Bacillus oleronius que portan desencadena la inflamación.',
            'Los desencadenantes más comunes incluyen: exposición solar, temperaturas extremas (calor o frío), alimentos picantes, alcohol (especialmente vino tinto), bebidas calientes, cafeína, estrés emocional y ciertos cosméticos o productos para la piel.',
          ],
          recomendacionDermatologo:
              'La rosácea no tiene cura pero requiere tratamiento dermatológico para controlarla. Acude si notas enrojecimiento persistente, brotes frecuentes o si los vasos sanguíneos se vuelven cada vez más visibles. El tratamiento incluye cremas, láser y antibióticos.',
          consejosCuidado: [
            'Identifica y evita tus desencadenantes personales llevando un diario de brotes.',
            'Usa protector solar mineral (óxido de zinc o dióxido de titanio) de amplio espectro a diario.',
            'Limpia tu rostro con productos suaves sin alcohol ni fragancia. Evita exfoliantes agresivos.',
          ],
        );
      case CondicionPiel.melasma:
        return InformacionCondicion(
          descripcion:
              'El melasma es una condición que causa manchas oscuras o hiperpigmentación en la piel, generalmente en el rostro. Aparece como parches simétricos de color marrón o grisáceo en mejillas, frente, nariz y labio superior.',
          causas: [
            'El melasma se produce por una sobreproducción de melanina en los melanocitos, las células que dan color a la piel. La exposición a los rayos UV estimula estas células, pero en el melasma la respuesta es exagerada y descontrolada, creando depósitos irregulares de pigmento.',
            'Los cambios hormonales son un desencadenante principal: el embarazo (melasma gravídico o "paño del embarazo"), los anticonceptivos orales, la terapia de reemplazo hormonal y los trastornos tiroideos pueden activar o empeorar el melasma.',
            'La predisposición genética juega un rol importante: es más común en personas de fototipos III-V (piel morena o latina) y con antecedentes familiares de melasma. La combinación de radiación UV, calor y luz visible también contribuye significativamente.',
          ],
          recomendacionDermatologo:
              'El melasma puede ser resistente al tratamiento. Consulta a un dermatólogo si las manchas se oscurecen, se extienden o no mejoran con protección solar. Existen tratamientos con hidroquinona, ácido kójico, peelings y láser.',
          consejosCuidado: [
            'La protección solar es el pilar fundamental: usa FPS 50+ de amplio espectro a diario, incluso en días nublados.',
            'Evita la exposición solar directa y usa sombrero de ala ancha y gafas de sol cuando estés al aire libre.',
            'Usa productos despigmentantes suaves como vitamina C o niacinamida, siempre bajo supervisión profesional.',
          ],
        );
      case CondicionPiel.psoriasis:
        return InformacionCondicion(
          descripcion:
              'La psoriasis es una enfermedad autoinmune crónica que acelera el ciclo de vida de las células de la piel, causando acumulación de células en la superficie. Esto produce placas gruesas, rojizas y escamosas que pueden ser dolorosas o causar picazón.',
          causas: [
            'La psoriasis es causada por un trastorno del sistema inmunológico: los linfocitos T atacan por error a las células sanas de la piel, desencadenando una respuesta inflamatoria que acelera la producción de nuevas células cutáneas. El ciclo normal de 28-30 días se reduce a solo 3-5 días.',
            'La predisposición genética es muy fuerte: si uno de tus padres tiene psoriasis, tienes un 10-15% de probabilidad de desarrollarla; si ambos padres la tienen, el riesgo aumenta al 50%. Se han identificado múltiples genes involucrados (PSORS1-9).',
            'Los factores desencadenantes incluyen: infecciones (especialmente estreptocócicas), lesiones en la piel (cortes, quemaduras, rasguños), estrés emocional intenso, clima frío y seco, ciertos medicamentos (betabloqueantes, litio) y el consumo excesivo de alcohol.',
          ],
          recomendacionDermatologo:
              'La psoriasis requiere atención dermatológica especializada. Acude si las placas cubren áreas extensas, si hay dolor en las articulaciones (posible artritis psoriásica) o si afecta tu calidad de vida. Existen tratamientos tópicos, sistémicos y biológicos.',
          consejosCuidado: [
            'Hidrata tu piel a diario con cremas espesas o ungüentos para reducir la descamación.',
            'Evita rascar o arrancar las escamas. Los baños con avena coloidal pueden aliviar la picazón.',
            'Identifica tus desencadenantes y gestiona el estrés con técnicas de relajación o meditación.',
          ],
        );
      case CondicionPiel.dermatitis:
        return InformacionCondicion(
          descripcion:
              'La dermatitis es un término general que describe la inflamación de la piel. Se manifiesta con enrojecimiento, picazón, hinchazón y, en algunos casos, ampollas o descamación. Puede ser causada por contacto con irritantes, alérgenos o por predisposición genética.',
          causas: [
            'La dermatitis de contacto (la más común) se produce cuando la piel entra en contacto directo con una sustancia irritante o alérgena. Los irritantes comunes incluyen jabones fuertes, detergentes, ácidos, disolventes y plantas como la hiedra venenosa.',
            'La dermatitis alérgica ocurre cuando el sistema inmunológico identifica erróneamente una sustancia inofensiva como una amenaza, desencadenando una reacción inflamatoria. Alérgenos comunes: níquel (bisutería), fragancias, conservantes en cosméticos, látex y ciertos medicamentos tópicos.',
            'La dermatitis seborreica está relacionada con una proliferación excesiva del hongo Malassezia que vive naturalmente en la piel, combinada con una producción elevada de sebo. Afecta áreas ricas en glándulas sebáceas: cuero cabelludo, cejas, pliegues nasales y orejas.',
          ],
          recomendacionDermatologo:
              'Consulta a un dermatólogo si la dermatitis es extensa, muy dolorosa, o si hay signos de infección (pus, fiebre, costras amarillas). Un especialista puede realizar pruebas de parche para identificar alérgenos específicos.',
          consejosCuidado: [
            'Identifica y evita el irritante o alérgeno causante. Lleva un registro de productos y sustancias que empeoran tu piel.',
            'Usa jabones suaves, agua tibia y aplica crema hidratante inmediatamente después del baño.',
            'Usa guantes de protección al manipular productos químicos y elige cosméticos hipoalergénicos sin fragancia.',
          ],
        );
      case CondicionPiel.normal:
        return InformacionCondicion(
          descripcion:
              'Tu piel se encuentra en buen estado, sin condiciones visibles detectadas. La piel normal tiene un equilibrio adecuado de hidratación y producción de sebo, sin irritaciones ni lesiones aparentes.',
          causas: [
            'La piel normal se mantiene saludable gracias a una barrera cutánea funcional que retiene la hidratación adecuada y protege contra agresores externos. Las glándulas sebáceas producen la cantidad justa de sebo para mantener la piel protegida sin obstruir los poros.',
            'Factores genéticos determinan en gran medida el tipo de piel, pero los hábitos de cuidado (limpieza suave, hidratación, protección solar) y un estilo de vida saludable contribuyen a mantener la piel en equilibrio.',
            'Una dieta equilibrada rica en antioxidantes, vitaminas y ácidos grasos esenciales, junto con una hidratación adecuada y un sueño reparador, favorecen la salud y apariencia de la piel.',
          ],
          recomendacionDermatologo:
              'Si no tienes molestias ni cambios en tu piel, basta con mantener una rutina básica: limpieza suave, hidratación y protector solar a diario. Realiza autoexámenes periódicos y consulta si notas cambios repentinos.',
          consejosCuidado: [
            'Mantén una rutina constante: limpieza suave mañana y noche, hidratación y protector solar FPS 30+.',
            'Bebe suficiente agua, lleva una alimentación equilibrada y duerme al menos 7-8 horas diarias.',
            'No descuides la protección solar incluso en días nublados o en interiores cerca de ventanas.',
          ],
        );
      case CondicionPiel.otro:
        return InformacionCondicion(
          descripcion:
              'Se ha detectado una condición cutánea que requiere atención. Las condiciones de la piel pueden variar ampliamente en sus causas, síntomas y tratamientos.',
          causas: [
            'Las condiciones cutáneas pueden originarse por múltiples factores: predisposición genética, exposición ambiental, reacciones alérgicas, cambios hormonales, infecciones (bacterianas, fúngicas o virales) o enfermedades autoinmunes.',
            'El estilo de vida influye significativamente: el estrés crónico, la alimentación deficiente, la falta de sueño y el tabaquismo pueden debilitar la barrera cutánea y desencadenar o empeorar condiciones de la piel.',
            'Factores externos como el clima extremo, la contaminación ambiental, la exposición excesiva al sol sin protección y el uso de productos inadecuados para tu tipo de piel pueden contribuir al desarrollo de afecciones cutáneas.',
          ],
          recomendacionDermatologo:
              'Se recomienda consultar a un dermatólogo para obtener un diagnóstico preciso. No automediques ni uses tratamientos sin supervisión profesional, especialmente si hay dolor, picazón intensa o signos de infección.',
          consejosCuidado: [
            'Evita rascar o manipular las lesiones para prevenir infecciones secundarias.',
            'Mantén la piel limpia e hidratada con productos suaves sin fragancia.',
            'Protege tu piel del sol y evita el contacto con posibles irritantes hasta obtener un diagnóstico.',
          ],
        );
    }
  }

  CondicionPiel _mapearCondicion(String tipoPiel) {
    switch (tipoPiel.toLowerCase()) {
      case 'grasa':
        return CondicionPiel.acne;
      case 'seca':
        return CondicionPiel.eczema;
      case 'mixta':
        return CondicionPiel.dermatitis;
      default:
        return CondicionPiel.normal;
    }
  }

  void cargarResultado({
    required CondicionPiel cond,
    required double conf,
    String? desc,
    String? imgPath,
    List<Producto>? productos,
  }) {
    condicion.value = cond;
    confianza.value = conf;
    descripcion.value = desc ?? '';
    imagenPath.value = imgPath ?? '';
    productosRecomendados.value = productos ?? [];
  }

  Future<void> guardarEnHistorial() async {
    guardando.value = true;

    String? contextoIAJson;
    final info = informacionCondicion.value;
    if (info != null) {
      contextoIAJson = jsonEncode({
        'descripcion': info.descripcion,
        'causas': info.causas,
        'recomendacionDermatologo': info.recomendacionDermatologo,
        'consejosCuidado': info.consejosCuidado,
      });
    }

    final diagnostico = Diagnostico(
      id: 0,
      imagenPath: imagenPath.value,
      condicion: condicion.value,
      confianza: confianza.value,
      fecha: DateTime.now(),
      descripcion: descripcion.value.isNotEmpty ? descripcion.value : null,
      contextoIA: contextoIAJson,
      productosRecomendados: List.from(productosRecomendados),
    );

    final resultado = await _casoUso.guardarDiagnostico(diagnostico);
    switch (resultado) {
      case Exito<int>():
        Get.find<HistorialControlador>().cargarHistorial();
        Get.find<PerfilControlador>().recargarDatos();
        Get.snackbar(
          'Guardado',
          'Diagnóstico guardado en historial.',
          snackPosition: SnackPosition.BOTTOM,
        );
      case Fracaso<int>():
        Get.snackbar(
          'Error',
          resultado.mensaje,
          snackPosition: SnackPosition.BOTTOM,
        );
    }
    guardando.value = false;
  }
}
