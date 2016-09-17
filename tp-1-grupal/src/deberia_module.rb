module DeberiaModule

  @@test_message = ''

  def mayor_a(valor)
    @@test_message = "Se esperaba que #{self} fuera mayor a '#{valor}'."
    return Proc.new { |x| next x > valor }
  end

  def menor_a(valor)
    @@test_message = "Se esperaba que #{self} fuera menor a '#{valor}'."
    return Proc.new { |x| next x < valor }
  end

  def uno_de_los_varargs(*arguments)
    @@test_message = "Se esperaba que #{self} fuera uno de estos valores '#{arguments}'."
    return Proc.new { |x| next arguments.any? {|valor| valor == x } }
  end

  def uno_de_la_lista(lista)
    @@test_message = "Se esperaba que #{self} estuviese contenido en '#{lista}'."
    return Proc.new { |x| next lista.include?(x) }
  end

  def uno_de_estos(*arguments)
    if arguments.length > 1
      # Case 1: varargs
      uno_de_los_varargs(arguments)
    else
      # Case 2: lista
      uno_de_la_lista(arguments.first)
    end
  end

  # Return a boolean
  def ser(argument)
    if argument.is_a?(Proc)
      return argument
    else
      @@test_message = "Se esperaba que #{self} fuera igual a '#{argument}'."
      return Proc.new { |x| next x == argument }
    end
  end

  def entender(mensaje)
    @@test_message = "Se esperaba que #{self} entendiera el mensaje '#{mensaje}'."
    return Proc.new { |x| next x.respond_to?(mensaje, include_all=true) }
  end

  def explotar_con(nombre_excepcion)
    @@test_message = "Se esperaba que #{self} explotara con la excepción '#{nombre_excepcion}'."
    return Proc.new do |&block|
                        begin
                          block.call
                        rescue nombre_excepcion
                          next true
                        else
                          next false
                        end
                    end
  end

  def deberia(assertion)
    assertion_result = assertion.call(self)
    raise AssertionError, @@test_message unless assertion_result
  end

  def tener_un_atributo(atributo, valor)
    @@test_message = "Se esperaba que #{self} tuviera el atributo'#{atributo}' igual a '#{valor}'."
    return Proc.new { |x| next x.send(atributo) == valor }
  end

  def ser_una_consulta(consulta)
    return Proc.new { |x| next x.send(consulta) }
  end

  def method_missing(symbol, *args)
    method_size = symbol.to_s.length
    if symbol.to_s[0..3] == 'ser_'
      # Case 1: ser_consulta
      ser_una_consulta(((symbol.to_s[4..method_size]) + '?').to_sym)
    elsif symbol.to_s[0..5] == 'tener_'
      # Case 2: tener_atributo
      tener_un_atributo(symbol.to_s[6..method_size].to_sym, args[0])
    else
      super(symbol, args)
    end
  end

end

#----------------------------------------------------
#  EXCEPCIÓN PARA VERIFICAR SI EL TEST PASÓ O FALLÓ:
#----------------------------------------------------
class AssertionError < StandardError;
end