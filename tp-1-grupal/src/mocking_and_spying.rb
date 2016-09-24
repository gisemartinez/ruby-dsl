require '../src/deberia'

# class MockedMethod
#   attr_accessor :name, :body
#
#   def initialize(name, body)
#     self.name = name
#     self.body = body
#   end
# end

# Más que el método, esta clase está modelando las llamadas a un objeto espiado.
class SpiedMethod
  attr_accessor :calls, :arguments

  def initialize(calls=0, *arguments)
    self.calls = calls
    self.arguments = Array.new(arguments.to_a)
  end
end

module Espiable
  attr_accessor :spied_methods

  def init_spying
    self.spied_methods = Hash.new
  end

  def registrar_llamada_del_metodo(symbol, *args)
    # TODO: o usan el "init_spying" o usan esta inicialización, no las dos juntas
    (self.spied_methods = Hash.new) if self.spied_methods.nil?

    if self.spied_methods.has_key?(symbol)
      # TODO: si bien es fino, que alguien llame a la instancia espiada con el mensaje "symbol"
      # no suma a todas las llamadas a "symbol". Es decir:
      #
      # pato = espiar(pato)
      # pato.comer("maiz")
      # pato.comer("maiz")
      # pato.comer("arroz")
      #
      # pato.deberia haber_recibido(:comer).veces(2).con_argumentos("maiz") # pasa
      # pato.deberia haber_recibido(:comer).veces(2).con_argumentos("maiz") # pasa
      # pato.deberia haber_recibido(:comer).veces(1).con_argumentos("arroz") # pasa
      # pato.deberia haber_recibido(:comer).con_argumentos("arroz") # pasa (por defaul veces es 1)
      # pato.deberia haber_recibido(:otra_cosa).veces(0) # pasa (nunca llamaron a "otra cosa")
      #
      # pato.deberia haber_recibido(:comer).veces(3) # NO pasa (no es lo mismo llamar a "comer" sin argumentos y llamar con argumentos)
      #
      # Es decir, la igualdad entre llamadas podemos definirla como el nombre del mensaje y la igualdad de todos sus parámetros.

      ++self.spied_methods[symbol].calls
      self.spied_methods[symbol].arguments.push(args.to_a)
    else
      self.spied_methods[symbol] = SpiedMethod.new(1, args)
    end
  end

  def metodo_espiado(symbol)
    self.spied_methods[symbol]
  end
end

# TODO: Para espiar, definan una sola vez el proc de validación del objeto
#   espiado (esta validación va a tener en cuenta el nombre del mensaje,
#   los valores de los argumentos y la cantidad de veces que ese mensaje
#   con esos argumentos fue invocado).

class SpyingAssertionMethod < AssertionMethod
  attr_accessor :metodo

  def initialize(mensaje, prok, metodo)
    self.mensaje = mensaje
    self.bloque = prok
    self.metodo = metodo
  end

  def veces(cantidad)
    # TODO: detalle
    # podrían hacer una nueva instancia de SpyingAssertionMethod cuando reciben "veces"
    # para que sea inmutable (es un atributo deseable de los objetos, van a ver más sobre esto en la
    # segunda parte de la materia)
    self.bloque = Proc.new { |x| next x.metodo_espiado(metodo).calls == cantidad }
    self
  end

  def con_argumentos(*args)
    self.bloque = Proc.new { |x|
      # TODO: CUIDADO! los argumentos de este método son los valores que yo espero que se usen para
      #   invocar la instancia. NO son symbols.
      # Tienen que guardar estos valores para poder compararlos con los que fue invocado.
      # El comportamiento podría estar delegado al método espiado
      next x.metodo_espiado(metodo).arguments.include?(args.to_a) }
    self
  end
end

module Spying
  def haber_recibido(metodo)
    SpyingAssertionMethod.new("haya sido espiado", Proc.new { |x|
      if x.is_a?(Espiable)
        # TODO: porque usan "next"?
        # TODO: este bloque está repetido, pueden definirlo
        next x.metodo_espiado(metodo).calls > 0
      else
        # TODO: si no es un espiable está bien que rompa, no está bien que diga que no fue
        #   llamado (no sabemos si lo llamaron o no). Sino podemos lanzar acá ese
        #   error (por ej. "la instancia no es espiable")
        next false
      end
    }, metodo)
  end

  def espiar(objeto)
    # TODO: CUIDADO! clonar el objeto no es un efecto deseado
    # porque estoy perdiendo la identidad (todos los lugares donde hubiera usado la misma
    # instancia no van a estar contemplados por el "espiar")
    # ¿porque necesitan clonar el objeto?
    espiado = objeto.clone.extend(Espiable)
    espiado.init_spying

    objeto.public_methods(false).each do |symbol|
      method = objeto.method(symbol)
      espiado.send :define_singleton_method, symbol do |*args|
        self.registrar_llamada_del_metodo(symbol, *args)
        self.instance_exec *args, &method
      end
    end
    espiado
  end

end
