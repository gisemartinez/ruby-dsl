require 'rspec'
require_relative '../src/tadspec_app'

describe 'tadspec framework tests' do

  it 'Ejecutar un test especifico que pasa de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests, :testear_que_7_es_7)

    expect(resultado.paso_test?(MiSuiteDeTests, :testear_que_7_es_7)).to eq(true)
  end

  it 'Ejecutar un test especifico que falla de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests, :testear_que_hola_es_chau)

    expect(resultado.fallo_test?(MiSuiteDeTests, :testear_que_hola_es_chau)).to eq(true)
  end

  it 'Ejecutar test que falla y arroja error de asercion' do
    tester = TADsPec.new

    expect{tester.correr_test_de_una_suite MiSuiteDeTests, :testear_que_juan_es_menor_de_edad}
        .to raise_error AssertionError
  end

  it 'Ejecutar todos los tests de una suite' do
    tester = TADsPec.new
    resultados = tester.testear(MiSuiteDeTests).resultados
    test_pasaron = resultados.select { |test| test.paso?(MiSuiteDeTests, test) }
    test_fallaron = resultados.select { |test| test.fallo?(MiSuiteDeTests, test) }
    test_explotaron = resultados.select { |test| test.exploto?(MiSuiteDeTests, test) }

    expect(resultados.length).to eq(27)
    expect(test_pasaron.length).to eq(13)
    expect(test_fallaron).to eq(14)
    expect(test_explotaron).to eq(0)
  end

  it 'Testear que se ignora cualquier método que no es un test' do
    tester = TADsPec.new
    tests = tester.obtener_tests_de(UnaClaseSinTests)
    resultados = tester.testear(UnaClaseSinTests).resultados

    expect(tests.empty?).to eq(true)
    expect(resultados.empty?).to eq(true)
  end
=begin
  it 'Testear suite con solo tests que pasan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQuePasan)

    expect(resultado.length).to eq()
    expect(resultado.all? { |test_result| test_result.is_a?(TestPaso) }).to eq(true)
  end

  it 'Testear suite con solo tests que fallan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQueFallan)

    expect(resultado.length).to eq()
    expect(resultado.all? { |test_result| test_result.is_a?(TestFallo) }).to eq(true)
  end

  it 'Testear suite con solo tests que explotan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQueExplotan)

    expect(resultado.length).to eq()
    expect(resultado.all? { |test_result| test_result.is_a?(TestExploto) }).to eq(true)
  end

  it 'Ejecutar varios tests especificos de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests,
                               testear_que_true_es_false,)
    # TODO
  end

  it 'Ejecutar test que explota y arroja excepcion anormal' do
    tester = TADsPec.new
    expect{tester.testear MiSuiteDeTests, :testear_que_explota_la_division_por_cero}
        .to raise_error ZeroDivisionError
  end

=end
end