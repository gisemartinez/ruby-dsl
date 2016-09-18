#--------------------------------------
# FIXTURE DE DATOS PARA HACER PRUEBAS:
#--------------------------------------
class Persona
  attr_accessor :edad, :ingreso

  def initialize(edad=22)
    self.edad = edad
  end

  def viejo?
    self.edad > 29
  end

  def saludar
    puts 'Hola'
  end

  def rico?
    self.ingreso >= 80000
  end

end

class MiSuiteDeTests
  # Total: 27
  # Pasan: 13
  # Fallan: 14
  # Explotan: 0

  # pasa
  def testear_que_7_es_7
    7.deberia ser 7
  end

  # falla
  def testear_que_hola_es_chau
    'Hola'.deberia ser 'Chau'
  end

  # pasa
  def testear_que_la_edad_de_juan_es_22
    juan = Persona.new(22)
    juan.edad.deberia ser 22
  end

  # falla
  def testear_que_true_es_false
    true.deberia ser false
  end

  # pasa
  def testear_que_7_es_mayor_a_3
    7.deberia ser mayor_a 3
  end

  # falla
  def testear_que_hola_es_mayor_a_hola_mundo
    'Hola'.deberia ser mayor_a 'Hola Mundo'
  end

  # pasa
  def testear_que_juan_gana_menos_de_50000
    juan = Persona.new(22)
    juan.ingreso = 25000
    juan.ingreso.deberia ser menor_a 50000
  end

  # falla
  def testear_que_juan_es_menor_de_edad
    juan = Persona.new(22)
    juan.edad.deberia ser menor_a 18
  end

  # pasa
  def testear_que_la_edad_de_juan_es_una_de_la_lista
    juan = Persona.new(22)
    juan.edad.deberia ser uno_de_estos [7, 22, 'hola']
  end

  # falla
  def testear_que_z_es_una_vocal_de_la_lista
    'z'.deberia ser uno_de_estos ['a','e','i','o','u']
  end

  # pasa
  def testear_que_la_edad_de_juan_es_una_de_los_varargs
    juan = Persona.new(22)
    juan.edad.deberia ser uno_de_estos 7, 22, 'hola'
  end

  # falla
  def testear_que_8_es_un_numero_los_varargs
    8.deberia ser uno_de_estos 1, 2, 3, 4, 5
  end

  # pasa
  def testear_que_juan_es_viejo
    juan = Persona.new(60)
    juan.deberia ser_viejo
  end

  # falla
  def testear_que_juan_es_rico
    juan = Persona.new(60)
    juan.ingreso = 1500
    juan.deberia ser_rico
  end

  # falla
  def testear_que_juan_entiende_metodo_nombre
    juan = Persona.new(22)
    juan.deberia entender :nombre
  end

  # pasa
  def testear_que_juan_entiende_metodo_saludar
    juan = Persona.new(22)
    juan.deberia entender :saludar
  end

  # pasa
  def testear_que_juan_tiene_22_anios
    juan = Persona.new(22)
    juan.deberia tener_edad 22
  end

  # falla
  def testear_que_juan_tiene_ingreso_25000
    juan = Persona.new(22)
    juan.ingreso = 10000
    juan.deberia tener_ingreso 25000
  end

  # falla: no hay atributo 'nombre' TODO
  def testear_que_juan_tiene_nombre_juan
    juan = Persona.new(22)
    juan.deberia tener_nombre "juan"
  end

  # pasa
  def testear_que_juan_tiene_edad_mayor_a_18
    juan = Persona.new(22)
    juan.deberia tener_edad mayor_a 18
  end

  # falla
  def testear_que_juan_tiene_edad_mayor_a_60
    juan = Persona.new(22)
    juan.deberia tener_edad mayor_a 60
  end

  # pasa
  def testear_que_juan_tiene_edad_menor_a_30
    juan = Persona.new(22)
    juan.deberia tener_edad menor_a 30
  end

  # falla
  def testear_que_juan_tiene_edad_menor_a_15
    juan = Persona.new(22)
    juan.deberia tener_edad menor_a 15
  end

  # pasa
  def testear_que_juan_tiene_edad_dentro_de_la_lista
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos [7, 22, 'hola']
  end

  # falla
  def testear_que_juan_tiene_edad_dentro_de_la_lista
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos [true, 'juan', 1.5]
  end

  # pasa
  def testear_que_juan_tiene_edad_dentro_de_los_varargs
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos 7, 22, 'hola'
  end

  # falla
  def testear_que_juan_tiene_edad_dentro_de_los_varargs
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos true, 'juan', 1.5
  end

  # se ignora
  def metodo_que_no_es_un_test
    1 + 2 + 3
  end

  # se ignora
  def otro_metodo_que_no_es_un_test
    puts 'No soy un test.'
  end

end

=begin
     # falla
    def testear_que_explota_la_division_por_cero
      { 7 / 0 }.deberia explotar_con ZeroDivisionError
    end

    # falla
    def testear_que_juan_explota_con_nombre
      juan = Persona.new(22)
      { juan.nombre }.deberia explotar_con Error
    end
=end

class MiSuiteDeTestsQuePasan
end

class MiSuiteDeTestsQueFallan
end

class MiSuiteDeTestsQueExplotan
end

class UnaClaseSinTests
  # se ignora
  def metodo_que_no_es_un_test
    1 + 2 + 3
  end

  # se ignora
  def otro_metodo_que_no_es_un_test
    puts 'No soy un test.'
  end
end
