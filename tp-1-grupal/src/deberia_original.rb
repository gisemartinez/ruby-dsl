module MetodoDeberia

  # TODO:
  #    - ser sin parámetro alguno
  #    - tener_atributo
  #    - ser_consulta?

  #7.deberia(self.ser(7))
  #7.deberia ser 7
  #return if 7 == 7
  #true

  #7.deberia(self.ser(self.menor_a(7)))
  #7.deberia ser mayor_a 7
  #return if 7 > 7
  #false

  #-----------------------------------
  #  PARAMÉTROS DE LAS CONFIGURACIONES:
  #-----------------------------------
  def menor_a(valor)
    unless valor > self
      raise AssertionError, "Se esperaba que #{self} fuera menor que #{valor}."
    end
  end

  def mayor_a(valor)
    unless valor < self
      raise AssertionError, "Se esperaba que '#{self}' fuera mayor que #{valor}."
    end
  end

  def es_uno_de(*varargs)
    if varargs.first.class.is_a?(Array)
      unless varargs.first.include?(self)
        raise AssertionError, "Se esperaba que #{self} estuviese contenido en '#{varargs.first}'."
      end
    else
      this = self
      unless varargs.any? {|valor| valor == this}
        raise AssertionError, "Se esperaba que #{self} fuera uno de estos valores '#{varargs}'."
      end
    end
  end

  #-----------------------------------
  #  CONFIGURACIONES:
  #-----------------------------------

  def ser(verificacion_de_rango)
    begin
      # 'self' ejecuta la consulta de su argumento:
      verificacion_de_rango
    rescue AssertionError => mensaje
      raise AssertionError, mensaje
    end
  end

  def entender(mensaje)
    unless self.respond_to?(mensaje, include_all=true)
      raise AssertionError, "Se esperaba que #{self} entendiera el mensaje '#{mensaje}'."
    end
  end

  def explotar_con(nombre_excepcion)
    metodo = self.to_proc.clone
    begin
      metodo.call
    rescue nombre_excepcion
    else
      # entra acá si no se produjo la excepción indicada
        raise AssertionError, "Se esperaba que #{self} explotara con la excepción '#{excepcion}'."
    end
  end

  def deberia(configuracion)
    # 'self' ejecuta la configuración de sus argumento:
    configuracion
  end

end

#--------------------------------------
#  EXCEPCIÓN PARA VER SI PASÓ O FALLÓ:
#--------------------------------------
class AssertionError < StandardError;
end