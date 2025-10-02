// PAQUETES
object paquete {
  var pago = true
  var destino = puenteDeBrooklyn

  method faltaPago(){
    pago = false
  }

  method estaPago() = pago

  method cambiarDestino(nuevoDestino){
    destino = nuevoDestino
  }

  method puedeEntregar(mensajero){
    return self.estaPago() && destino.dejarEntrar(mensajero)
  }

  method precio() = 50
}

object paquetito {
  method estaPago() = true
  method puedeEntregar(mensajero) = true
  method precio() = 0
}

object paqueton {
  const destinos = []
  var montoPagado = 0

  method agregarDestino(destino){
    destinos.add(destino)
  }

  method precio() = destinos.size() * 100

  method pagar(monto){
    montoPagado += monto
  }

  method estaPago() = montoPagado >= self.precio()

  method puedeEntregar(mensajero){
    return self.estaPago() && destinos.all{destino => destino.dejarEntrar(mensajero)}
  }
}

// DESTINOS

object puenteDeBrooklyn {
  method dejarEntrar(mensajero){
    return mensajero.peso() <= 1000
  }
}

object laMatrix {
  method dejarEntrar(mensajero){
    return mensajero.puedeLlamar()
  }
}

// MENSAJEROS

object roberto {
  var vehiculo = bicicleta
  const peso = 50

  method cambiarVehiculo(nuevoVehiculo){
    vehiculo = nuevoVehiculo
  }

  method peso() = peso + vehiculo.peso()

  method puedeLlamar() = false
}

object chuck {
  method peso() = 80

  method puedeLlamar() = true
}

object neo {
  var tieneCredito = true
  method peso() = 0

  method gastarCredito(){
    tieneCredito = false
  }

  method puedeLlamar() = tieneCredito
}

// VEHICULOS

object bicicleta {
  method peso() = 5
}

object camion {
  var cantidadAcoplados = 1
  
  method agregarAcoplados(){
    cantidadAcoplados += 1
  }

  method quitarAcoplados(){
    cantidadAcoplados -= 1
  }
  
  method peso() = cantidadAcoplados * 500
}

// EMPRESA

object empresa {
  const mensajeros = [chuck, neo, roberto]
  const paquetesPendientes = []
  const paquetesEnviados = []

  method contratar(mensajero){
    mensajeros.add(mensajero)
  }

  method despedir(mensajero){
    mensajeros.remove(mensajero)
  }

  method despedirATodos(){
    mensajeros.clear()
  }

  method esGrande(){
    return mensajeros.size() > 2
  }

  method puedeEntregarPrimero(paquete){
    return paquete.puedeEntregar(self.primerMensajero())
  }

  method primerMensajero(){
    return mensajeros.first()
  }

  method pesoUltimoMensajero(){
    return self.ultimoMensajero().peso()
  }

  method ultimoMensajero(){
    return mensajeros.last()
  }

  method puedeEntregar(paquete){
    return mensajeros.any{m => paquete.puedeEntregar(m)}
  }

  method mensajerosQuePueden(paquete){
    return mensajeros.filter{m => paquete.puedeEntregar(m)}
  }

  method tieneSobrePeso(){
    return (mensajeros.map{m => m.peso()}.average()) > 500
  }

  method enviar(paquete){
    if(self.mensajerosQuePueden(paquete).isEmpty()) {
      paquetesPendientes.add(paquete)
    }
    else {
      paquetesEnviados.add(paquete)
    }
  }

  method facturacion(){
    return paquetesEnviados.map{p => p.precio()}.sum()
  }

  method enviarTodos(paquetes){
    paquetes.forEach{p => self.enviar(p)}
  }

  method enviarPendienteMasCaro(){
    if(not paquetesPendientes.isEmpty()){
      self.enviar(self.pendienteMasCaro())
      paquetesPendientes.remove(self.pendienteMasCaro())
    }
  }

  method pendienteMasCaro(){
    return paquetesPendientes.max{p => p.precio()}
  }
}