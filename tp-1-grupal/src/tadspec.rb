require '../src/deberia_original'
require '../src/resultados'
require '../src/suites_de_prueba'

# Clase principal para el frameework de testeo:
class TADsPec

  def testear(*args)
    resultado = ResultadoTest.new
    # Verifica la cantidad de argumentos para testear:
    if args.length == 0
      # testea todos los tests del contexto
      # TODO
    elsif args.length == 1
      # testea todos los tests de una suite dada
      suite = args.first
      self.testear_suite_completa suite, resultado
    else
      # testea los tests indicados de una suite dada
    suite = args.first
    tests = args.shift
    correr_coleccion_de_tests(suite, tests, resultado)
    end
    resultado
  end

  def testear_suite_completa(suite, resultado)
    # Obtiene todos los métodos de la suite que sean tests:
    tests = self.obtener_tests_de suite
    correr_coleccion_de_tests(suite, tests, resultado)
  end

  def preparar_para_testeo(suite)
    # Le hace entender a la suite el mensaje 'deberia':
   suite.class_eval do
      include MetodoDeberia
    end
  end

  def obtener_tests_de(suite)
    suite.instance_methods.
        select { | metodo | es_un_test(metodo) }
  end

  def es_un_test(metodo)
    metodo.to_s.start_with?('testear_que')
  end

    def correr_coleccion_de_tests(suite, tests, resultado)
      preparar_para_testeo(suite)
      # TRY-CATCH de los posibles eventos: PASÓ, FALLÓ o EXPLOTÓ:
      tests.each do | test |
        begin
          self.correr_test_de_una_suite suite, test
          # ASERCIÓN OK:
          resultado.test_paso suite, test
        rescue AssertionError => mensaje_excepcion
          # ERROR DE ASERCIÓN:
          resultado.test_fallo suite, test, mensaje_excepcion
            # ERROR ANORMAL:
        rescue StandardError => mensaje_excepcion
          resultado.test_exploto suite, test, mensaje_excepcion
        end
        end
    end

  def correr_test_de_una_suite(suite, metodo)
    if (es_un_test(metodo))
      suite.new.send metodo
    end
  end

end