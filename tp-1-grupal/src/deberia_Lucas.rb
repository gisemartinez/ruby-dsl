module Deberia
  attr_accesors :mensaje

  menor_a = Proc.new { |valor|
    unless valor > self
     mensaje= "Se esperaba que #{self} fuera menor que #{valor}."
    end
    return Proc.new {|x| valor > x}
  }

  mayor_a = Proc.new {|valor|
    unless valor < self
      mensaje= "Se esperaba que '#{self}' fuera mayor que #{valor}."
    end
    return Proc.new {|x| valor < x}
  }

  uno_de_estos = Proc.new{|*varargs|
    if varargs.first.class.is_a?(Array)
      unless varargs.first.include?(self)
        mensaje= "Se esperaba que #{self} estuviese contenido en '#{varargs.first}'."
      end
    else
      this = self
      unless varargs.any? {|valor| valor == this}
        mensaje= "Se esperaba que #{self} fuera uno de estos valores '#{varargs}'."
      end
    end
  }

  ser = Proc.new{|&bloque|
    self.instance_eval(bloque)
  }

  entender = Proc.new{|mensaje|
    unless self.respond_to?(mensaje, include_all=true)
      raise AssertionError, "Se esperaba que #{self} entendiera el mensaje '#{mensaje}'."
    end
  }

  tener = Proc.new{|atributo|
  }

  explotar_con = Proc.new{|nombre_excepcion|
    metodo = self.to_proc.clone
    begin
      metodo.call
    rescue nombre_excepcion
    else
      # entra acá si no se produjo la excepción indicada
      mensaje= "Se esperaba que #{self} explotara con la excepción '#{excepcion}'."
    end
  }

  def deberia(valorEsperado)
    # ejecuta la configuración recibida como parámetro:
    unless valorEsperado
    raise AssertionError, mensaje
    end
    return valorEsperado
  end

end

class AssertionError < StandardError;
end