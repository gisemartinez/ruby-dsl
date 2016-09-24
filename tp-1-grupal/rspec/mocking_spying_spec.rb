require 'rspec'
require_relative '../src/tadspec_app'

describe 'TADsPEC_Mocking_And_Spying' do

  it 'Testear el mockeo y desmockeo del metodo de una clase' do
    personaHome = PersonaHome.new
    # Antes del mocking
    expect(personaHome.devolver_un_string).to eq('Original')

    # Mocking
    PersonaHome.mockear(:devolver_un_string) {'Fui mockeado!'}

    # Después del mocking
    expect(personaHome.devolver_un_string).to eq('Fui mockeado!')

    # Funcionalidad del desmockeo
    #PersonaHome.desmockear
    #expect(personaHome.devolver_un_string).to eq('Original')
  end

  it 'Verificar que el metodo mockeado vuelve a ser el original luego del testing' do
    # Antes del testing
    expect(PersonaHome.new.todas_las_personas).to eq(['Servicio externo'])

    # Testing
    resultado = TADsPec.testear(PersonaHomeTests, :testear_que_personas_viejas_trae_solo_a_los_viejos)

    # Después del testing
    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_personas_viejas_trae_solo_a_los_viejos)).to eq(true)
    expect(PersonaHome.new.todas_las_personas).to eq(['Servicio externo'])
  end

  it 'Ejecutar un test con multiples metodos mockeados' do
    # Testing
    resultado = TADsPec.testear(PersonaHomeTests, :testear_que_se_pueden_mockear_multiples_metodos)

    # Después del testing
    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_se_pueden_mockear_multiples_metodos)).to eq(true)

    personaHome = PersonaHome.new
    expect(personaHome.todas_las_personas).to eq(['Servicio externo'])
    expect(personaHome.devolver_un_string).to eq('Original')
    expect(personaHome.abecedario).to eq(['Abecedario'])
  end

  it 'Ejecutar suite de tests con mocking' do
    resultado = TADsPec.testear(PersonaHomeTests)

    expect(resultado.resultados.length).to eq(3)
    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_personas_viejas_trae_solo_a_los_viejos)).to eq(true)
    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_devolver_un_string_retorna_fui_mockeado)).to eq(true)
    expect(resultado.paso_test?(PersonaHomeTests, :testear_que_se_pueden_mockear_multiples_metodos)).to eq(true)
  end

  it 'Testear que el objeto espiado entiende los mensajes del objeto original' do
    pato = Persona.new(23)
    context = Object.new.extend(Spying)
    pato_espiado = context.espiar(pato)

    expect(pato_espiado.viejo?).to be_falsey
    expect(pato_espiado.rico?).to be_truthy
    expect(pato_espiado.saludar).to eq('Hola')
    expect(pato_espiado.sacar_repetidos(1, 1, 2, 3, 4, 4, 4)).to eq([1, 2, 3, 4])
  end

  it 'Testear que el objeto espiado registra las llamadas de un metodo' do
    pato = Persona.new(23)
    context = Object.new.extend(Spying)
    pato_espiado = context.espiar(pato)

    pato_espiado.viejo?
    pato_espiado.rico?
    pato_espiado.saludar
    pato_espiado.sacar_repetidos(1, 1, 2, 3, 4, 4, 4)

    expect([:viejo?, :rico?, :saludar, :sacar_repetidos].all? {|m| pato_espiado.spied_methods.member?(m)}).to eq(true)
  end

  it 'Ejecutar test donde se espia a un objeto' do
    resultado = TADsPec.testear(SpyingSuiteTests, :testear_que_se_use_la_edad)

    expect(resultado.paso_test?(SpyingSuiteTests, :testear_que_se_use_la_edad)).to eq(true)
  end

  it 'Ejecutar test de spying que verifica cantidad de llamadas' do
    resultado = TADsPec.testear(SpyingSuiteTests, :testear_que_se_use_la_edad_cinco_veces)

    expect(resultado.fallo_test?(SpyingSuiteTests, :testear_que_se_use_la_edad_cinco_veces)).to eq(true)
  end

  it 'Ejecutar test de spying que verifica argumentos recibidos' do
    resultado = TADsPec.testear(SpyingSuiteTests, :testear_que_se_se_llamo_a_viejo_con_dos_argumentos)

    expect(resultado.fallo_test?(SpyingSuiteTests, :testear_que_se_se_llamo_a_viejo_con_dos_argumentos)).to eq(true)
  end
=begin
  it 'Ejecutar test de spying que verifica nil como argumento recibido' do
    resultado = TADsPec.testear(SpyingSuiteTests, :ttestear_que_se_se_llamo_a_viejo_sin_argumentos)

    expect(resultado.paso_test?(SpyingSuiteTests, :testear_que_se_se_llamo_a_viejo_sin_argumentos)).to eq(true)
  end
=end
  it 'Testear que test de spying falla con un objeto que no fue espiado' do
    resultado = TADsPec.testear(SpyingSuiteTests, :testear_que_se_lean_recibio_mensaje_viejo)

    expect(resultado.fallo_test?(SpyingSuiteTests, :testear_que_se_lean_recibio_mensaje_viejo)).to eq(true)
  end

end