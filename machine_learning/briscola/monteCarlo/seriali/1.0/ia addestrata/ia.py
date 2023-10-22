from random import randint
from random import random
import pickle

def puntiCarta(carta):
    # 0=asso, 1=due, 2=tre ... 9=dieci
    # sommo +1 alla carta per semplicita'
    # del calcolo dei punti
    valore = (carta%10) + 1
    if valore == 1: return 11
    if valore == 3: return 10
    if valore < 8: return 0
    return valore - 6

def nomeCarta(carta):
    seme = int(carta/10)
    numero = str((carta%10) + 1)
    if seme == 0: return numero + " di denara"
    if seme == 1: return numero + " di spade"
    if seme == 2: return numero + " di bastoni"
    return numero + " di coppe"

def haPresoIlPrimo(briscola, cartaTirataPerPrima, cartaTirataPerSeconda):
    seme0 = int(cartaTirataPerPrima/10)
    seme1 = int(cartaTirataPerSeconda/10)
    if seme0 == seme1:
        if puntiCarta(cartaTirataPerPrima) > puntiCarta(cartaTirataPerSeconda): return True
        if puntiCarta(cartaTirataPerPrima) < puntiCarta(cartaTirataPerSeconda): return False
        return cartaTirataPerPrima > cartaTirataPerSeconda
    if seme0 == briscola: return True
    if seme1 == briscola: return False
    return True

class Mazzo():
    def __init__(self):
        self.carte = []
        for carta in range (0,40):
            self.carte.append(carta)

    def carteRimaste(self):
        return len(self.carte)

    def pesca(self):
        if self.carteRimaste() == 1:
            return self.carte.pop()
        n = randint(0, self.carteRimaste()-1)
        return self.carte.pop(n)

class GiocatoreIA():
    def __init__(self):
        self.mano = []
        self.punti = 0
        self.ia = {}

    def reset(self):
        self.mano = []
        self.punti = 0

    def aggiungiInMano(self, carta):
        self.mano.append(carta)
        self.mano.sort()
        # ordinando le carte in mano in base al numero
        # viene ridotto il numero di stati possibili (di
        # un fattore 6) in quanto smette di essere rilevante
        # l'ordine, velocizzando l'addestramento

    def aggiungiPunti(self, punti):
        self.punti += punti

    def statoCarta(self, carta):
        seme = int(carta/10)
        punti = puntiCarta(carta)
        if 0<punti<10:
            punti=1
        if punti>=10:
            punti=2
        return (seme, punti)

    def statoMano(self):
        statoMano = tuple()
        for carta in self.mano:
            statoMano += self.statoCarta(carta)
        return statoMano

    def tira(self, statoPartita):
        statoMano = self.statoMano()
        stato = statoMano+statoPartita
        azione = self.azioneMigliore(stato)
        return self.mano.pop(azione)

    def valore(self, stato, azione):
        if self.ia.get((azione,)+stato) == None:
            return 0
        (value,_) = self.ia.get((azione,)+stato)
        return value

    def azioneMigliore(self, stato):
        carteInMano = len(self.mano)
        if carteInMano == 1: # non c'è nulla da scegliere
            return 0
        valoriAzioni = []
        for i in range(carteInMano):
            valoriAzioni.append(self.valore(stato,i))
        if valoriAzioni.count(0) == carteInMano: # se sono tutti 0 i
            # valori vuol dire che probabilmente non sono stati
            # esplorati, quindi la mossa viene scelta casualmente
            return randint(0,carteInMano-1)
        massimo = max(valoriAzioni)
        return valoriAzioni.index(massimo)

class GiocatoreCasuale(GiocatoreIA):
    def __init__(self):
        self.mano = []
        self.punti = 0

    def reset(self):
        self.mano = []
        self.punti = 0

    def aggiungiInMano(self, carta):
        self.mano.append(carta)
        # in questo caso non ordiniamo le carte in
        # modo da rendere le mosse più casuali possibili

    def aggiungiPunti(self, punti):
        self.punti += punti

    def tira(self, statoPartita):
        return self.mano.pop(0) # tira sempre la prima tanto
        # e' essa stessa casuale

