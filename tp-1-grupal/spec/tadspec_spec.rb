require 'rspec'
require_relative '../spec/suites_de_prueba'
require_relative '../src/tadspec'

describe 'tadspec framework tests' do

  it 'Ejecutar un test especifico de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests, :testear_que_7_es_7)
    expect(resultado.paso?).to eq(true)
  end

  it 'Ejecutar varios tests especificos de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests, :testear_que_7_es_7)
    # completar expect
  end

  it 'Ejecutar todos los tests de una suite' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTests)
    # completar expect
  end

  it 'Testear suite con todos tests que pasan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQuePasan)
    # completar expect
  end

  it 'Testear suite con todos tests que fallan' do
    tester = TADsPec.new
    resultado = tester.testear(MiSuiteDeTestsQueFallan)
    # completar expect
  end

end