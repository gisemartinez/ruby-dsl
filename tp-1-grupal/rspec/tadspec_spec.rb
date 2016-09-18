require 'rspec'
require_relative '../src/tadspec_app'

describe 'tadspec framework tests' do

  it 'Ejecutar un test especifico de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests, :testear_que_7_es_7)
    expect(resultado.paso?).to eq(true)
  end

  it 'Ejecutar test que arroja excepcion de asercion' do
    tester = TADsPec.new
    expect{tester.testear MiSuiteDeTests, :testear_que_la_edad_de_juan_es_25}
        .to raise_error AssertionError
  end

  it 'Ejecutar todos los tests de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests)

    expect(resultado.length).to eq(13)
  end

  it 'Testear suite con solo tests que pasan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQuePasan)

    expect(resultado.length).to eq(9)
    expect(resultado.all? { |test_result| test_result.is_a?(TestPaso) }).to eq(true)
  end

  it 'Testear suite con solo tests que fallan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQueFallan)

    expect(resultado.length).to eq(4)
    expect(resultado.all? { |test_result| test_result.is_a?(TestFallo) }).to eq(true)
  end

  it 'Testear que se ignora cualquier método que no es un test' do
    tester = TADsPec.new
    tests = tester.obtener_tests_de(UnaClaseSinTests)
    resultado = tester.testear(UnaClaseSinTests)

    expect(tests.empty?).to eq(true)
    expect(resultado.empty?).to eq(true)
  end

=begin
  it 'Ejecutar varios tests especificos de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests,
                               testear_que_true_es_false,
                               testear_que_la_edad_de_juan_es_25,
                               testear_que_juan_tiene_mas_de_20_anios)
    # completar expect TODO
  end

  it 'Ejecutar test que explota y arroja excepcion anormal' do
    tester = TADsPec.new
    expect{tester.testear MiSuiteDeTests, :testear_que_explota_la_division_por_cero}
        .to raise_error ZeroDivisionError
  end

  it 'Testear suite con solo tests que explotan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQueFallan)
    # completar expect TODO
  end
=end
end