class GiocatoreUmano(GiocatoreIA):
    def __init__(self):
        self.mano = []
        self.punti = 0

    def reset(self):
        self.mano = []
        self.punti = 0

    def aggiungiInMano(self, carta):
        self.mano.append(carta)

    def aggiungiPunti(self, punti):
        self.punti += punti

    def tira(self, statoPartita):
        print("Carte in mano: ", end="")
        for carta in self.mano:
            print("[",nomeCarta(carta), "] ", sep="", end="")
        print("")
        index = int(input("Posizione carta da tirare: "))
        return self.mano.pop(index) # tira sempre la prima tanto
        # e' essa stessa casuale

class Briscola():
    def __init__(self):
        with open('ia.pk1', 'rb') as fp:
            ia = pickle.load(fp)
        with open("infos.pk1", "rb") as fp:
            infos = pickle.load(fp)
        self.giocatoreIA = GiocatoreIA()
        self.giocatoreIA.ia = ia
        self.tempoTotaleAddestramento = infos["tempoTotaleAddestramento"]
        self.totalePartiteGiocateAddestramento = infos["totalePartiteGiocateAddestramento"]
        self.giocatoreCasuale = GiocatoreCasuale()
        self.giocatoreUmano = GiocatoreUmano()

    def reset(self, vsUmano):
        self.mazzo = Mazzo()
        self.giocatoreIA.reset()
        self.giocatoreCasuale.reset()
        self.giocatoreUmano.reset()
        self.cartaInFondo = self.mazzo.pesca()
        # infos stato generico partita per l'ia
        self.briscola = int(self.cartaInFondo/10)
        self.valoreCartaInFondoAlmeno10 = (puntiCarta(self.cartaInFondo)>=10)
        self.carichiUsciti = 0
        # scelto chi inizia
        turnoDelGiocatoreIA = randint(0,1)
        if vsUmano:
            if turnoDelGiocatoreIA == 0:
                self.giocatoreTiraPerPrimo = self.giocatoreIA
                self.giocatoreTiraPerSecondo = self.giocatoreUmano
            else:
                self.giocatoreTiraPerPrimo = self.giocatoreUmano
                self.giocatoreTiraPerSecondo = self.giocatoreIA
        else:
            if turnoDelGiocatoreIA == 0:
                self.giocatoreTiraPerPrimo = self.giocatoreIA
                self.giocatoreTiraPerSecondo = self.giocatoreCasuale
            else:
                self.giocatoreTiraPerPrimo = self.giocatoreCasuale
                self.giocatoreTiraPerSecondo = self.giocatoreIA
        for _ in range(3):
            self.fasePescata()

    def step(self, vsUmano): # un turno
        carteNelleMani = self.giocatoreTiraPerPrimo.mano + self.giocatoreTiraPerSecondo.mano
        carteSenzaDuplicati = list(set(carteNelleMani))
        assert len(carteNelleMani) == len(carteSenzaDuplicati)
        # info per lo stato da dare all'ia
        puntiPrimoGiocatoreAlmeno45 = self.giocatoreTiraPerPrimo.punti > 45
        puntiSecondoGiocatoreAlmeno45 = self.giocatoreTiraPerSecondo.punti > 45
        # primo tiro
        statoPartita = (puntiPrimoGiocatoreAlmeno45, puntiSecondoGiocatoreAlmeno45,
                        self.briscola, self.valoreCartaInFondoAlmeno10,
                        self.carichiUsciti)
        cartaTirataPerPrima = self.giocatoreTiraPerPrimo.tira(statoPartita)
        if vsUmano and (self.giocatoreTiraPerSecondo == self.giocatoreUmano):
            print("carta tirata da IA:", nomeCarta(cartaTirataPerPrima))
        # secondo tiro
        statoCartaTirataPerPrima = self.giocatoreTiraPerSecondo.statoCarta(cartaTirataPerPrima)
        statoPartita = (puntiSecondoGiocatoreAlmeno45, puntiPrimoGiocatoreAlmeno45,
                        self.briscola, self.valoreCartaInFondoAlmeno10,
                        self.carichiUsciti) + statoCartaTirataPerPrima
        cartaTirataPerSeconda = self.giocatoreTiraPerSecondo.tira(statoPartita)
        if vsUmano and (self.giocatoreTiraPerPrimo == self.giocatoreUmano):
            print("carta tirata da IA:", nomeCarta(cartaTirataPerSeconda))
        # aggiornamento stato generico
        if puntiCarta(cartaTirataPerPrima) >= 10:
            self.carichiUsciti += 1
        if puntiCarta(cartaTirataPerSeconda) >= 10:
            self.carichiUsciti += 1

        punti = puntiCarta(cartaTirataPerPrima) + puntiCarta(cartaTirataPerSeconda)
        if haPresoIlPrimo(self.briscola, cartaTirataPerPrima, cartaTirataPerSeconda):
            self.giocatoreTiraPerPrimo.aggiungiPunti(punti)
        else:
            self.giocatoreTiraPerSecondo.aggiungiPunti(punti)
            self.giocatoreTiraPerPrimo, self.giocatoreTiraPerSecondo = self.giocatoreTiraPerSecondo, self.giocatoreTiraPerPrimo

        if self.mazzo.carteRimaste() >= 1:
            self.fasePescata()
        if vsUmano:
            print("Miei punti:", self.giocatoreUmano.punti)
            print("Punti IA:", self.giocatoreIA.punti, "\n")
        return self.partitaFinita()

    def fasePescata(self):
        if self.mazzo.carteRimaste() > 1:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerSecondo.aggiungiInMano(pescata)
        else:
            pescata = self.mazzo.pesca()
            self.giocatoreTiraPerPrimo.aggiungiInMano(pescata)
            self.giocatoreTiraPerSecondo.aggiungiInMano(self.cartaInFondo)

    def partitaFinita(self):
        return (self.giocatoreTiraPerPrimo.punti>60 or
                self.giocatoreTiraPerSecondo.punti>60 or
                (self.giocatoreTiraPerPrimo.punti==60 and self.giocatoreTiraPerSecondo.punti==60))

    def haVintoGiocatore0(self):
        return self.giocatoreIA.punti > 60

    def simulaControGiocatoreCasuale(self, numeroEpisodi=10_000):
        vinteDalGiocatoreIA = 0
        pareggiateDalGiocatoreIA = 0
        for i in range(numeroEpisodi):
            self.reset(vsUmano=False)
            finitaPartita = False
            while not finitaPartita:
                finitaPartita = self.step(vsUmano=False)
            if self.giocatoreIA.punti > 60:
                vinteDalGiocatoreIA += 1
            elif self.giocatoreIA.punti == 60:
                pareggiateDalGiocatoreIA += 1
            percent = "{:.2f}".format((i*100)/numeroEpisodi)
            print(f'\r{percent}%', end = '')
        print("\rStatistiche giocatore IA")
        print(" - Percentuale vittoria:   [", 100*vinteDalGiocatoreIA/numeroEpisodi,"%]", sep="")
        print(" - Percentuale pareggio:   [", 100*pareggiateDalGiocatoreIA/numeroEpisodi, "%]", sep="")
        sconfitteDelGiocatore0 = numeroEpisodi - vinteDalGiocatoreIA - pareggiateDalGiocatoreIA
        print(" - Percentuale sconfitta:  [", 100*sconfitteDelGiocatore0/numeroEpisodi, "%]", sep="")

    def printInfosAddestramento(self):
        secondi = int(self.tempoTotaleAddestramento)
        minuti = int(secondi/60)
        secondi = secondi%60
        ore = int(minuti/60)
        minuti = minuti%60
        print("Tempo totale addestramento IA:")
        print(" - ", ore, "h ", minuti, "m ", secondi, "s", sep="")
        totaleStatiEsplorati = len(self.giocatoreIA.ia)
        print("Totale stati esplorati:", totaleStatiEsplorati)
        print("Totale partite addestramento ia:", self.totalePartiteGiocateAddestramento)
        
    def giocaControIA(self):
        while True:
            print()
            print("Inizio partita umano vs IA")
            self.reset(vsUmano = True)
            finitaPartita = False
            print("Carta in fondo:", nomeCarta(self.cartaInFondo), "\n")
            while not finitaPartita:
                finitaPartita = self.step(vsUmano=True)
            if self.giocatoreUmano.punti > 60:
                print("Hai vinto")
            elif self.giocatoreUmano.punti == 60:
                print("Pareggio")
            else:
                print("Hai perso")

env = Briscola()
env.printInfosAddestramento()
env.simulaControGiocatoreCasuale()
env.giocaControIA()