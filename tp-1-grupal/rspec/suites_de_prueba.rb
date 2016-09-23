#--------------------------------------
# FIXTURE DE DATOS PARA HACER PRUEBAS:
#--------------------------------------
class Persona
  attr_accessor :edad, :ingreso

  def initialize(edad)
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
  # Total: 31
  # Pasan: 19
  # Fallan: 13
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
  def testear_que_juan_tiene_ingreso_dentro_de_la_lista
    juan = Persona.new(22)
    juan.deberia tener_ingreso uno_de_estos [true, 'juan', 1.5]
  end

  # pasa
  def testear_que_juan_tiene_edad_dentro_de_los_varargs
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos 7, 22, 'hola'
  end

  # falla
  def testear_que_juan_tiene_ingreso_dentro_de_los_varargs
    juan = Persona.new(22)
    juan.deberia tener_ingreso uno_de_estos true, 'juan', 1.5
  end

  # pasa
  def testear_que_explota_la_division_por_cero
    Proc.new { 7 / 0 }.deberia explotar_con ZeroDivisionError
  end

  # pasa
  def testear_que_juan_explota_con_el_mensaje_nombre
    juan = Persona.new(22)
    Proc.new { juan.nombre }.deberia explotar_con NoMethodError
  end

  # pasa
  def testear_que_juan_explota_con_el_mensaje_nombre_generalizado
    juan = Persona.new(22)
    Proc.new { juan.nombre }.deberia explotar_con StandardError
  end

  # falla
  def testear_que_la_division_por_cero_explota_con_no_method
    Proc.new { 7 / 0 }.deberia explotar_con NoMethodError
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

class PersonaHome
  def todas_las_personas
    ['Servicio externo']
  end

  def devolver_un_string
    'Original'
  end

  def personas_viejas
    self.todas_las_personas.select{|p| p.viejo?}
  end

end

class PersonaHomeTests
  def testear_que_personas_viejas_trae_solo_a_los_viejos
    nico = Persona.new(30)
    axel = Persona.new(35)
    lean = Persona.new(22)

    PersonaHome.mockear(:todas_las_personas) do
      [nico, axel, lean]
    end

    viejos = PersonaHome.new.personas_viejas

    viejos.deberia ser [nico, axel]
  end

  def testear_que_devolver_un_string_retorna_fui_mockeado

    PersonaHome.mockear(:devolver_un_string) {'Fui mockeado!'}

    mensaje = PersonaHome.new.devolver_un_string

    mensaje.deberia ser 'Fui mockeado!'
  end
end

class SuiteQueExplota
  def testear_que_maria_es_joven
    maria = Persona.new(50)

    maria.deberia ser_joven
  end
end