require '../src/deberia_module'
require '../src/resultados_classes'
require '../src/suite_de_prueba'
#-------------------------------------------
# CLASE PRINCIPAL DEL FRAMEWORK DE TESTEO:
#-------------------------------------------
class TADsPec

  def testear(*args)
    resultadoTest = ResultadoTest.new
    # Verifica la cantidad de argumentos para testear:
    if args.empty?
      # testea todos los tests del contexto TODO
    elsif args.length == 1
      # testea todos los tests de una suite dada
      suite = args.first
      self.testear_suite_completa suite, resultadoTest
    else
      # testea los tests indicados de una suite dada
    suite = args.shift
    tests = args
    correr_coleccion_de_tests(suite, tests, resultadoTest)
    end
=begin
    puts "\n" + "<< Reporte de TADsPEC >>".colorize(:blue)
    puts "\n"
    resultadoTest.informar_ejecucion
=end
    resultadoTest
  end

  def testear_suite_completa(suite, resultadoTest)
    # Obtiene todos los métodos de la suite que sean tests:
    tests = self.obtener_tests_de suite
    correr_coleccion_de_tests(suite, tests, resultadoTest)
  end

  def preparar_para_testeo(suite)
    # Le hace entender a cualquier objeto del contexto el mensaje 'deberia':
   Object.class_eval do
     include DeberiaModule
    end
  end

  def obtener_tests_de(suite)
    metodos = suite.instance_methods(false)
    tests = metodos.select { | metodo | es_un_test(metodo) }
    puts "No se ha encontrado ningún test en la clase '#{suite}'.".colorize(:red) if tests.empty?
    tests
  end

  def es_un_test(metodo)
    metodo.to_s.start_with?('testear_que')
  end

  def correr_coleccion_de_tests(suite, tests, resultadoTest)
    preparar_para_testeo(suite)
    # TRY-CATCH de los posibles eventos: PASÓ, FALLÓ o EXPLOTÓ:
    tests.each do | test |
      begin
        self.correr_test_de_una_suite suite, test
        # ASERCIÓN OK:
        resultadoTest.test_paso suite, test
      rescue AssertionError => mensaje_excepcion
        # ERROR DE ASERCIÓN:
        resultadoTest.test_fallo suite, test, mensaje_excepcion
      rescue StandardError => mensaje_excepcion
        # ERROR ANORMAL:
        resultadoTest.test_exploto suite, test, mensaje_excepcion
        end
      end
  end

  def correr_test_de_una_suite(suite, metodo)
    if (es_un_test(metodo))
      suite.new.send metodo
    end
  end

end