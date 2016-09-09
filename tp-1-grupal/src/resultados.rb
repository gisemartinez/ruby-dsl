class ResultadoTest
  attr_accessor :resultados

  def initialize
    self.resultados = []
  end

  def test_paso(suite, test)
    self.resultados << TestPaso.new(suite, test)
  end

  def test_fallo(suite, test, excepcion)
    self.resultados << TestFallo.new(suite, test, excepcion)
  end

  def test_exploto(suite, test, excepcion)
    self.resultados << TestExploto.new(suite, test, excepcion)
  end

  def fallo?(suite, test)
    self.resultados.any? { |resultado| resultado.fallo? suite, test }
  end

  def paso?(suite, test)
    self.resultados.any? { |resultado| resultado.paso? suite, test }
  end

  def exploto?(suite, test)
    self.resultados.any? { |resultado| resultado.exploto? suite, test }
  end

  def resultados_totales
    self.resultados.length
  end

  def resultados_que_fallaron
    self.resultados.select { |resultado| resultado.is_a?(TestFallo) }
  end

  def resultados_que_pasaron
    self.resultados.select { |resultado| resultado.is_a?(TestPaso) }
  end

  def informar_errores
    self.resultados.each do |resultado|
      resultado.informar_error
    end
  end

  # --- Informa por consola los resultados de la ejecución de los tests:
  def informar_ejecucion
    self.informar_errores
    puts "Se corrieron #{self.resultados_totales} tests. #{self.resultados_que_pasaron.length} tests pasaron, #{self.resultados_que_fallaron.length} tests fallaron."
  end

end

class TestEstadoFinal
  attr_accessor :suite, :test

  # --- REDEFINICIÓN DEL 'eql?'
  def eql?(receptor)
    self.suite == receptor.suite && self.test == receptor.test
  end

  # --- ESTADOS DEFAULT:
  def paso?(suite, test)
    false
  end

  def fallo?(suite, test)
    false
  end

  def exploto?(suite, test)
    false
  end

  def informar_error
  end

end

# TIPOS DE RESULTADOS PARA LOS TESTS:
class TestPaso < TestEstadoFinal
  def initialize(suite, test)
    self.test= test
    self.suite= suite
  end

  def paso?(suite, test)
    self.eql? TestPaso .new suite, test
  end

end

class TestFallo < TestEstadoFinal
  attr_accessor :excepcion

  def initialize(suite, test, excepcion)
    self.test= test
    self.suite= suite
    self.excepcion= excepcion
  end

  def fallo?(a_class, test)
    self.eql? TestFallo.new suite, test, nil
  end

  def informar_error
    puts "El test #{self.test} ha explotado con el error: #{self.excepcion.message}"
    puts self.excepcion.backtrace.join("\n")
    puts "\n"
  end

end

class TestExploto < TestFallo

  def fallo?(suite, test)
    false
  end

  def exploto?(suite, test)
    self.eql? TestExploto.new suite, test, nil
  end

end