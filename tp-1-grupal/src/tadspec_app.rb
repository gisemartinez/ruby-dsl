require '../src/deberia_module'
require '../src/resultados_classes'
require '../src/suite_ok'

# Clase principal para el frameework de testeo:
class TADsPec

  def testear(*args)
    resultadoTesting = ResultadoTest.new
    # Verifica la cantidad de argumentos para testear:
    if args.length == 0
      # testea todos los tests del contexto << TODO >>
    elsif args.length == 1
      # testea todos los tests de una suite dada
      suite = args.first
      self.testear_suite_completa suite, resultadoTesting
    else
      # testea los tests indicados de una suite dada
    suite = args.shift
    tests = args
    correr_coleccion_de_tests(suite, tests, resultadoTesting)
    end
    resultadoTesting.informar_ejecucion
    resultadoTesting # --> para testear con 'rspec' y validar contra el array de resultados
    # nil --> para correrlo por consola y que no imprima el array de resultados
  end

  def testear_suite_completa(suite, resultadoTesting)
    # Obtiene todos los métodos de la suite que sean tests:
    tests = self.obtener_tests_de suite
    correr_coleccion_de_tests(suite, tests, resultadoTesting)
  end

  def preparar_para_testeo(suite)
    # Le hace entender a cualquier objeto del contexto el mensaje 'deberia':
   Object.class_eval do
     include DeberiaModule
    end
  end

  def obtener_tests_de(suite)
    metodos = suite.instance_methods(false)
    metodos.select { | metodo | es_un_test(metodo) }
  end

  def es_un_test(metodo)
    metodo.to_s.start_with?('testear_que')
  end

    def correr_coleccion_de_tests(suite, tests, resultadoTesting)
      preparar_para_testeo(suite)
      # TRY-CATCH de los posibles eventos: PASÓ, FALLÓ o EXPLOTÓ:
      tests.each do | test |
        begin
          self.correr_test_de_una_suite suite, test
          # ASERCIÓN OK:
          resultadoTesting.test_paso suite, test
        rescue AssertionError => mensaje_excepcion
          # ERROR DE ASERCIÓN:
          resultadoTesting.test_fallo suite, test, mensaje_excepcion
            # ERROR ANORMAL:
        rescue StandardError => mensaje_excepcion
          resultadoTesting.test_exploto suite, test, mensaje_excepcion
        end
        end
    end

  def correr_test_de_una_suite(suite, metodo)
    if (es_un_test(metodo))
      suite.new.send metodo
    end
  end

end