class Aserciones

  #7.deberia(self.ser(7))
  #7.deberia ser 7
  #7.instance_eval ser 7 (Si ser fuese un bloque...)
  #7 == 7
  #true

  #7.deberia(self.ser(self.menor_a(7)))
  #7.deberia ser mayor_a 7
  #7.instance_eval mayor_a 7 (Si mayor_a fuese un bloque)
  #7 > 7
  #false

  #--------------------------------------
  # FIXTURE DE DATOS PARA HACER PRUEBAS:
  #--------------------------------------
  attr_accessor :valor

  def initialize(valor=10)
    self.valor = valor
  end

  def viejo?
    @edad > 29
  end

  def parametro_falso(valor)
    puts 'Funciona!'
  end
  #--------------------------------------

  #-----------------------------------
  #  PARAMÉTROS DE LAS CONFIGURACIONES:
  #-----------------------------------
  def menor_a(valor)
    unless valor > self
      raise AssertionError,
            "Se esperaba que #{self} fuera menor que #{valor}."
    end
  end

  def mayor_a(valor)
    unless valor < self
      raise AssertionError,
            "Se esperaba que #{self} fuera mayor que #{valor}."
    end
  end

  def es_uno_de(*varargs)
    if varargs.first.class.is_a?(Array)
      unless varargs.first.include?(self)
        raise AssertionError,
              "Se esperaba que #{self} estuviese contenido en '#{varargs.first}'."
      end
    else
      this = self
      unless varargs.any? {|valor| valor == this}
        raise AssertionError,
              "Se esperaba que #{self} fuera uno de estos valores '#{varargs}'."
      end
    end
  end

  #-----------------------------------
  #  CONFIGURACIONES:
  #-----------------------------------
  def ser(verificacion_de_rango)
    begin
      verificacion_de_rango
    rescue AssertionError => mensaje
      puts mensaje
    end
  end

  def entender(mensaje)
    unless self.respond_to?(mensaje, include_all=true)
      raise AssertionError,
            "Se esperaba que #{self} entendiera el mensaje '#{mensaje}'."
    end
  end

  def explotar_con(excepcion)
    # --- completar ---
    #unless TODO
     # raise AssertionError,
      #      "Se esperaba que #{self} explotara con la excepción '#{excepcion}'."
    #end
  end

  def deberia(configuracion)
    configuracion
  end

end

#--------------------------------------
#  EXCEPCIÓN PARA VER SI PASÓ O FALLÓ:
#--------------------------------------
class AssertionError < StandardError;
end