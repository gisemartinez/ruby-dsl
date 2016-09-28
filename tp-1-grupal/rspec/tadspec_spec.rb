# encoding: utf-8
require 'rspec'
require_relative '../src/tadspec_app'

describe 'TADsPEC' do

  it 'Verificar que los objetos no entienden las aserciones fuera del testing' do
    # Antes del testing

    expect{7.deberia ser igual_a 7}.to raise_error NoMethodError

    expect{Persona.new(22).deberia tener_edad 22}.to raise_error NoMethodError

    expect{7.deberia ser uno_de_los_varargs [7,8]}.to raise_error NoMethodError


    # Testing
    TADsPec.testear(MiSuiteDeTests)

    # Después del testing
    expect{7.deberia ser igual_a 7}.to raise_error NoMethodError

    expect{7.deberia ser uno_de_los_varargs [7,8]}.to raise_error NoMethodError

    expect{Persona.new(22).deberia tener_edad 22}.to raise_error NoMethodError
  end

  it 'Ejecutar test especifico que pasa de una suite' do
    resultado = TADsPec.testear(MiSuiteDeTests, :testear_que_7_es_7)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_7_es_7)).to eq(true)
  end

  it 'Ejecutar test especifico que falla de una suite' do
    resultado = TADsPec.testear(MiSuiteDeTests, :testear_que_hola_es_chau)
    expect(resultado.fallo_test?(MiSuiteDeTests, :testear_que_hola_es_chau)).to eq(true)
  end

  it 'Verificar que un test que falla arroja error de asercion' do
    TADsPec.preparar_contexto_para_testeo(MiSuiteDeTests)

    expect{TADsPec.correr_test_de_una_suite MiSuiteDeTests, :testear_que_juan_es_menor_de_edad}
        .to raise_error AssertionError

    #TADsPec.restaurar_contexto_original(MiSuiteDeTests)
  end

  it 'Ejecutar todos los tests de una suite' do
    tests = TADsPec.obtener_tests_de(MiSuiteDeTests)
    resultado = TADsPec.testear(MiSuiteDeTests)

    # TODO: Cuidado, verificar que la cantidad que pasó, que falló o explotó sea X no garantiza que los métodos
    #   que fallaron fueran los que esperábamos.
    # Tienen dos alternativas para testear así:
    # - preguntan test por test que finalizó como esperaban
    # - piden una colección por cada tipo de resultado y la comparan con una que esperan ustedes
    # - definen "metadata" en cada test para luego verificar que terminó como esperaban
    # - corren test por test esperando el resultado que esperan (aunque eso no testea que entre sí no se interfieren)
    #
    # Puede resultar más cómodo tener suites de test de prueba más chiquitas o incluso definidas dentro del mismo
    # "it" de spec.
    # Por ejemplo:
    #
    # suite = Class.new {
    #  def testear_que_7_es_7
    #    7.deberia ser 7
    #  end
    # }
    #
    # TADsPec.testear(suite)
    # ...
    expect(tests.length).to eq(33)
    expect(resultado.resultados.length).to eq(33)
    expect(resultado.resultados_que_pasaron.length).to eq(18)
    expect(resultado.resultados_que_fallaron.length).to eq(13)
    expect(resultado.resultados_que_explotaron.length).to eq(2)
  end

  # it 'Verificar que se ignora cualquier método que no es un test' do
  #   tests = TADsPec.obtener_tests_de(UnaClaseSinTests)
  #   resultados = TADsPec.testear(UnaClaseSinTests).resultados
  #
  #   expect(tests.empty? && resultados.empty?).to eq(true)
  # end

  it 'Ejecutar varios tests especificos de una suite' do
    resultado = TADsPec.testear(MiSuiteDeTests,
                                :testear_que_true_es_false,
                                :testear_que_juan_entiende_metodo_saludar,
                                :testear_que_juan_es_rico,
                                :testear_que_juan_tiene_edad_mayor_a_18 )

    expect(resultado.resultados.length).to eq(4)
    expect(resultado.fallo_test?(MiSuiteDeTests, :testear_que_true_es_false)).to eq(true)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_juan_entiende_metodo_saludar)).to eq(true)
    expect(resultado.fallo_test?(MiSuiteDeTests, :testear_que_juan_es_rico)).to eq(true)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_juan_tiene_edad_mayor_a_18)).to eq(true)
  end

  it 'Ejecutar tests que explota con la division por cero' do
    resultado = TADsPec.testear(MiSuiteDeTests, :testear_que_explota_la_division_por_cero)

    expect(resultado.resultados.length).to eq(1)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_explota_la_division_por_cero)).to eq(true)
  end

  it 'Ejecutar tests del tipo explotar con y veificar que no explotan anormalmente' do
    resultado = TADsPec.testear(MiSuiteDeTests,
                               :testear_que_explota_la_division_por_cero,
                               :testear_que_juan_explota_con_el_mensaje_nombre_generalizado,
                               :testear_que_juan_explota_con_el_mensaje_nombre_generalizado,
                               :testear_que_la_division_por_cero_explota_con_no_method )

    expect(resultado.resultados.length).to eq(4)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_explota_la_division_por_cero)).to eq(true)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_juan_explota_con_el_mensaje_nombre_generalizado)).to eq(true)
    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_juan_explota_con_el_mensaje_nombre_generalizado)).to eq(true)
    expect(resultado.fallo_test?(MiSuiteDeTests, :testear_que_la_division_por_cero_explota_con_no_method)).to eq(true)
  end

  it 'Ejcutar tests que explotan y arrojan excepcion anormal' do
    resultado = TADsPec.testear(SuiteQueExplota, :testear_que_maria_es_joven, :testear_que_un_string_es_un_array)
    # Explota porque María no entiende el mensaje 'joven?'
    expect(resultado.exploto_test?(SuiteQueExplota, :testear_que_maria_es_joven)).to eq(true)
    # Explota porque un String no entiende el mensaje 'array?'
    expect(resultado.exploto_test?(SuiteQueExplota, :testear_que_un_string_es_un_array)).to eq(true)

    excepcion_1 = resultado.resultados[0].excepcion.class
    excepcion_2 = resultado.resultados[1].excepcion.class
    expect(excepcion_1 && excepcion_2).to eq(NoMethodError)
  end

end