# encoding: utf-8
#-------------------------------------------
#  DATA CLASS PARA LOS MÉTODOS DE ASERCIÓN:
#-------------------------------------------
class AssertionMethod
  attr_accessor :mensaje, :bloque

  def initialize(mensaje, prok)
    self.mensaje = mensaje
    self.bloque = prok
  end

  def call(contexto)
    self.bloque.call(contexto)
  end
end

#-----------------------------------------------------
#  COMPORTAMIENTO NECESARIO PARA EL MÉTODO 'DEBERÍA':
#-----------------------------------------------------
module Assertion
  def ser(argument)
    # TODO: para pensar
    # bien detectada la diferencia entre otras condiciones y valores finales (equals)
    # (si les molesta como a mi tener este if porque rompe el polimorfismo del parametro del "ser"
    #   pueden alterar el dsl para que usar equals sea "3.deberia ser igual_a 1")
    # ¿Si el nuevo dsl anterior fuera el caso, que comportamiento tiene el "ser"? ¿para qué sirve?
    #if argument.is_a?(AssertionMethod)
      argument
    # else
    #   AssertionMethod.new(
    #       "fuera igual a '#{argument}'",
    #       Proc.new { |x| next x == argument })
    # end
  end

  def entender(mensaje)
    AssertionMethod.new(
        "entendiera el mensaje '#{mensaje}'",
        Proc.new { |x| next x.respond_to?(mensaje, include_all=true) })
  end

  def explotar_con(nombre_excepcion)
    AssertionMethod.new(
        "explotara con la excepción '#{nombre_excepcion}'",
        Proc.new { |prok|
          begin
            prok.call
          rescue nombre_excepcion
            true
          else
            false
          end
        })
  end

  def obtener_atributo(atributo)
    if (self.respond_to?(atributo))
      self.send(atributo)
    elsif self.instance_variable_defined?("@#{atributo}")
      self.instance_variable_get("@#{atributo}")
    else
      nil
    end
  end

  def tener_un_atributo(atributo, argument)
    if argument.is_a?(AssertionMethod)
      AssertionMethod.new(
          ": atributo '#{atributo}' #{argument.mensaje}",
          Proc.new { |x| next argument.call(x.obtener_atributo(atributo)) })
    else
      AssertionMethod.new(
          ": atributo '#{atributo}' fuera igual a '#{argument}'",
          Proc.new { |x| next x.obtener_atributo(atributo) == argument })
    end
  end

  def ser_una_consulta(consulta)
    AssertionMethod.new(
        "fuera '#{consulta}'",
        Proc.new { |x| next x.send(consulta) })
  end

  def method_missing(symbol, *args)
    method_size = symbol.to_s.length
    if symbol.to_s[0..3] == 'ser_'
      self.ser_una_consulta(((symbol.to_s[4..method_size]) + '?').to_sym)
    elsif symbol.to_s[0..5] == 'tener_'
      self.tener_un_atributo(symbol.to_s[6..method_size].to_sym, args[0])
    else
      super(symbol, args)
    end
  end
end

module AssertionConfiguration
  def mayor_a(valor)
    AssertionMethod.new(
        "fuera mayor a '#{valor}'",
        Proc.new { |x| next x > valor })
  end

  def menor_a(valor)
    AssertionMethod.new(
        "fuera menor a '#{valor}'",
        Proc.new { |x| next x < valor })
  end

  def igual_a(valor)
    AssertionMethod.new(
        "fuera igual a '#{valor}'",
        Proc.new { |x| next x == valor })
  end

  def uno_de_los_varargs(*arguments)
    AssertionMethod.new(
        "fuera uno de estos valores '#{arguments}'",
        Proc.new { |x| next *arguments.include?(x) })
  end

  def uno_de_la_lista(lista)
    AssertionMethod.new(
        "estuviese contenido en '#{lista}'",
        Proc.new { |x| next lista.include?(x) })
  end

  def uno_de_estos(*arguments)
    if arguments.length > 1
      uno_de_los_varargs(arguments)
    else
      uno_de_la_lista(arguments.first)
    end
  end
end

module Deberia
  # TODO: CUIDADO! Cualquier objetos solo necesitan entender "debería"
  #include Assertion

  def deberia(assertion)
    assertion_result = assertion.call(self)
    assertion_message = "Se esperaba que '#{self}' #{assertion.mensaje}."
    raise AssertionError, assertion_message unless assertion_result
  end

  # TODO: CUIDADO! Este method missing aplicaría a todos los objetos!
  #  Solo necesita entender "ser_*" y "tener_*" la suite de test Y SOLO la suite de test
  # def method_missing(symbol, *args)
  #   method_size = symbol.to_s.length
  #   if symbol.to_s[0..3] == 'ser_'
  #     self.ser_una_consulta(((symbol.to_s[4..method_size]) + '?').to_sym)
  #   elsif symbol.to_s[0..5] == 'tener_'
  #     self.tener_un_atributo(symbol.to_s[6..method_size].to_sym, args[0])
  #   else
  #     super(symbol, args)
  #   end
  # end
end

#----------------------------------------------------
#  EXCEPCIÓN PARA VERIFICAR SI EL TEST PASÓ O FALLÓ:
#----------------------------------------------------
class AssertionError < StandardError;
end
