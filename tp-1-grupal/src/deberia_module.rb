module DeberiaModule

  @test_message = ''

  def mayor_a(valor)
    return Proc.new { |x| next x > valor }
  end

  def menor_a(valor)
    return Proc.new { |x| next x < valor }
  end

  def uno_de_estos(*arguments)
    if arguments.length > 1
      # case 1: varargs
      @test_message = "Se esperaba que #{self} fuera uno de estos valores '#{arguments}'."
      return Proc.new { |x| next arguments.any? {|valor| valor == x } }
    else
      # case 2: lista
      @test_message = "Se esperaba que #{self} estuviese contenido en '#{arguments.first}'."
      return Proc.new { |x| next arguments.first.include?(x) }
    end
  end

  # return a boolean
  def ser(argument)
    if argument.is_a?(Proc)
      return argument
    else
      @test_message = "Se esperaba que #{self} fuera igual a '#{argument}'."
      return Proc.new { |x| next x == argument }
    end
  end

  def entender(mensaje)
    @test_message = "Se esperaba que #{self} entendiera el mensaje '#{mensaje}'."
    return Proc.new { |x| next x.respond_to?(mensaje, include_all=true) }
  end

  def explotar_con(nombre_excepcion)
    @test_message = "Se esperaba que #{self} explotara con la excepción '#{nombre_excepcion}'."
    return Proc.new do |&x|
                        operacion = x.to_proc
                        begin
                          operacion.call
                        rescue nombre_excepcion
                          next true
                        else
                          next false
                        end
                    end
  end

  def deberia(assertion)
    assertion_result = assertion.call(self)
    raise AssertionError, @test_message unless assertion_result
  end

end

#--------------------------------------
#  EXCEPCIÓN PARA VER SI PASÓ O FALLÓ:
#--------------------------------------
class AssertionError < StandardError;
end