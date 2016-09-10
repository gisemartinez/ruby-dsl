module MetodoDeberia

  # TODO:
  #    - ser sin parámetro alguno
  #    - tener_atributo
  #    - ser_consulta?

  #En el contexto de una suite:
  #(1) unaSuite.mayor_a(3)
  #(2) unaSuite.ser(1)
  #(3) 7.deberia(2)
  # 7.deberia(ser(mayor_a(3)))

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

  def uno_de_estos(*varargs)
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

  def ser(argumento)
    if argumento.is_a?(Object)
      begin
        self == arg
      rescue AssertionError => mensaje
        raise AssertionError, mensaje
      end
    else
      begin
       # ejecuta la consulta recibida como parámetro:
        verificacion_de_rango = argumento
        self.instance_eval { verificacion_de_rango }
     rescue AssertionError => mensaje
        raise AssertionError, mensaje
      end
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
    # ejecuta la configuración recibida como parámetro:
    self.instance_eval { configuracion }
  end

end

#--------------------------------------
#  EXCEPCIÓN PARA VER SI PASÓ O FALLÓ:
#--------------------------------------
class AssertionError < StandardError;
end