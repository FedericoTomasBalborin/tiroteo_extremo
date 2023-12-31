import wollok.game.*
import proyectiles.*
import plataformas.*
import niveles.*
import extras.*

//JUGADORES
class Jugador
{
	var property personaje
	var property vidas = 100
	var property energia = 100
	method direccionInicial()
	method posicionInicial()
	method controles()
	
	method asignarPersonaje() {
		personaje.jugador(self)
		personaje.position(self.posicionInicial())
		personaje.direccion(self.direccionInicial())
	}
	method recibeDanio(danioDisparo)
	{
		vidas -= danioDisparo
	}
	method gastarEnergia(gasto)
	{
		energia -= gasto
	}
	method sinEnergia() = energia <= 0
	method recargaEnergia(pocion) 
	{
		energia += pocion
	}
}

object jugador1 inherits Jugador(personaje = null){
	override method posicionInicial() = game.at(0,1)
	override method direccionInicial() = derecha
	override method controles()
	{
		keyboard.a().onPressDo({personaje.retroceder()})
		keyboard.d().onPressDo({personaje.avanzar()})
		keyboard.w().onPressDo({personaje.volar()})
		keyboard.j().onPressDo({personaje.disparo1()})
		keyboard.k().onPressDo({personaje.disparo2()})
		game.onTick(500,"caida",{=> personaje.caer()})
	}
	
	override method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador1()
		super()}
}

object jugador2 inherits Jugador(personaje = null){
	override method posicionInicial() = game.at(game.width()-1,0)
	override method direccionInicial() = izquierda
	override method controles()
	{
		keyboard.left().onPressDo({personaje.retroceder()})
		keyboard.right().onPressDo({personaje.avanzar()})
		keyboard.up().onPressDo({personaje.volar()})
		game.onTick(500,"caida",{=> personaje.caer()})
		keyboard.z().onPressDo({personaje.disparo1()})
		keyboard.x().onPressDo({personaje.disparo2()})
	}
	
	override method asignarPersonaje() {
		personaje = seleccionPersonajes.quienJugador2()
		super()
	}
}

//personajes jugables
class Personaje
{
	var property direccion = derecha //La orientacion a donde el personaje esta apuntando. Puede ser izquierda (izq) o derecha (der)
	var property estado = reposo
	var property position = game.origin()
	const property armamento
	var property jugador
	
	method image()= direccion.nombre() + estado.nombre() + ".png"
	
	method avanzar()
	{
		position = self.position().right(1)
		direccion = derecha
	}
	method interaccionCon(otroJugador)
	{
		otroJugador.avanzar()
		self.retroceder()
	}
	method retroceder()
	{
		position = self.position().left(1)
		direccion = izquierda
	}	
	//Metodos para volar y caer	
	method enElSuelo()= self.position().y()==1
	method volar()
	{
		if(not(jugador.sinEnergia())){
		jugador.gastarEnergia(1)
		position = self.position().up(2)}
	}
	method caer() //Cuando dejé de volar
	{
		 if(not self.enElSuelo())
		 {
		 	position = self.position().down(1)
		 }
	}
	
	method disparo1()
	{
		if(not(jugador.sinEnergia())){
		estado = ataque
		jugador.gastarEnergia(5)
		armamento.dispararProyectil1(self)}
	}
	method disparo2()
	{
		if(not(jugador.sinEnergia())){
		estado = ataque
		jugador.gastarEnergia(5)
		armamento.dispararProyectil2(self)}
	}
	
}


class PoolYui inherits Personaje(armamento = armamentoYui)
{
	override method image() = "elr_" + super()

}

class Zipmata inherits Personaje(armamento = armamentoZipmata)
{
	override method image() = "char_" + super()
}

class EagleMan inherits Personaje(armamento = armamentoEagleMan)
{
	override method image() = "eag_" + super()
}