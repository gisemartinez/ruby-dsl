require '../src/deberia'
require '../src/test_results'
require '../rspec/suites_de_prueba'
require '../src/mocking_and_spying'
#-------------------------------------------
# CLASE PRINCIPAL DEL FRAMEWORK DE TESTEO:
#-------------------------------------------
class TADsPec

  def initialize
    @@mocked_classes = Array.new
  end

  def self.add_mocked_class(klass)
    @@mocked_classes = Array.new unless class_variable_defined?(:@@mocked_classes)
    @@mocked_classes.push(klass)
  end

  def self.testear(suite, *tests)
    resultadoTest = ResultadoTest.new
    preparar_contexto_para_testeo(suite)

    if tests.empty?
      testear_suite_completa suite, resultadoTest
    else
      correr_coleccion_de_tests(suite, tests, resultadoTest)
    end
=begin
    puts "\n" + "<< Reporte de TADsPEC >>".colorize(:blue)
    puts "\n"
    resultadoTest.informar_ejecucion
=end
    restaurar_contexto_original(suite)
    resultadoTest
  end

  def self.testear_suite_completa(suite, resultadoTest)
    tests = obtener_tests_de suite
    correr_coleccion_de_tests(suite, tests, resultadoTest)
  end

  def self.preparar_contexto_para_testeo(suite)
    agregar_metodos_de_testing(suite, AssertionConfiguration)
    agregar_metodos_de_testing(suite, Spying)
    agregar_metodos_de_testing(Object, Deberia)
  end

  def self.restaurar_contexto_original(suite)
    remover_metodos_de_testing(suite, AssertionConfiguration)
    remover_metodos_de_testing(suite, Spying)
    remover_metodos_de_testing(Object, Deberia)
    self.desmockear_clases if class_variable_defined?(:@@mocked_classes)
  end

  def self.agregar_metodos_de_testing(klass, modulo)
    modulo.instance_methods(true).each do |symbol|
      method = modulo.instance_method(symbol)
      klass.send :define_method, symbol, method
    end
  end

  def self.remover_metodos_de_testing(klass, modulo)
    modulo.instance_methods(true).each do |symbol|
      klass.send :remove_method, symbol
    end
  end

  def self.desmockear_clases
    @@mocked_classes.each do |klass|
      klass.desmockear
      klass.desmockear unless klass.mocked_methods.empty?
      @@mocked_classes.delete(klass)
    end
  end

  def self.obtener_tests_de(suite)
    metodos = suite.instance_methods(false)
    tests = metodos.select { | metodo | es_un_test?(metodo) }
    #puts "No se ha encontrado ningún test en la clase '#{suite}'.".colorize(:red) if tests.empty?
    tests
  end

  def self.es_un_test?(metodo)
    metodo.to_s.start_with?('testear_que')
  end

  def self.correr_coleccion_de_tests(suite, tests, resultadoTest)
    # TRY-CATCH de los posibles eventos: PASÓ, FALLÓ o EXPLOTÓ:
    tests.each do |test|
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

  def self.correr_test_de_una_suite(suite, metodo)
    if (es_un_test?(metodo))
      suite.new.send metodo
    end
  end

end

class Module
  attr_accessor :mocked_methods

  def mockear(symbol, &block)
    method = self.instance_method(symbol)
    (self.mocked_methods = Array.new) if self.mocked_methods.nil?
    self.mocked_methods.push(MockedMethod.new symbol, method)
    self.send :define_method, symbol, &block
    TADsPec.add_mocked_class(self)
  end

  def desmockear
    this = self
    self.mocked_methods.each do |method|
      this.send :define_method, method.name, method.body
      this.mocked_methods.delete(method)
    end
  end
end
