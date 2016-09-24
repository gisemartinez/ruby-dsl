require '../src/deberia'

class MockedMethod
  attr_accessor :name, :body

  def initialize(name, body)
    self.name = name
    self.body = body
  end
end

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
    (self.spied_methods = Hash.new) if self.spied_methods.nil?

    if self.spied_methods.has_key?(symbol)
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

class SpyingAssertionMethod < AssertionMethod
  attr_accessor :metodo

  def initialize(mensaje, prok, metodo)
    self.mensaje = mensaje
    self.bloque = prok
    self.metodo = metodo
  end

  def veces(cantidad)
    self.bloque = Proc.new { |x| next x.metodo_espiado(metodo).calls == cantidad }
    self
  end

  def con_argumentos(*args)
    self.bloque = Proc.new { |x|
      next x.metodo_espiado(metodo).arguments.include?(args.to_a) }
    self
  end
end

module Spying
  def haber_recibido(metodo)
    SpyingAssertionMethod.new("haya sido espiado", Proc.new { |x|
      if x.is_a?(Espiable)
        next x.metodo_espiado(metodo).calls > 0
      else
        next false
      end
    }, metodo)
  end

  def espiar(objeto)
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
