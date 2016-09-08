require '../src/aserciones'
require '../src/resultados'

# Clase principal para el frameework de testeo:
class TADsPec

  def testear(*suites)
    resultado = ResultadoTest.new
    suites.each do | suite |
      self.correr_tests_de suite, resultado
    end
    resultado
  end

  def correr_tests_de(suite, resultado)
    preparar_para_testeo(suite)
    tests = self.obtener_tests_de suite
    # TRY-CATCH de los posibles eventos: PASÓ, FALLÓ o EXPLOTÓ:
    tests.each do | test |
      begin
        self.correr_test_unitario suite, test
            # ASERCIÓN OK:
        resultado.test_paso suite, test
      rescue AssertionError => mensaje_excepcion
           # ERROR DE ASERCIÓN:
        resultado.test_fallo suite, test, mensaje_excepcion
          # ERROR ANORMAL:
      rescue StandardError => exception
        resultado.test_exploto suite, test, mensaje_excepcion
      end
    end
  end

  def preparar_para_testeo(suite)
    # Le hace entender a la suite el mensaje 'deberia':
   suite.class_eval do
      include Aserciones
    end
  end

  def obtener_tests_de(suite)
    suite.instance_methods.
        select { | metodo | es_un_test(metodo) }
  end

  def es_un_test(metodo)
    metodo.to_s.start_with?('testear_que')
  end

  def correr_test_unitario(suite, metodo)
    if (es_un_test(metodo))
      instancia_de_la_suite = suite.new
      instancia_de_la_suite.send metodo
    end
  end

end