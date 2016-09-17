#--------------------------------------
# FIXTURE DE DATOS PARA HACER PRUEBAS:
#--------------------------------------
class Persona
  attr_accessor :edad

  def initialize(edad=22)
    self.edad= edad
  end

  def viejo?
    self.edad > 29
  end

end

class MiSuiteDeTests
  # Total: 13
  # Pasan: 9
  # Fallan: 4
  # Explotan: 0

  # pasa
  def testear_que_7_es_7
    7.deberia ser 7
  end

  # pasa
  def testear_que_7_es_mayor_a_3
    7.deberia(ser(mayor_a(3)))
  end

  # pasa
  def testear_que_juan_tiene_mas_de_20_anios
    juan = Persona.new(22)
    juan.edad.deberia ser mayor_a 20
  end

  # pasa
  def testear_que_juan_tiene_menos_de_25_anios
    juan = Persona.new(22)
    juan.edad.deberia ser menor_a 25
  end

  # pasa
  def testear_que_juan_tiene_edad_en_el_rango_lista
    juan = Persona.new(22)
    juan.edad.deberia ser uno_de_estos [7, 22, "hola"]
  end

  # pasa
  def testear_que_juan_tiene_edad_en_el_rango_argumentos
    juan = Persona.new(22)
    juan.edad.deberia ser uno_de_estos 7, 22, "hola"
  end

  # pasa
  def testear_que_juan_entiende_consulta_es_viejo
    juan = Persona.new(22)
    juan.deberia entender :viejo?
  end

  # pasa
  def testear_que_las_personas_de_mas_de_29_son_viejas
    persona = Persona.new(30)
    persona.deberia ser_viejo
  end

  # pasa
  def testear_que_juan_tiene_22_anios
    juan = Persona.new(22)
    juan.deberia tener_edad 22
  end

  # falla
  def testear_que_juan_entiende_consulta_nombre
    juan = Persona.new(22)
    juan.deberia entender :nombre
  end

  # falla: no hay atributo 'nombre'
  def testear_que_juan_se_llama_juan
    juan = Persona.new(22)
    juan.deberia tener_nombre "juan"
  end

  # falla
  def testear_que_true_es_false
    true.deberia ser false
  end

  # falla
  def testear_que_la_edad_de_juan_es_25
    juan = Persona.new(22)
    juan.edad.deberia ser 25
  end

  # se ignora
  def metodo_que_no_es_un_test
    1 + 2 + 3
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

  # pasa
  def testear_que_la_edad_de_juan_es_mas_de_20_anios
    juan = Persona.new(22)
    juan.deberia tener_edad mayor_a 22
  end

  # pasa
  def testear_que_la_edad_de_juan_es_menos_de_25_anios
    juan = Persona.new(22)
    juan.deberia tener_edad menor_a 22
  end

  # pasa
  def testear_que_juan_tiene_edad_dentro_del_rango
    juan = Persona.new(22)
    juan.deberia tener_edad uno_de_estos [7, 22, "hola"]
  end
=end

class MiSuiteDeTestsQuePasan

end

class MiSuiteDeTestsQueFallan

end