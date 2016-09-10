require 'rspec'
require_relative '../rspec/suites_de_prueba'
require_relative '../src/tadspec'

describe 'tadspec framework tests' do

  before(:each) do
    @tester = TADsPec.new
  end

  it 'Ejecutar un test especifico de una suite' do
    resultado = @tester.testear(MiSuiteDeTests, :testear_que_7_es_7)
    expect(resultado.paso?).to eq(true)
  end

  it 'Ejecutar varios tests especificos de una suite' do
    resultado = @tester.testear(MiSuiteDeTests,
                                testear_que_true_es_false,
                                testear_que_la_edad_de_juan_es_25,
                                testear_que_juan_tiene_mas_de_20_anios)
    # completar expect TODO
  end

  it 'Ejecutar test que arroja excepcion de asercion' do
    expect{@tester.testear MiSuiteDeTests, :testear_que_la_edad_de_juan_es_25}
        .to raise_error AssertionError
  end

  it 'Ejecutar test que explota y arroja excepcion anormal' do
    expect{@tester.testear MiSuiteDeTests, :testear_que_explota_la_division_por_cero}
        .to raise_error ZeroDivisionError
  end

  it 'Ejecutar todos los tests de una suite' do
    resultado = @tester.testear(MiSuiteDeTests)
    # completar expect TODO
  end

  it 'Testear suite con solo tests que pasan' do
    resultado = @tester.testear(MiSuiteDeTestsQuePasan)
    # completar expect TODO
  end

  it 'Testear suite con solo tests que fallan' do
    resultado = @tester.testear(MiSuiteDeTestsQueFallan)
    # completar expect TODO
  end

  it 'Testear suite con solo tests que explotan' do
    resultado = @tester.testear(MiSuiteDeTestsQueFallan)
    # completar expect TODO
  end

end