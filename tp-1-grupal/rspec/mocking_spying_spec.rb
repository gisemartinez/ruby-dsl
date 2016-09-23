require 'rspec'
require_relative '../src/tadspec_app'

describe 'TADsPEC_Mocking' do

  it 'Testear que al mockear se reemplaza el comportamiento de un metodo' do
    expect(PersonaHome.new.devolver_un_string).to eq('Original')
    PersonaHome.mockear(:devolver_un_string) {'Mockeado'}
    expect(PersonaHome.new.devolver_un_string).to eq('Mockeado')

    PersonaHome.desmockear
  end

  it 'Verificar que el metodo mockeado de una clase puede ser desmockeado' do
    PersonaHome.mockear(:devolver_un_string) {'Fui mockeado!'}
    expect(PersonaHome.new.devolver_un_string).to eq('Fui mockeado!')

    PersonaHome.desmockear
    expect(PersonaHome.new.devolver_un_string).to eq('Original')
  end

  it 'Verificar que el metodo mockeado vuelve a ser el original luego del testing' do
    expect(PersonaHome.new.devolver_un_string).to eq('Original')
    resultado = TADsPec.testear(PersonaHomeTests, :testear_que_devolver_un_string_retorna_fui_mockeado)

    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_devolver_un_string_retorna_fui_mockeado)).to eq(true)
    expect(PersonaHome.new.devolver_un_string).to eq('Original')
  end

  it 'Testear el mockeo de un metodo dentro de una suite de tests' do
    resultado = TADsPec.testear(PersonaHomeTests, :testear_que_personas_viejas_trae_solo_a_los_viejos)

    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_personas_viejas_trae_solo_a_los_viejos)).to eq(true)
    expect(PersonaHome.new.todas_las_personas).to eq(['Servicio externo'])
  end

end