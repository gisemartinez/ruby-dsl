module MetodoDeberia

  #7.deberia(self.ser(7))
  #7.deberia ser 7
  #7 == 7
  #true

  #7.deberia(self.ser(self.menor_a(7)))
  #7.deberia ser mayor_a 7
  #7 > 7
  #false

end

#--------------------------------------
#  EXCEPCIÓN PARA VER SI PASÓ O FALLÓ:
#--------------------------------------
class AssertionError < StandardError;
end

class Configuracion
end

class Ser < Configuracion;
  def initialize()
  end
end

class Tener < Configuracion;
  def initialize()
  end
end

class Entender < Configuracion;
  def initialize()
  end
end

class ExplotarCon < Configuracion;
  def initialize()
  end
end